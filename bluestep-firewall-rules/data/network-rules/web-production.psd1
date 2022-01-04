@{
                    'Priority' = 23000
                    'RuleCollections' = @{
                        'Allow'    = @{
                            'Priority' = 1000
                            'action' = 'Allow'
                            'Rules' = @{
                                'Vnet-to-DomainControllers' = @{
                                    source           = @('10.129.120.0/21')
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
                                'frontend-to-np-customerpages' = @{
                                    source           = @('10.129.120.0/26')
                                    destination      = @('10.126.146.36')
                                    ipProtocols      = @('Any')
                                    destinationPorts = @(
                                        '443'
                                    )
                                }
                            }
                        }
                    }
                }