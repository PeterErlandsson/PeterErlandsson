[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $WhatIf
)

$params = @{
    TemplateFile = ".\artifact-policies.json"
    topLevelManagementGroupPrefix = 'Bluestep'
    Location = "West europe"
}

if ($WhatIf.IsPresent) {
    $params.whatif = $true 
}

New-AzManagementGroupDeployment @params -ManagementGroupId $params['topLevelManagementGroupPrefix']