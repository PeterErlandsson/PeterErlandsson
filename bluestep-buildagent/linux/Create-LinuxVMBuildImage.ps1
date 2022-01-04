[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet('test','prod')]
    $environment = 'test',

    [Parameter()]
    [string]
    $DockerVersion = "20.10.7",

    [Parameter()]
    [string]
    $containerdVersion = '1.4.9-1',

    [Parameter()]
    [string]
    $KubectlVersion = 'latest',
    
    [Parameter()]
    [string]
    $ResourceGroup = 'rg-build',
    
    [Parameter(Mandatory)]
    [string]
    $subscriptionID,
    
    [string]
    [Parameter()]
    [string]
    $location = 'West Europe'
)

try {
    Select-AzSubscription $subscriptionID
} catch {
    throw
}

$ResourceGroupName = "$ResourceGroup-$environment"
$ComputerName = "vm-linuxbuild"
$VMScaleSetComputerPrefix = 'linux'
$Adminuser = "REDACTED!"
$password = 'REDACTED!'
$VMLocalAdminSecurePassword = ConvertTo-SecureString $password -AsPlainText -Force
# To be changed to a new build network
if ($environment -eq 'prod') {
    $SubnetId = '/subscriptions/373ea7c9-4c36-440b-a23a-f2ded206dbe4/resourceGroups/rg-spoke-production/providers/Microsoft.Network/virtualNetworks/vnet-infrastructure-production/subnets/snet-buildagent-test'
} elseif ($environment -eq 'test') {
    $SubnetId = '/subscriptions/86d71566-8cbd-4e51-a115-fd7e0df0c3a0/resourceGroups/rg-spoke-test/providers/Microsoft.Network/virtualNetworks/vnet-infrastructure-test/subnets/snet-buildagent-test'
} else {
    throw "Environment $environment is not supported."
}
$VMName = "vm-linuxbuild-2004-$environment-$dockerversion"
$VMSize = "Standard_D4s_v4"

New-AzResourceGroup -Name $ResourceGroupName -Location $location -confirm:$false -force
$NIC = New-AzNetworkInterface -Name "$Vmname-nic-01" -ResourceGroupName $ResourceGroupName -Location $location -SubnetId $SubnetId

$Credential = New-Object System.Management.Automation.PSCredential ($Adminuser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName $ComputerName -Credential $Credential
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'canonical' -Offer '0001-com-ubuntu-server-focal' -Skus '20_04-lts' -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $location -VM $VirtualMachine

$InstallScript = get-content -Path .\InstallApps.sh
$InstallScript -replace 'placeholderDocker', $DockerVersion | Set-content .\InstallApps.sh
$InstallScript = get-content -Path .\InstallApps.sh
$InstallScript -replace 'placeholderContainerd', $containerdVersion | Set-content .\InstallApps.sh
$InstallScript = get-content -Path .\InstallApps.sh
if ($KubectlVersion -eq 'latest') {
    $kubeUrl = 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'
} else {
    $kubeUrl = "https://dl.k8s.io/release/v$KubectlVersion/bin/linux/amd64/kubectl"
}
$InstallScript -replace 'placeholderKubectl', $kubeUrl | Set-content .\InstallApps.sh

$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName = $VMName 
    CommandId = 'RunShellScript'
    ScriptPath = '.\InstallWAAgent.sh'
}
Invoke-AzVMRunCommand @params

$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName = $VMName 
    CommandId = 'RunShellScript'
    ScriptPath = '.\InstallApps.sh'
}
Invoke-AzVMRunCommand @params

"Now generalizing the image."
$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName = $VMName 
    CommandId = 'RunShellScript'
    ScriptPath = '.\GeneralizeImage.sh'
}
Invoke-AzVMRunCommand @params

Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
Set-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Generalized 
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName
$Image = New-AzImageConfig -Location $location -SourceVirtualMachineId $vm.id -Tag @{
    'DockerVersion' = $DockerVersion
    'KubectlVersion' = $KubectlVersion
    'Environment' = $environment
    'BuildDate' = $(Get-Date -format "yyyy-MM-dd HH:mm").ToString()
}
$Image = New-AzImage -Image $Image -ImageName "Bluestep-Linux2004BuildAgent$(Get-Date -format yyyyMMddHHmm)" -ResourceGroupName $ResourceGroupName 

$ipConfig = New-AzVmssIpConfig -Name "IPConfig" -SubnetId $SubnetId
$vmssConfig = New-AzVmssConfig -Location $location -SkuCapacity 1 -SkuName $VMSize -UpgradePolicyMode "Manual" -SinglePlacementGroup $false
Set-AzVmssStorageProfile $vmssConfig -OsDiskCreateOption "FromImage" -ImageReferenceId $Image.id
Add-AzVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name "network-config" -Primary $true -IPConfiguration $ipConfig 
Set-AzVmssOsProfile -AdminUsername $Adminuser -AdminPassword $password -VirtualMachineScaleSet $vmssConfig -ComputerNamePrefix $VMScaleSetComputerPrefix
New-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName "vmss-$VMScaleSetComputerPrefix-2004-build-$environment-we" -VirtualMachineScaleSet $vmssConfig 

Remove-azvm -Name $vmName -ResourceGroupName $ResourceGroupName -force