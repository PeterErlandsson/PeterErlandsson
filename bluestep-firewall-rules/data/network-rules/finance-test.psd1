@{
    'Priority' = 19500
    'RuleCollections' = @{
        'Allow'    = @{
            'Priority' = 1000
            'action' = 'Allow'
            'Rules' = @{
                'Vnet-to-DomainControllers' = @{
                    source           = @('10.129.64.0/21')
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
                'From_Prevappt_To_Ubwwebt_443' = @{
                    source           = @('10.129.64.16/29')
                    destination      = @(
                        '10.129.64.32/29'
                        '10.126.130.112/28'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                'From_Mors_Test_To_Office365_SMTP' = @{
                    source           = @('10.129.64.13')
                    destination      = @('smtp.office365.com')
                    ipProtocols      = @('any')
                    destinationPorts = @('587')
                }
            }
        }
    }
}