@{
    'RuleCollections' = @{
        'Allow-fqdn'    = @{
            'Priority' = 1200
            'action' = 'Allow'
            'Rules' = @{
                'vdi-swift-to-WindowsVirtualDesktop' = @{
                    Protocols            = @(
                        @{
                            protocolType = 'Https'
                            port = 443
                        }
                    )
                    fqdnTags             = @(
                        'WindowsVirtualDesktop'
                        'WindowsUpdate'
                        'Windows Diagnostics'
                        'MicrosoftActiveProtectionService'
                    )
                    webCategories = @()
                    targetFqdns          = @()
                    targetUrls           = @()
                    terminateTLS         = $false
                    sourceAddresses      = @('10.129.73.8/29')
                    sourceIpGroups       = @()
                }
                'vdi-swift-to-WindowsUpdate' = @{
                    Protocols            = @(
                        @{
                            protocolType = 'Https'
                            port = 443
                        }
                    )
                    fqdnTags             = @()
                    webCategories        = @()
                    targetFqdns          = @('*.ods.opinsights.azure.com','*.oms.opinsights.azure.com','*.blob.core.windows.net','*.azure-automation.net')
                    targetUrls           = @()
                    terminateTLS         = $false
                    sourceAddresses      = @('10.129.73.8/29')
                    sourceIpGroups       = @()
                }
                'vdi-swift-to-swiftcom' = @{
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
                    targetFqdns          = @('*.swift.com')
                    targetUrls           = @()
                    terminateTLS         = $false
                    sourceAddresses      = @('10.129.73.8/29')
                    sourceIpGroups       = @()
                }
                'vdi-swift-to-kms' = @{
                    Protocols            = @(
                        @{
                            protocolType = 'Https'
                            port = 1688
                        }
                    )
                    fqdnTags             = @()
                    webCategories        = @()
                    targetFqdns          = @()
                    targetUrls           = @('kms.core.windows.net')
                    terminateTLS         = $true
                    sourceAddresses      = @('10.129.73.8/29')
                    sourceIpGroups       = @()
                }
                'vdi-swift-to-intune-endpoints' = @{
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
                    targetUrls           = @('qagpublic.qg2.apps.qualys.eu','slscr.update.microsoft.com','*.manage.microsoft.com','mam.manage.microsoft.com','wip.mam.manage.microsoft.com','fef.msuc03.manage.microsoft.com','m.manage.microsoft.com','portal.manage.microsoft.com','login.microsoftonline.com','*.officeconfig.msocdn.com','config.office.com','graph.windows.net','enterpriseregistration.windows.net')
                    terminateTLS         = $true
                    sourceAddresses      = @('10.129.73.8/29')
                    sourceIpGroups       = @()
                }
            }
        }
        'Deny-application'    = @{
            'Priority' = 1500
            'action' = 'Deny'
            'Rules' = @{
                'vdi-swift-to-any' = @{
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
                    sourceAddresses      = @('10.129.73.8/29')
                    sourceIpGroups       = @()
                }
            }
        }
    }
}