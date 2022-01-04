[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $AppName,

    [Parameter(Mandatory)]
    [validateset('prod','test','dev')]
    [string]
    $environment,

    [Parameter()]
    [string]
    $owner = 'web',

    [Parameter()]
    [string]
    $systemid = 'az-webapp'
)

Write-verbose "Will now build all the needed ARM json files from the bicep files." -verbose

if ($(bicep --version).split(' ')[3] -lt '0.2.212') {
    Write-error "Please update the Bicep CLI to a version that contains the condition feature (version 0.2.212 or higher).`nDownload at: https://github.com/Azure/bicep/releases/tag/v0.2.212"
}

try {
    bicep build '.\bluestep-webappservice\hostingPlan.bicep'
    bicep build '.\bluestep-webappservice\containerApp.bicep'
} catch {
   throw 
}


# Deploy resource group with tags
$ResourceGroup = New-AzResourceGroup -Name "rg-$AppName-tst" -Location 'west europe' -Tag @{'environment'=$environment;'owner'=$owner;'systemid'=$systemid}

# Deploy hosting plan
$params = @{
    ResourceGroupName = $ResourceGroup.ResourceGroupName
    TemplateFile = '.\bluestep-webappservice\hostingPlan.json'
    hostingPlanName = "plan-$AppName-$environment"
    operatingSystem = 'linux'
    appServiceSku = 'P1V3'
}
Write-Verbose "Deploying the Azure App service plan" -verbose
$HostingPlanDeployment = New-AzResourceGroupDeployment @params

# Deploy hosting plan
$params = @{
    ResourceGroupName = $ResourceGroup.ResourceGroupName
    TemplateFile = '.\bluestep-webappservice\containerApp.json'
    TemplateParameterFile = '.\bluestep-webappservice\containerApp.parameters.json'
    environment = $environment
    appName = $AppName
    # customHostName = "$AppName.bluestepapps.net"
    serverFarmId = $HostingPlanDeployment.Outputs['hostingId'].Value
    enableSSL = $false
    certificateKeyvaultId = 'null'
    certificateKeyvaultSecretName = 'null'
    allowedAudiences = @("https://$AppName.azurewebsites.net") #,"https://$AppName.bluestepapps.net"
}
Write-verbose "Deploying the main template" -Verbose
New-AzResourceGroupDeployment @params