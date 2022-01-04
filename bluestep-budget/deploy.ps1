[CmdletBinding()]
param (
    # Parameter help description
    [Parameter(Mandatory)]
    [string]
    $TemplateFile,

    [Parameter()]
    [switch]
    $WhatIf
)

$params = @{
    TemplateFile = $TemplateFile
    Location = "West europe"
}

if ($WhatIf.IsPresent) {
    $params.whatif = $true 
}

New-AzSubscriptionDeployment @params