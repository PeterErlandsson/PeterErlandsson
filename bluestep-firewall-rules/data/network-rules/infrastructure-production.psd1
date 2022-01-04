@{
    'Priority'        = 20000
    'RuleCollections' = @{
        'Allow' = @{
            'Priority' = 1000
            'action'   = 'Allow'
            'Rules'    = @{
                'Vnet-to-DomainControllers'        = @{
                    source           = @('10.129.72.0/21')
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
                'AADConnect-to-Internet'           = @{
                    source           = @('10.129.72.0/24')
                    destination      = @('*')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('443', '80')
                }
                'Infra-internal-https-to-Internet' = @{
                    source           = @('10.129.72.0/24')
                    destination      = @('*')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('443')
                }
                'PrintServer-to-Wired-All-offices' = @{
                    source           = @(
                        '10.129.73.0/29'
                    )
                    destination      = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    ipProtocols      = @(
                        'tcp'
                        'udp'
                    )
                    destinationPorts = @(
                        '80'
                        '443'
                        '9100'
                        '50002-50003'
                        '161'
                    )
                }
                'GoAnywhere-to-Axians-servers' = @{
                    source           = @('10.129.73.20')
                    destination      = @(
                        '10.126.0.0/19'
                        '10.126.64.0/19'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '139'
                        '445'
                    )
                }
                'GoAnywhere-to-Office365-SMTP' = @{
                    source           = @('10.129.73.20')
                    destination      = @(
                        'smtp.office365.com'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '587'
                    )
                }
                'GoAnywhere-to-SynaSE-SFTP' = @{
                    source           = @('10.129.73.20')
                    destination      = @(
                        'sftp01.syna.se'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '25852'
                    )
                }
                'GoAnywhere-to-CatalystOne' = @{
                    source           = @('10.129.73.20')
                    destination      = @(
                        'hosted8.catalystone.com'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '22'
                    )
                }
                'GoAnywhere-to-Aller' = @{
                    source           = @('10.129.73.20')
                    destination      = @(
                        'sftp.datarefinery.io'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '22'
                    )
                }
                'GoAnywhere-to-UCTambur-SFTP' = @{
                    source           = @('10.129.73.20')
                    destination      = @(
                        'btxdmz.eintegration.net'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '22'
                    )
                }
                'GoAnywhere-to-webservers' = @{
                    source           = @('10.129.73.16/28')
                    destination      = @(
                        '10.129.136.4'
                        '10.129.136.8'
                        '10.129.136.6'
                        '10.129.136.7'
                        '10.129.120.4'
                        '10.129.120.5'
                        '10.129.120.6'
                    )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '445'
                    )
                }
                'GoAnywhere-to-azubwapp01' = @{
                    source           = @('10.129.73.16/28')
                    destination      = @(
                        '10.126.146.6'
                    )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '445'
                    )
                }
                'vdi-swift-to-Swift-vpn-31501' = @{
                    source           = @('10.129.73.8/29')
                    destination      = @(
                        'p16x.dhsb.ch'
                        't16x.dhsb.ch'
                    )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '31501'
                    )
                }
                'vdi-swift-to-AzureVirtualDesktop-ip' = @{
                    source           = @('10.129.73.8/29')
                    destination      = @(
                        '169.254.169.254'
                        '168.63.129.16'
                    )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '80'
                    )
                }
                'vdi-swift-to-Splunk' = @{
                    source           = @('10.129.73.8/29')
                    destination      = @(
                        '10.126.66.12'
                    )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '8089'
                    )
                }
                'vdi-swift-to-AzureVirtualDesktop-Servicetag' = @{
                    source           = @('10.129.73.8/29')
                    destination      = @(
                        'AzureCloud'
                        'WindowsVirtualDesktop'
                    )
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '443'
                    )
                }
                'PrintServer-to-Wired-All-offices-TempRule-Allow-Everything' = @{
                    source           = @(
                        '10.129.73.0/29'
                    )
                    destination      = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    ipProtocols      = @(
                        'any'
                    )
                    destinationPorts = @(
                        '*'
                    )
                }
                'BuildAgent-to-k8s-api-ela-prod-loadbalancer-5672' = @{
                    source           = @('10.129.73.64/26')
                    destination      = @(
                        '10.126.157.250'
                        '10.126.145.250'
                        '10.126.151.250'
                        )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '5672'
                    )
                     }
                'vmexchange001-To-Exchangeservers-temprule-for-installation' = @{
                    source           = @('10.129.73.52')
                    destination      = @(
                        '10.126.0.20'
                        '10.126.0.21'
                        )
                    ipProtocols      = @('Any')
                    destinationPorts = @(
                        '*'
                    )
                }
            }
        }
    }
}