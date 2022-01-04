@{
    'RuleCollections' = @{
        'Allow-fqdn' = @{
            'Priority' = 1200
            'action'   = 'Allow'
            'Rules'    = @{
                'snet-frontend-to-any' = @{
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
                    targetFqdns     = @()
                    targetUrls      = @('*')
                    terminateTLS    = $true
                    sourceAddresses = @('10.129.120.0/26', '10.129.121.64/26')
                    sourceIpGroups  = @()
                }
                'snet-gateway-to-any'  = @{
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
                    targetFqdns     = @()
                    targetUrls      = @('*')
                    terminateTLS    = $true
                    sourceAddresses = @('10.129.121.64/26')
                    sourceIpGroups  = @()
                }
                'vnet-to-bluestep'  = @{
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
                    targetFqdns     = @('*.bluestep.se','*.bluestep.no')
                    targetUrls      = @()
                    terminateTLS    = $false
                    sourceAddresses = @('10.129.120.0/21')
                    sourceIpGroups  = @()
                }
                'vnet-to-third-parties'  = @{
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
                    targetFqdns     = @()
                    targetUrls      = @('*.hemnet.se','customerpages-bsfi.naktergaltech.se','*.trustpilot.com','*.instagram.com','*.facebook.com')
                    terminateTLS    = $true
                    sourceAddresses = @('10.129.120.0/21')
                    sourceIpGroups  = @()
                }
            }
        }
    }
}