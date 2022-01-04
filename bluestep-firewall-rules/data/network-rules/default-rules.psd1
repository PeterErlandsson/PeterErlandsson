@{
    'Priority'        = 50000
    'RuleCollections' = @{
        'Allow' = @{
            'Priority' = 1000
            'action'   = 'Allow'
            'Rules'    = @{
                'DomainControllers-to-production'      = @{
                    source           = @('ipgdomaincontroller')
                    destination      = @('ipgproduction')
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
                'DomainControllers-to-test'            = @{
                    source           = @('ipgdomaincontroller')
                    destination      = @('ipgtest')
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
                'DomainController-to-Domaincontroller' = @{
                    source           = @('ipgdomaincontroller')
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
                'Production-to-DomainControllers'      = @{
                    source           = @('ipgproduction')
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '88'
                        '135'
                        '137'
                        '138'
                        '139'
                        '389'
                        '445'
                        '636'
                        '3268'
                        '3269'
                        '49152-65535'
                    )
                }
                'Test-to-DomainControllers'            = @{
                    source           = @('ipgtest')
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '88'
                        '135'
                        '137'
                        '138'
                        '139'
                        '389'
                        '445'
                        '636'
                        '3268'
                        '3269'
                        '49152-65535'
                    )
                }
                'Production-ICMP-to-DomainControllers'        = @{
                    source           = @('ipgProduction')
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('ICMP')
                    destinationPorts = @('*')
                }
                'Test-ICMP-to-DomainControllers'              = @{
                    source           = @('ipgtest')
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('ICMP')
                    destinationPorts = @('*')
                }
                'Production-ICMP-to-production'        = @{
                    source           = @('ipgproduction')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('ICMP')
                    destinationPorts = @('*')
                }
                'Test-ICMP-to-production'              = @{
                    source           = @('ipgtest')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('ICMP')
                    destinationPorts = @('*')
                }
                'Production-ICMP-to-test'              = @{
                    source           = @('ipgproduction')
                    destination      = @('ipgtest')
                    ipProtocols      = @('ICMP')
                    destinationPorts = @('*')
                }
                'Production-DNS-to-onpremise'          = @{
                    source           = @('ipgproduction')
                    destination      = @('10.126.0.0/15')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('53')
                }
                'Jumphub-RDP-to-Production'            = @{
                    source           = @('10.126.196.64/28')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('3389')
                }
                'Old-Vnets-DNS-to-DomainControllers'   = @{
                    source           = @(
                        '10.126.128.0/20'
                        '10.126.144.0/20'
                        '10.126.194.0/24'
                        '10.126.192.0/24'
                        '10.126.196.0/23'
                    )
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('any')
                    destinationPorts = @('53')
                }
                'Production-Https-to-ADFS'             = @{
                    source           = @('ipgproduction')
                    destination      = @('ipgadfs')
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                'Test-Https-to-ADFS'                   = @{
                    source           = @('ipgtest')
                    destination      = @('ipgadfs')
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                'WAC-to-Production'                    = @{
                    source           = @('10.126.196.132')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('any')
                    destinationPorts = @('5985')
                }
                'WAC-to-Test'                          = @{
                    source           = @('10.126.196.132')
                    destination      = @('ipgtest')
                    ipProtocols      = @('any')
                    destinationPorts = @('5985')
                }
                'Any-to-AzureCloud'                    = @{
                    source           = @('*')
                    destination      = @('AzureCloud')
                    ipProtocols      = @('any')
                    destinationPorts = @('*')
                }
                'Production-to-WindowsTime'            = @{
                    source           = @('ipgproduction')
                    destination      = @('time.windows.com')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '123'
                    )
                }
                'Test-to-WindowsTime'                  = @{
                    source           = @('ipgtest')
                    destination      = @('time.windows.com')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '123'
                    )
                }
                'Production-to-WindowsKMS'             = @{
                    source           = @('ipgproduction')
                    destination      = @('kms.core.windows.net')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '1688'
                    )
                }
                'Test-to-WindowsKMS'                   = @{
                    source           = @('ipgtest')
                    destination      = @('kms.core.windows.net')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '1688'
                    )
                }
                'Production-to-Kaseya'                 = @{
                    source           = @('ipgproduction')
                    destination      = @('support.bluestep.se')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '5721'
                    )
                }
                'Test-to-Kaseya'                       = @{
                    source           = @('ipgtest')
                    destination      = @('support.bluestep.se')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '5721'
                    )
                }
                'Production-to-Splunk-onpremise'       = @{
                    source           = @('ipgproduction')
                    destination      = @(
                        '10.126.66.12'
                    )
                    ipProtocols      = @(
                        'TCP'
                        'UDP'
                    )
                    destinationPorts = @(
                        '514'
                        '8089-8090'
                        '9997'
                    )
                }
                'Test-to-Splunk-onpremise'             = @{
                    source           = @('ipgtest')
                    destination      = @(
                        '10.126.66.12'
                    )
                    ipProtocols      = @(
                        'TCP'
                        'UDP'
                    )
                    destinationPorts = @(
                        '514'
                        '8089-8090'
                        '9997'
                    )
                }
                'Production-https-to-WAP'              = @{
                    source           = @('ipgproduction')
                    destination      = @(
                        '10.126.196.53'
                        '10.126.196.54'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                'Test-https-to-WAP'                    = @{
                    source           = @('ipgtest')
                    destination      = @(
                        '10.126.196.53'
                        '10.126.196.54'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                'Production-DCOM-to-CA'              = @{
                    source           = @('ipgproduction')
                    destination      = @('10.126.0.27')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('135')
                }
                'Test-DCOM-to-CA'                    = @{
                    source           = @('ipgtest')
                    destination      = @('10.126.0.27')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('135')
                }
            }
        }
    }
}