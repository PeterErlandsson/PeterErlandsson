@{
    'Priority'        = 20500
    'RuleCollections' = @{
        'Allow' = @{
            'Priority' = 1000
            'action'   = 'Allow'
            'Rules'    = @{
                'Vnet-to-DomainControllers'         = @{
                    source           = @('10.129.88.0/21')
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
                'Internal-to-k8s-loadbalancer-5672' = @{
                    source           = @('10.129.88.0/24')
                    destination      = @('10.126.137.250')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '5672'
                    )
                }
                'BuildAgent-to-k8s-dev-sit-tapi-tela-uat-loadbalancer-5672' = @{
                    source           = @('10.129.89.0/26')
                    destination      = @(
                        '10.126.137.250'
                        '10.126.133.250'
                        '10.126.143.250'
                        '10.126.140.250'
                        '10.126.135.250'
                        )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '5672'
                    )
                }
                'BuildAgent-https-to-k8s-sit' = @{
                    source           = @('10.129.89.0/26')
                    destination      = @(
                        '10.126.132.0/23'
                        )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '443'
                    )
                }
                'BuildAgent-https-to-k8s-dev' = @{
                    source           = @('10.129.89.0/26')
                    destination      = @(
                        '10.126.136.0/23'
                        )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '443'
                    )
                }
                'Internal-https-to-k8s-sit' = @{
                    source           = @('10.129.88.0/24')
                    destination      = @(
                        '10.126.132.0/23'
                        )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '443'
                    )
                }
                'Internal-https-to-k8s-dev' = @{
                    source           = @('10.129.88.0/24')
                    destination      = @(
                        '10.126.136.0/23'
                        )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '443'
                    )
                }
            }
        }
    }
}