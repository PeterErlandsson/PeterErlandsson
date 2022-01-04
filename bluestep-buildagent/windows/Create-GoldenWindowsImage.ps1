Select-AzSubscription '86d71566-8cbd-4e51-a115-fd7e0df0c3a0'

$ResourceGroupName = "rg-build-test"
$ComputerName = "vm-windowsbuild"
$VMScaleSetComputerPrefix = 'windows'
$ScaleSetName = "vmss-windows-build-test-we"
$Adminuser = "REDACTED!"
$password = "REDACTED!"
$SubnetId = '/subscriptions/86d71566-8cbd-4e51-a115-fd7e0df0c3a0/resourceGroups/rg-spoke-test/providers/Microsoft.Network/virtualNetworks/vnet-infrastructure-test/subnets/snet-buildagent-test'
$VMName = "vm-Windows-BuildAgent-test"
$VMSize = "Standard_D4s_v4"
$LocationName = "West Europe"
$PublisherName = "microsoftvisualstudio" # 'MicrosoftVisualStudio'
$Offer = "visualstudio2019latest" # 'visualstudio2019'
$Sku = "vs-2019-ent-latest-ws2019" # 'vs-2019-ent-ws2019'

New-AzResourceGroup -Name $ResourceGroupName -Location 'West Europe' -confirm:$false -force
$NIC = New-AzNetworkInterface -Name "$Vmname-nic-01" -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $SubnetId

$Credential = New-Object System.Management.Automation.PSCredential ($Adminuser, $(ConvertTo-SecureString $password -AsPlainText -Force));

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName $PublisherName -Offer $Offer -Skus $Sku -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose
Write-verbose "Automatically installing applications.." -verbose
$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName = $VMName 
    CommandId = 'RunPowerShellScript'
    ScriptPath = '.\InstallApps.ps1'
}
Invoke-AzVMRunCommand @params

Write-verbose "Installing Azure module and removing AzureRM module.." -verbose
$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName = $VMName 
    CommandId = 'RunPowerShellScript'
    ScriptPath = '.\InstallPwshModules.ps1'
}
Invoke-AzVMRunCommand @params

Restart-AzVM -ResourceGroupName $resourceGroupName -Name $VMName

Write-verbose "Please manually install jdk. https://www.oracle.com/java/technologies/javase-jdk16-downloads.html" -Verbose
Write-verbose "Please manually install Google Chrome. https://chromeenterprise.google/intl/sv_SE/browser/download/#windows-tab" -Verbose
Write-Verbose "Sysprep the machine!" -Verbose

Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
Set-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Generalized
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName
$Image = New-AzImageConfig -Location $LocationName -SourceVirtualMachineId $vm.id
$Image = New-AzImage -Image $Image -ImageName "Bluestep-WindowsBuildAgent$(Get-Date -format yyyyMMddHHmm)" -ResourceGroupName $ResourceGroupName

$ipConfig = New-AzVmssIpConfig -Name "IPConfig" -SubnetId $SubnetId
$vmssConfig = New-AzVmssConfig -Location $LocationName -SkuCapacity 1 -SkuName $VMSize -UpgradePolicyMode "Manual"
Set-AzVmssStorageProfile $vmssConfig -OsDiskCreateOption "FromImage" -ImageReferenceId $Image.id
Add-AzVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name "network-config" -Primary $true -IPConfiguration $ipConfig 
Set-AzVmssOsProfile -AdminUsername $Adminuser -AdminPassword $password -VirtualMachineScaleSet $vmssConfig -ComputerNamePrefix $VMScaleSetComputerPrefix
New-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName $scaleSetName -VirtualMachineScaleSet $vmssConfig

Remove-AzVM -Name $VMName -ResourceGroupName $vm.ResourceGroupName -Force