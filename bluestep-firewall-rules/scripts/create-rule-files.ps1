$Subscriptions = Get-AzSubscription | 
Where-Object { $_.Name -like '*_Test' -or $_.Name -like '*_Production' -and $_.Name -notlike 'Connectivity*' } | 
Sort-Object Name

$Subscriptions | ForEach-Object -Begin {
    $SpokeNetworks = New-object System.Collections.ArrayList
} {
    Select-AzSubscription -Subscription $_.Id | Out-Null
    switch -wildcard ($_.Name) {
        '*_Production' {
            $Environment = 'production'
        }
        '*_Test' {
            $Environment = 'test'
        }
        '*_Sandbox' {
            $Environment = 'sandbox'
        }
    }
    $Network = Get-AzVirtualNetwork -ResourceGroupName "rg-spoke-$Environment" -ErrorAction Stop | Select-Object Name, @{N = 'AddressSpace'; E = { $_.AddressSpace.addressPrefixes } }, @{N = 'Subnets'; E = { $_.Subnets.addressPrefix } }
    $SpokeNetworks.Add($Network) | Out-Null

    $NetworkDataFileName = "$($Network.Name -replace 'vnet-','').psd1"

    if (! (Test-path ".\data\application-rules\$NetworkDataFileName")) {
        Write-verbose "Creating a new Application rule file for $NetworkDataFileName" -verbose
        New-Item -Path ".\data\application-rules\$NetworkDataFileName" -Value '@{
            ''RuleCollections'' = @{
                ''Example-fqdn''    = @{
                    ''Priority'' = 1200
                    ''action'' = ''Allow''
                    ''Rules'' = @{
                        ''Example'' = @{
                            Protocols            = @(
                                @{
                                    protocolType = ''Https''
                                    port = 443
                                }
                            )
                            fqdnTags             = @()
                            webCategories        = @()
                            targetFqdns          = @()
                            targetUrls           = @()
                            terminateTLS         = $false
                            sourceAddresses      = @()
                            sourceIpGroups       = @()
                        }
                    }
                }
            }
        }' | Out-Null
    }

    if (! (Test-path ".\data\network-rules\$NetworkDataFileName")) {
        Write-verbose "Creating a new Network rule file for $NetworkDataFileName" -verbose
        New-Item -Path ".\data\network-rules\$NetworkDataFileName" -Value $(
            if ($NetworkDataFileName -like '*sandbox*') {
                "@{
                    'Priority' = 999999
                    'RuleCollections' = @{
                        'Example'    = @{
                            'Priority' = 1000
                            'action' = 'Allow'
                            'Rules' = @{
                                'Example' = @{
                                    source           = @(''$($Network.AddressSpace)'')
                                    destination      = @(''$($Network.AddressSpace)'')
                                    ipProtocols      = @(''TCP'')
                                    destinationPorts = @(''3389'')
                                }
                            }
                        }
                    }
                }"
            } else {
                "@{
                    'Priority' = 999999
                    'RuleCollections' = @{
                        'Allow'    = @{
                            'Priority' = 1000
                            'action' = 'Allow'
                            'Rules' = @{
                                'Vnet-to-DomainControllers' = @{
                                    source           = @('$($Network.AddressSpace)')
                                    destination      = @('ipgdomaincontroller')
                                    ipProtocols      = @('Any')
                                    destinationPorts = @(
                                        '25'
                                        '53'
                                        '67'
                                        '88'
                                        '123'
                                        '135'
                                        '137-139'
                                        '389'
                                        '445'
                                        '464'
                                        '636'
                                        '2535'
                                        '3268-3269'
                                        '5722'
                                        '9389'
                                        '49152-65535'
                                    )
                                }
                            }
                        }
                    }
                }"
            }
        ) | Out-null
    }
}