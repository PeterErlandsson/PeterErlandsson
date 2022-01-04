@{
            'RuleCollections' = @{
                'Example-fqdn'    = @{
                    'Priority' = 1200
                    'action' = 'Allow'
                    'Rules' = @{
                        'Example' = @{
                            Protocols            = @(
                                @{
                                    protocolType = 'Https'
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
        }