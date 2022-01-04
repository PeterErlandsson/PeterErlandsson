@{
                    'Priority' = 19000
                    'RuleCollections' = @{
                        'Allow'    = @{
                            'Priority' = 1000
                            'action' = 'Allow'
                            'Rules' = @{
                                'Vnet-to-DomainControllers' = @{
                                    source           = @('10.129.48.0/21')
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
                                'Allow_MORS_Prod_App_to_Bloomberg_SFTP' = @{
                                    source           = @('10.129.48.0/29')
                                    destination      = @(
                                        '205.216.112.23'
                                        '208.22.57.176'
                                    )
                                    ipProtocols      = @('any')
                                    destinationPorts = @('22')
                                }
                                'Allow_MORS_Prod_App_to_Bloomberg_HTTPS' = @{
                                    source           = @('10.129.48.0/29')
                                    destination      = @(
                                        '69.191.229.90'
                                        '69.191.193.90'
                                    )
                                    ipProtocols      = @('any')
                                    destinationPorts = @('443')
                                }
                                'Allow_MORS_Prod_App_to_O365_SMTP' = @{
                                    source           = @('10.129.48.0/29')
                                    destination      = @(
                                        'smtp.office365.com'
                                    )
                                    ipProtocols      = @('any')
                                    destinationPorts = @('587')
                                }
                                'Allow_PrevApp_To_UBWWeb PROD' = @{
                                    source           = @('10.129.48.16/29')
                                    destination      = @(
                                        '10.129.48.32/29'
                                        '10.126.146.0/28'
                                        )
                                ipProtocols      = @('any')
                                destinationPorts = @('443')
                                }
                            }
                        }
                    }
                }