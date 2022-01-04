@{
    'RuleCollections' = @{
        'Allow-fqdn'    = @{
            'Priority' = 1200
            'action' = 'Allow'
            'Rules' = @{
                'production-to-internet' = @{
                    Protocols            = @(
                        @{
                            protocolType = 'Https'
                            port = 443
                        }
                        @{
                            protocolType = 'Http'
                            port = 80
                        }
                    )
                    fqdnTags             = @()
                    webCategories        = @()
                    targetFqdns          = @()
                    targetUrls           = @('*')
                    terminateTLS         = $true
                    sourceAddresses      = @()
                    sourceIpGroups       = @('ipgproduction')
                }
                'test-to-internet' = @{
                    Protocols            = @(
                        @{
                            protocolType = 'Https'
                            port = 443
                        }
                        @{
                            protocolType = 'Http'
                            port = 80
                        }
                    )
                    fqdnTags             = @()
                    webCategories        = @()
                    targetFqdns          = @()
                    targetUrls           = @('*')
                    terminateTLS         = $true
                    sourceAddresses      = @()
                    sourceIpGroups       = @('ipgtest')
                }
            }
        }
    }
}