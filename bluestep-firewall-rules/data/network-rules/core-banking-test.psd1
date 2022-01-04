@{
                    'Priority' = 18500
                    'RuleCollections' = @{
                        'Allow'    = @{
                            'Priority' = 1000
                            'action' = 'Allow'
                            'Rules' = @{
                                'Vnet-to-DomainControllers' = @{
                                    source           = @('10.129.40.0/21')
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
                                'snet-functions-westeu-001-to-azure-k8s-dev-5672' = @{
                                    source           = @('10.129.41.0/24')
                                    destination      = @('10.126.137.250')
                                    ipProtocols      = @('Any')
                                    destinationPorts = @(
                                        '5672'
                                    )
                                }
                                'snet-functions-westeu-001-to-sto-dbt-01-sql' = @{
                                    source           = @('10.129.41.0/24')
                                    destination      = @('10.126.10.2')
                                    ipProtocols      = @('Any')
                                    destinationPorts = @(
                                        '1433'
                                        '1434'
                                        '1444'
                                    )
                                }
                                'ModeloAPPT-To-ModeloSQLT'            = @{
                                    source           = @('10.129.40.0/29')
                                    destination      = @('10.129.40.8/29')
                                    ipProtocols      = @('tcp')
                                    destinationPorts = @('1433')
                                }
       
                            }
                        }
                    }
                }