@{
    'RuleCollections' = @{
        'Allow-fqdn'    = @{
            'Priority' = 1200
            'action' = 'Allow'
            'Rules' = @{
                'vpn-to-web-sit' = @{
                    Protocols       = @(
                        @{
                            protocolType = 'Https'
                            port         = 443
                        }
                        @{
                            protocolType = 'http'
                            port         = 80
                        }
                    )
                    fqdnTags        = @()
                    webCategories   = @()
                    targetFqdns     = @(
                        'websit.bluestep.no',
                        'websit.bluestep.se',
                        'websit.bluestep.fi',
                        'sit.bluestep.no',
                        'sit.bluestep.se',
                        'sit.bluestep.fi',
                        'sit.60plusbanken.se',
                        'sit.bluestepbank.com',
                        'portalsit.bluestep.se')
                    targetUrls      = @()
                    terminateTLS    = $false
                    sourceAddresses = @(
                        '10.126.45.0/24', 
                        '10.126.50.0/23'
                    )
                    sourceIpGroups  = @()
                }
                'vpn-to-web-uat' = @{
                    Protocols       = @(
                        @{
                            protocolType = 'Https'
                            port         = 443
                        }
                        @{
                            protocolType = 'http'
                            port         = 80
                        }
                    )
                    fqdnTags        = @()
                    webCategories   = @()
                    targetFqdns     = @(
                        'uatadmin.bluestep.no',
                        'uatadmin.bluestep.se',
                        'uatadmin.bluestep.fi',
                        'uatadmin.bluestepbank.com',
                        'uatadmin.60plusbanken.se',
                        'uat.bluestep.no',
                        'uat.bluestep.se',
                        'uat.bluestep.fi',
                        'uat.60plusbanken.se',
                        'uat.bluestepbank.com')
                    targetUrls      = @()
                    terminateTLS    = $false
                    sourceAddresses = @(
                        '10.126.45.0/24', 
                        '10.126.50.0/23'
                    )
                    sourceIpGroups  = @()
                }
                'vpn-to-web-prod' = @{
                    Protocols       = @(
                        @{
                            protocolType = 'Https'
                            port         = 443
                        }
                        @{
                            protocolType = 'http'
                            port         = 80
                        }
                    )
                    fqdnTags        = @()
                    webCategories   = @()
                    targetFqdns     = @(
                        'admin.bluestep.no',
                        'admin.bluestep.se',
                        'admin.bluestep.fi',
                        'admin.bluestepbank.com',
                        'admin.60plusbanken.se')
                    targetUrls      = @()
                    terminateTLS    = $false
                    sourceAddresses = @(
                        '10.126.45.0/27',
                        '10.126.45.32/27', 
                        '10.126.50.0/23'
                    )
                    sourceIpGroups  = @()
                }
                'vpn-to-Netbox'  = @{
                    Protocols       = @(
                        @{
                            protocolType = 'Https'
                            port         = 443
                        }
                        @{
                            protocolType = 'Http'
                            port         = 80
                        }
                    )
                    fqdnTags        = @()
                    webCategories   = @()
                    targetFqdns     = @('netbox.bluestep.se')
                    targetUrls      = @()
                    terminateTLS    = $false
                    sourceAddresses = @(
                        '10.126.45.0/24', 
                        '10.126.50.0/23'
                    )
                    sourceIpGroups  = @()
                }
            }
        }
    }
}