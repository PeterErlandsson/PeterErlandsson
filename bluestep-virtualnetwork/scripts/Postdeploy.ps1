[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $FirewallResourceGroupName,

    [Parameter(Mandatory)]
    [string]
    $FirewallNetworkName,

    [Parameter(Mandatory)]
    [string]
    $FirewallSub,

    [Parameter(Mandatory)]
    [string]
    [ValidateSet('Production', 'Test')]
    $Environment
)

$Subs = Get-AzSubscription | 
Where-Object { $_.Name -like "*_$Environment" -and $_.Name -notlike 'Connectivity*' } | 
Sort-Object Name

$Subs | ForEach-Object -begin {
    $FirewallContext = Select-AzSubscription -Subscription $FirewallSub | Set-AzContext
    $FirewallNetwork = $(Get-azVirtualNetwork -Name $FirewallNetworkName -ResourceGroupName $FirewallResourceGroupName -DefaultProfile $FirewallContext -ErrorAction Stop)
    $RGLock = Get-AzResourceLock -ResourceGroupName $FirewallNetwork.ResourceGroupName
    if ($RGLock) {
        $RGLock | Remove-AzResourceLock -Force -Confirm:$false
    }
    $BlockVirtualNetworkAccess = $false
    $AllowForwardedTraffic = $true
    $AllowGatewayTransit = $true
    $UseRemoteGateways = $false
    Start-sleep -Seconds 30

} -process {
    Select-AzSubscription -Subscription $_.Id | Select-object Name
    $AzContext = Set-AzContext -Subscription $_.Id

    $VirtualNetwork = ("vnet-$($_.Name -replace '_','-' -replace ' ','-')").ToLower()
    $PeeringName = "peer-azfirewall-to-$VirtualNetwork"

    $PeeringParams = @{
        Name                      = $PeeringName
        VirtualNetwork            = $FirewallNetwork
        RemoteVirtualNetworkId    = $(Get-AzVirtualNetwork -Name $VirtualNetwork -DefaultProfile $AzContext -ErrorAction Stop).Id
        BlockVirtualNetworkAccess = $BlockVirtualNetworkAccess 
        AllowForwardedTraffic     = $AllowForwardedTraffic
        AllowGatewayTransit       = $AllowGatewayTransit 
        UseRemoteGateways         = $UseRemoteGateways 
        DefaultProfile            = $FirewallContext
    }

    $NetworkPeering = (Get-AzVirtualNetworkPeering -VirtualNetworkName $FirewallNetworkName -DefaultProfile $FirewallContext -ResourceGroupName $FirewallResourceGroupName |
        Where-object {
            $_.Name -contains $PeeringName
        })

    if (-not $NetworkPeering) {
        Add-AzVirtualNetworkPeering @PeeringParams -ErrorAction Stop
    }
    Else {
        $ChangeNeeded = $false
        if ($NetworkPeering.AllowForwardedTraffic -ne $PeeringParams.AllowForwardedTraffic) {
            $NetworkPeering.AllowForwardedTraffic = $PeeringParams.AllowForwardedTraffic
            $ChangeNeeded = $true
        }

        if ($NetworkPeering.AllowGatewayTransit -ne $PeeringParams.AllowGatewayTransit) {
            $NetworkPeering.AllowGatewayTransit = $PeeringParams.AllowGatewayTransit
            $ChangeNeeded = $true
        }

        if ($NetworkPeering.UseRemoteGateways -ne $PeeringParams.UseRemoteGateways) {
            $NetworkPeering.UseRemoteGateways = $PeeringParams.UseRemoteGateways
            $ChangeNeeded = $true
        }

        if ($NetworkPeering.AllowVirtualNetworkAccess -eq $PeeringParams.BlockVirtualNetworkAccess) {
            $NetworkPeering.AllowVirtualNetworkAccess = !$PeeringParams.BlockVirtualNetworkAccess
            $ChangeNeeded = $true
        }

        if ($ChangeNeeded) {
            Set-AzVirtualNetworkPeering -VirtualNetworkPeering $NetworkPeering -DefaultProfile $FirewallContext -ErrorAction Stop
        }
    }
} -End {
    Select-AzSubscription -Subscription $FirewallSub | Set-AzContext
    if ($RGLock) {
        $Params = @{
            ResourceGroupName = $FirewallNetwork.ResourceGroupName
            LockName = $RGLock.Name
            LockLevel = if ($RGLock.properties.level) {
                $RGLock.properties.level
            } else {
                'ReadOnly'
            }
            LockNotes = if ($RGLock.properties.notes) {
                $RGLock.properties.notes
            } else {
                'ReadOnlyLock'
            }
        }
        New-AzResourceLock @Params -Force
    }
}