@{
    'Priority' = 12000
    'RuleCollections' = @{
        'Allow'    = @{
            'Priority' = 1000
            'action' = 'Allow'
            'Rules' = @{
                'prod-gen-AD-Audit-Incoming' = @{
                    source           = @('10.126.1.5')
                    destination      = @('ipgadfs')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '135'
                        '137'
                        '138'
                        '139'
                        '445'
                        '49152-65535'
                    )
                }
                'prod-gen-AD-Audit-Incoming-DCs' = @{
                    source           = @('10.126.1.5')
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '389'
                        '636'
                        '3268'
                        '3269'
                        '88'
                        '135'
                        '137'
                        '138'
                        '139'
                        '445'
                        '49152-65535'
                    )
                }
                'sto-cm-01-To-Exchange-TempRuleForInstallation' = @{
                    source           = @('10.126.0.16')
                    destination      = @('10.129.73.52')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '3389'
                    )
                }
                'Exchangeservers-To-vmexchange001-TempRuleForInstallation' = @{
                    source           = @(
                        '10.126.0.20'
                        '10.126.0.21'
                    )
                    destination      = @('10.129.73.52')
                    ipProtocols      = @('Any')
                    destinationPorts = @('*')
                }
                's-lb-acc-npm-to-jumpsrvtest' = @{
                    source           = @('10.126.13.11')
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '389'
                        '636'
                        '3268'
                        '3269'
                        '88'
                        '135'
                        '137'
                        '138'
                        '139'
                        '445'
                        '49152-65535'
                    )
                }
                
            }
        }
    }
}