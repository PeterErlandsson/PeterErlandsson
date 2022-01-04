@{
    'Priority' = 14000
    'RuleCollections' = @{
        'Allow'    = @{
            'Priority' = 1000
            'action' = 'Allow'
            'Rules' = @{
                'Jumphub-rdp-to-all'  = @{
                    source       = @('10.126.196.68')
                    destination  = @('*')
                    ipProtocols  = @('Any')
                    destinationPorts = @('3389')
                }
                'Jumphub-ping-to-all' = @{
                    source           = @('10.126.196.68')
                    destination      = @('*')
                    ipProtocols      = @('ICMP')
                    destinationPorts = @('*')
                }
            }
        }
    }
}