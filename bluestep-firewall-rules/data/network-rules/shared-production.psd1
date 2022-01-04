@{
                    'Priority' = 22000
                    'RuleCollections' = @{
                        'Allow'    = @{
                            'Priority' = 1000
                            'action' = 'Allow'
                            'Rules' = @{
                                'Vnet-to-DomainControllers' = @{
                                    source           = @('10.128.0.0/18')
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
                }