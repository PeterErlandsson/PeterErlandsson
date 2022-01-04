[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $WhatIf,

    [Parameter(Mandatory)]
    [string]
    [ValidateSet('Production', 'Test', 'Sandbox')]
    $Environment
)

Switch ($Environment) {
    'Production' {
        $params = @{
            ManagementGroupId = "BluestepProd"
        }
    }
    'Test' {
        $params = @{
            ManagementGroupId = "BluestepTest"
        }
    }
    'Sandbox' {
        $params = @{
            ManagementGroupId = "BluestepSandbox"
        }
    }
}

$params.TemplateFile = ".\$Environment.bicep"
$params.Name = 'Bluestep-Vnet-Deploy'
$params.Location = 'West Europe'
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

New-AzManagementGroupDeployment @params