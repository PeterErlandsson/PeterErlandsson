Select-AzSubscription "d42486c4-f86c-4f3a-8ba9-9f5803e332d8"
$Routes = Get-AzExpressRouteCircuitRouteTable -ResourceGroupName 'bstp-cdpnet-infra-we' -ExpressRouteCircuitName 'bstp-cdpnet-er01-we' -PeeringType AzurePrivatePeering -DevicePath Primary
$ERRoutes = $Routes | Where-Object { $_.NextHop -eq '172.17.80.225' -and $_.Network -ne '0.0.0.0' -and $_.path -like '*20514*' }

$ParamFile = Get-Content .\parameters.json | ConvertFrom-Json -Depth 100
$ParamFile.parameters.ERRoutes.value = $ERRoutes.Network | ForEach-Object -Begin {
    $Counter = 1
} {
    [PSCustomObject]@{
        name       = "to_bluestep_axians_ER_$Counter"
        properties = [PSCustomObject]@{
            addressPrefix    = $_
            nextHopType      = 'VirtualAppliance'
            nextHopIpAddress = 'firewallIp'
        }
    }
    $Counter++ | Out-null
}
$($ParamFile | ConvertTo-Json -depth 100) | clip

<#
Use the information in clip to replace and populate the routes in the bicep files.
It contains all the routes presented in the Express route that's not the forced tunneling and next hop is Axians.
#>

