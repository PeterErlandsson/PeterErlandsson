[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $WhatIf
)

$params = @{
    TemplateFile = ".\artifact-assignment.json"
    Location = "West europe"
}

if ($WhatIf.IsPresent) {
    $params.whatif = $true 
}

New-AzTenantDeployment @params