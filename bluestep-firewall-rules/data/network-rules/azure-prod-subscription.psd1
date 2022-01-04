@{
    'Priority' = 15000
    'RuleCollections' = @{
        'Example'    = @{
            'Priority' = 1000
            'action' = 'Allow'
            'Rules' = @{
                'Example' = @{
                    source           = @()
                    destination      = @()
                    ipProtocols      = @()
                    destinationPorts = @()
                }
            }
        }
    }
}