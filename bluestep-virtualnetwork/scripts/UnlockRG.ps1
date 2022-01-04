[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    [ValidateSet('Production', 'Test', 'Sandbox')]
    $Environment
)

$Subs = Get-AzSubscription | 
Where-Object { $_.Name -like "*_$Environment" -and $_.Name -notlike 'Connectivity*' } | 
Sort-Object Name

$Subs | ForEach-Object {
    Select-AzSubscription -Subscription $_.Id | Select-object Name
    Get-AzResourceLock -ResourceGroupName "rg-spoke-$Environment" | Remove-AzResourceLock -Confirm:$false -Force

} -End {
    Write-Verbose "Starting a sleep for 60 seconds to make sure all resources has been unlocked properly.." -Verbose
    Start-Sleep -Seconds 60
}