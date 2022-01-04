<#
This registers all the providers below. Use with caution.
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute, Microsoft.KeyVault, Microsoft.Storage, Microsoft.VirtualMachineImages, Microsoft.Network |
  Where-Object RegistrationState -ne Registered |
    Register-AzResourceProvider
#>

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $DockerVersion = "20.10.0",

    [Parameter()]
    [string]
    $containerdVersion = '1.4.9-1',
    
    [Parameter()]
    [string]
    $imageResourceGroup = 'rg-build-test',

    [Parameter()]
    [string]
    $location = 'West Europe',

    [Parameter()]
    [string]
    $imageTemplateName = 'Ubuntu2004Docker20-10-0',
    
    [Parameter()]
    [string]
    $runOutputName = 'Ubuntu2004Docker20-10-0',

    [Parameter()]
    [string]
    $myGalleryName = 'BluestepImageGallery',

    [Parameter()]
    [string]
    $imageDefName = 'UbuntuImages',

    [Parameter()]
    [string]
    $subscriptionID = '86d71566-8cbd-4e51-a115-fd7e0df0c3a0'
)


try {
    Get-Module Az.ImageBuilder
}
catch {
    Install-module Az.ImageBuilder
}

try {
    Get-Module Az.ManagedServiceIdentity
}
catch {
    Install-module Az.ManagedServiceIdentity
}

Select-AzSubscription $subscriptionID | Set-AzContext

[int]$timeInt = $(Get-Date -Format yyyyMMdd)
$imageRoleDefName = "Azure Image Builder Image Def $timeInt"
$identityName = "AzureImageIdentity$timeInt"

if (!(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName)) {
    New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName
    $identityNameResourceId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id
    $identityNamePrincipalId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId
    Start-sleep -second 30
}
else {
    $identityNameResourceId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id
    $identityNamePrincipalId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId
}

if (!(Get-AzRoleDefinition -Name $imageRoleDefName)) {
    $Content = Get-Content -Path ".\RoleImageCreationTemplate.json" -Raw
    $Content = $Content -replace '<subscriptionID>', $subscriptionID
    $Content = $Content -replace '<rgName>', $imageResourceGroup
    $Content = $Content -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName
    $Content | Out-File -FilePath ".\RoleImageCreation.json" -Force
    
    New-AzRoleDefinition -InputFile ".\RoleImageCreation.json"
    Start-sleep -second 30
}

$RoleAssignParams = @{
    ObjectId           = $identityNamePrincipalId
    RoleDefinitionName = $imageRoleDefName
    Scope              = "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"
}
if (! (Get-AzRoleAssignment -Scope $RoleAssignParams.Scope -ObjectId $RoleAssignParams.ObjectId -RoleDefinitionName $RoleAssignParams.RoleDefinitionName)) {
    New-AzRoleAssignment @RoleAssignParams
    Start-sleep 30
}


if (! (Get-AzGallery -GalleryName $myGalleryName -ResourceGroupName $imageResourceGroup)) {
    New-AzGallery -GalleryName $myGalleryName -ResourceGroupName $imageResourceGroup -Location $location
    Start-sleep 5
}

$GalleryParams = @{
    GalleryName       = $myGalleryName
    ResourceGroupName = $imageResourceGroup
    Location          = $location
    Name              = $imageDefName
    OsState           = 'generalized'
    OsType            = 'Linux'
    Publisher         = 'BluestepBank'
    Offer             = "BuildAgentUbuntu20_04-lts"
    Sku               = "20_04-lts"
    Tag               = @{
        'DockerVersion' = $DockerVersion
    }
    Description       = "Dockerversion: $DockerVersion"
}
New-AzGalleryImageDefinition @GalleryParams

$SrcObjParams = @{
    SourceTypePlatformImage = $true
    Publisher               = 'canonical'
    Offer                   = '0001-com-ubuntu-server-focal'
    Sku                     = '20_04-lts'
    Version                 = 'latest'
}
$srcPlatform = New-AzImageBuilderSourceObject @SrcObjParams

$disObjParams = @{
    SharedImageDistributor = $true
    ArtifactTag            = @{tag = 'dis-share' }
    GalleryImageId         = "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup/providers/Microsoft.Compute/galleries/$myGalleryName/images/$imageDefName"
    ReplicationRegion      = $location
    RunOutputName          = $runOutputName
    ExcludeFromLatest      = $false
}
$disSharedImg = New-AzImageBuilderDistributorObject @disObjParams

$ImgCustomParams01 = @{
    ShellCustomizer = $true
    CustomizerName  = 'InstallApplications'
    Inline          = @(
        "sudo apt-get update",
        "sudo apt-get install -y apt-transport-https",
        "sudo apt-get update",
        "curl -fsSL https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_$dockerversion~3-0~ubuntu-focal_amd64.deb -o docker-ce-cli.deb",
        "curl -fsSL https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_$dockerversion~3-0~ubuntu-focal_amd64.deb -o docker-ce.deb",
        "curl -fsSL https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_$containerdversion`_amd64.deb -o containerd.deb",
        "sudo apt install liblttng-ust-ctl4 liblttng-ust0 liburcu6 nodejs unzip zip libgit2-dev -y",
        "sudo dpkg -i containerd.deb",
        "sudo dpkg -i docker-ce-cli.deb",
        "sudo dpkg -i docker-ce.deb",
        "sudo rm /tmp/DeprovisioningScript.sh"
        "sudo echo ""sudo waagent -deprovision -force"" > /tmp/DeprovisioningScript.sh"
    )
}
$Customizer01 = New-AzImageBuilderCustomizerObject @ImgCustomParams01


$ImgCustomParams02 = @{
    ShellCustomizer = $true
    CustomizerName  = 'InstallAzureAgent'
    Inline          = @(
        "cat /etc/waagent.conf",
        "sudo sed -i 's/# AutoUpdate.Enabled=n/AutoUpdate.Enabled=y/g' /etc/waagent.conf",
        "sudo sed -i 's/# AutoUpdate.Enabled=y/AutoUpdate.Enabled=y/g' /etc/waagent.conf"
    )
}
$Customizer02 = New-AzImageBuilderCustomizerObject @ImgCustomParams02

$ImgTemplateParams = @{
    ImageTemplateName      = $imageTemplateName
    ResourceGroupName      = $imageResourceGroup
    Source                 = $srcPlatform
    Distribute             = $disSharedImg
    Customize              = $Customizer01
    Location               = $location
    UserAssignedIdentityId = $identityNameResourceId
}
New-AzImageBuilderTemplate @ImgTemplateParams

Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup |
Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState

# If failure run this
# Remove-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup

Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName