@{
    'RuleCollections' = @{
        'Allow-fqdn'    = @{
            'Priority' = 1200
            'action' = 'Allow'
            'Rules' = @{
                'SthlmOffice-to-Netbox'  = @{
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
                    sourceAddresses = @('192.168.65.0/24')
                    sourceIpGroups  = @()
                }
                'SthlmOffice-to-web-sit' = @{
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
                        'portalsit.bluestep.se'
                    )
                    targetUrls      = @()
                    terminateTLS    = $false
                    sourceAddresses = @(
                        '192.168.65.0/24'
                    )
                    sourceIpGroups  = @()
                }
            }
        }
    }
}