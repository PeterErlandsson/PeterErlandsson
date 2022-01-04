@{
    'Priority' = 9000
    'RuleCollections' = @{
        'Deny'    = @{
            'Priority' = 1000
            'action' = 'Deny'
            'Rules' = @{
                'Deny-Sandbox-to-Production' = @{
                    source           = @('ipgsandbox')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '*'
                    )
                }
                'Deny-Sandbox-to-Test' = @{
                    source           = @('ipgsandbox')
                    destination      = @('ipgtest')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '*'
                    )
                }
                'Deny-All-to-Sandbox' = @{
                    source           = @('*')
                    destination      = @('ipgsandbox')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '*'
                    )
                }
            }
        }
    }
}