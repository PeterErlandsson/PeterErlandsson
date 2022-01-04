[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    [ValidateSet('Production', 'Test', 'Sandbox')]
    $Environment,

    [Parameter(Mandatory)]
    [string]
    $Location,

    [Parameter(Mandatory)]
    [string]
    $Owner
)

$Subs = Get-AzSubscription | 
Where-Object { $_.Name -like "*_$Environment" -and $_.Name -notlike 'Connectivity*' } | 
Sort-Object Name

$Subs | ForEach-Object {
    Select-AzSubscription -Subscription $_.Id | Select-object Name

    if (! (Get-AzResourceGroup -Name "rg-spoke-$Environment")) {
        New-AzResourceGroup -Name "rg-spoke-$Environment" -Location $Location -tag @{
            'environment'  = $environment
            'owner'        = $Owner
        } -confirm:$false -Force
    }
}