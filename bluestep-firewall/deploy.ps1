[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $WhatIf,

    # ResourceGroupName
    [Parameter(Mandatory)]
    [string]
    $ResourceGroupName
)

### This deploys the full solution where rules use the ip groups
$params = @{
    Name = 'Bluestep-Firewall'
    Location = 'West Europe'
    TemplateFile = '.\main.bicep'
    #TemplateParameterFile = '.\parameters.json'
    ResourceGroupName = $ResourceGroupName
}

if ($WhatIf.IsPresent) {
    $params.whatif = $true 
}

# Create the install folder
$installPath = "$env:USERPROFILE\.bicep"
$installDir = New-Item -ItemType Directory -Path $installPath -Force
$installDir.Attributes += 'Hidden'
# Fetch the latest Bicep CLI binary
(New-Object Net.WebClient).DownloadFile("https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe", "$installPath\bicep.exe")
# Add bicep to your PATH
$currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
if (-not $currentPath.Contains("%USERPROFILE%\.bicep")) { setx PATH ($currentPath + ";%USERPROFILE%\.bicep") }
if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }

New-AzResourceGroupDeployment @params