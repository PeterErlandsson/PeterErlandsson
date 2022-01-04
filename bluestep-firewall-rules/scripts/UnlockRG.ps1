[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory)]
    [string]
    $RGName
)

$Subs = Get-AzSubscription | 
Where-Object {$_.Id -eq $SubscriptionId} 

$Subs | ForEach-Object {
    Select-AzSubscription -Subscription $_.Id | Select-object Name
    Get-AzResourceLock -ResourceGroupName $RGName | Remove-AzResourceLock -Confirm:$false -Force -Verbose

} -End {
    Write-Verbose "Starting a sleep for 30 seconds to make sure all resources has been unlocked properly.." -Verbose
    Start-Sleep -Seconds 30
}

