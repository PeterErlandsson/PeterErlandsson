$CurrentConfig = Get-Content -path .\rules.json | ConvertFrom-Json -Depth 100

$SubnetsJson = $CurrentConfig.properties.subnets | ForEach-Object {
    [PSCustomObject]@{
        Name       = "'$($_.Name)'"
        Properties = [PSCustomObject]@{
            privateEndpointNetworkPolicies    = $_.Properties.privateEndpointNetworkPolicies
            privateLinkServiceNetworkPolicies = $_.Properties.privateLinkServiceNetworkPolicies
            addressPrefix                     = "'$($_.Properties.addressPrefix)'"
            serviceEndpoints                  = @($_.Properties.serviceEndpoints | ForEach-Object {
                    [PSCustomObject]@{
                        service   = "'$($_.Service)'"
                        locations = @($_.Locations | Foreach-object {
                                "$($_)"
                            })
                    }
                })
            delegations                       = @($_.Properties.delegations)
            networkSecurityGroup              = if ($_.properties.networkSecurityGroup) {
                [PSCustomObject]@{
                    id = "'$($_.properties.networkSecurityGroup.id)'"
                }
            }
            else {
                '{}'
            }
            routeTable                        = if ($_.properties.routeTable) {
                [PSCustomObject]@{
                    id = "'$($_.properties.routeTable.id)'"
                }
            }
            else {
                '{}'
            }
            ipConfigurations                  = if ($_.properties.ipConfigurations) {
                @($_.properties.ipConfigurations | Foreach-object {
                        [PSCustomObject]@{
                            id = "'$($_.id)'"
                        }
                    })
            }
            else {
                '{}'
            }
        }
    }
} | ConvertTo-Json -Depth 100 

$VnetPeeringsJson = $CurrentConfig.properties.virtualNetworkPeerings | ForEach-Object {
    [PSCustomObject]@{
        Name       = "'$($_.Name)'"
        Properties = [PSCustomObject]@{
            remoteVirtualNetwork      = [PSCustomObject]@{
                id = "'$($_.Properties.remoteVirtualNetwork.id)'"
            }
            allowVirtualNetworkAccess = $_.Properties.allowVirtualNetworkAccess
            allowForwardedTraffic     = $_.Properties.allowForwardedTraffic
            allowGatewayTransit       = $_.Properties.allowGatewayTransit
            useRemoteGateways         = $_.Properties.useRemoteGateways
            doNotVerifyRemoteGateways = $_.Properties.doNotVerifyRemoteGateways
            remoteAddressSpace        = [PSCustomObject]@{
                addressPrefixes = if ($_.properties.remoteAddressSpace.addressPrefixes) {
                    @($_.properties.remoteAddressSpace.addressPrefixes | ForEach-Object {
                            "'$($_)'"
                        })
                }
                else {
                    '[]'
                }
            }
            routeServiceVips          = if ($_.properties.routeServiceVips) { $_.Properties.routeServiceVips } else { '{}' }
        }
    }
} | ConvertTo-Json -Depth 100

$Subnets = $SubnetsJson -replace '"', '' -replace ',', '' -replace 'Enabled', '''Enabled''' -replace 'provisioningState: Succeeded', '' -replace 'westeurope', '''westeurope''' -replace 'northeurope', '''northeurope''' -replace 'Disabled', '''Disabled'''
$Subnets | clip

$VnetPeerings = $VnetPeeringsJson -replace '"', '' -replace ',', '' -replace 'true', '''true''' -replace 'false', '''false''' 
$VnetPeerings | clip

$NsgRules = Get-Content -path .\nsgrules.json | ConvertFrom-Json -depth 100
$NsgRulesJson = $NsgRules.properties.securityRules | ForEach-Object {
    [PSCustomObject]@{
        Name       = "'$($_.Name)'"
        properties = [PSCustomObject]@{
            protocol                             = "'$($_.properties.protocol)'"
            description                          = "'$($_.properties.description)'"
            sourcePortRange                      = "'$($_.properties.sourcePortRange)'"
            destinationPortRange                 = "'$($_.properties.destinationPortRange)'"
            destinationAddressPrefix             = "'$($_.properties.destinationAddressPrefix)'"
            sourceAddressPrefix                  = "'$($_.properties.sourceAddressPrefix)'"
            sourceAddressPrefixes                = @($_.properties.sourceAddressPrefixes | foreach-object { "'$($_)'" })
            destinationAddressPrefixes           = @($_.properties.destinationAddressPrefixes | foreach-object { "'$($_)'" })
            access                               = "'$($_.properties.access)'"
            priority                             = "'$($_.properties.priority)'"
            direction                            = "'$($_.properties.direction)'"
            sourcePortRanges                     = @($_.properties.sourcePortRanges | foreach-object { "'$($_)'" })
            destinationPortRanges                = @($_.properties.destinationPortRanges | foreach-object { "'$($_)'" })
            destinationApplicationSecurityGroups = @(if ($_.properties.destinationApplicationSecurityGroups) {
                    $_.properties.destinationApplicationSecurityGroups | foreach-object { 
                        [PSCustomObject]@{
                            id = "'$($_.id)'"
                        } 
                    }
                }
            )
        }
    }
} | ConvertTo-Json -depth 100

$nsgRulesJson -replace '"', '' -replace ',', '' | clip

$ExpressRoutePeerings = Get-Content -path .\Expressroute.json | ConvertFrom-Json -depth 100
$PeeringsJson = $ExpressRoutePeerings.properties.peerings | foreach-object {
    [PSCustomObject]@{
        Name       = "'$($_.name)'"
        properties = [PSCustomObject]@{
            peeringType                = "'$($_.properties.peeringType)'"
            azureASN                   = $($_.properties.azureASN)
            peerASN                    = $($_.properties.peerASN)
            primaryPeerAddressPrefix   = "'$($_.properties.primaryPeerAddressPrefix)'"
            secondaryPeerAddressPrefix = "'$($_.properties.secondaryPeerAddressPrefix)'"
            primaryAzurePort           = "'$($_.properties.primaryAzurePort)'"
            secondaryAzurePort         = "'$($_.properties.secondaryAzurePort)'"
            state                      = "'$($_.properties.state)'"
            vlanId                     = $($_.properties.vlanId)
            microsoftPeeringConfig     = [PSCustomObject]@{
                advertisedPublicPrefixes      = @("'$($_.properties.microsoftPeeringConfig.advertisedPublicPrefixes)'")
                advertisedCommunities         = @($($_.properties.microsoftPeeringConfig.advertisedCommunities | foreach-object {
                            "'$($_)'"
                        } ))
                advertisedPublicPrefixesState = [array]@(
                    $_.properties.microsoftPeeringConfig.advertisedPublicPrefixesState | foreach-object {
                        "'$($_)'"
                    }
                )
                customerASN                   = $_.properties.microsoftPeeringConfig.customerASN
                legacyMode                    = $_.properties.microsoftPeeringConfig.legacyMode
                routingRegistryName           = "'$($_.properties.microsoftPeeringConfig.routingRegistryName)'"
            }
        }
    }
} | convertTo-Json -Depth 100

$PeeringsJson -replace '"', '' -replace ',', '' | clip

New-AzResourceGroupDeployment -TemplateFile .\main.json -ResourceGroupName 'bstp-cdpnet-infra-we' -whatif