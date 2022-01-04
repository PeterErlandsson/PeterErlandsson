Select-AzSubscription '86d71566-8cbd-4e51-a115-fd7e0df0c3a0'

$ResourceGroupName = "rg-build-test"
$ComputerName = "vm-linuxbuild"
$VMScaleSetComputerPrefix = 'linux'
$Adminuser = "REDACTED!"
$password = 'REDACTED!'
$SubnetId = '/subscriptions/86d71566-8cbd-4e51-a115-fd7e0df0c3a0/resourceGroups/rg-spoke-test/providers/Microsoft.Network/virtualNetworks/vnet-infrastructure-test/subnets/internal'
$VMName = "vm-linuxbuild-2004-test-seb"
$VMSize = "Standard_D4s_v4"
$LocationName = "West Europe"
$ScaleSetName = "vmss-$VMScaleSetComputerPrefix-2004-build-test-we"
$VMLocalAdminSecurePassword = ConvertTo-SecureString $password -AsPlainText -Force

New-AzResourceGroup -Name $ResourceGroupName -Location 'West Europe' -confirm:$false -force
$NIC = New-AzNetworkInterface -Name "$Vmname-nic-01" -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $SubnetId

$Credential = New-Object System.Management.Automation.PSCredential ($Adminuser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName $ComputerName -Credential $Credential
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'canonical' -Offer '0001-com-ubuntu-server-focal' -Skus '20_04-lts' -Version latest
#$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'canonical' -Offer 'UbuntuServer' -Skus '18.04-LTS' -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine

$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName            = $VMName 
    CommandId         = 'RunShellScript'
    ScriptPath        = '.\InstallWAAgent.sh'
}
Invoke-AzVMRunCommand @params

$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName            = $VMName 
    CommandId         = 'RunShellScript'
    ScriptPath        = '.\InstallApps.sh'
}
Invoke-AzVMRunCommand @params

"Now generalizing the image."
$params = @{
    ResourceGroupName = $ResourceGroupName
    VMName            = $VMName 
    CommandId         = 'RunShellScript'
    ScriptPath        = '.\GeneralizeImage.sh'
}
Invoke-AzVMRunCommand @params

Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
Set-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Generalized 
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName
$Image = New-AzImageConfig -Location $LocationName -SourceVirtualMachineId $vm.id
$Image = New-AzImage -Image $Image -ImageName "Bluestep-Linux2004BuildAgent$(Get-Date -format yyyyMMddHHmm)" -ResourceGroupName $ResourceGroupName

$ipConfig = New-AzVmssIpConfig -Name "IPConfig" -SubnetId $SubnetId
$vmssConfig = New-AzVmssConfig -Location $LocationName -SkuCapacity 1 -SkuName $VMSize -UpgradePolicyMode "Manual" -SinglePlacementGroup $false
Set-AzVmssStorageProfile $vmssConfig -OsDiskCreateOption "FromImage" -ImageReferenceId $Image.id
Add-AzVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name "network-config" -Primary $true -IPConfiguration $ipConfig 
Set-AzVmssOsProfile -AdminUsername $Adminuser -AdminPassword $password -VirtualMachineScaleSet $vmssConfig -ComputerNamePrefix $VMScaleSetComputerPrefix
New-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName $scaleSetName -VirtualMachineScaleSet $vmssConfig 