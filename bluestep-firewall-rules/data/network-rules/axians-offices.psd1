@{
    'Priority' = 11000
    'RuleCollections' = @{
        'Allow'    = @{
            'Priority' = 1000
            'action' = 'Allow'
            'Rules' = @{
                'SthlmOffice-RDP-To-All-Production'        = @{
                    source           = @('192.168.65.0/24')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('3389')
                }
                'SthlmOffice-RDP-To-All-Test'              = @{
                    source           = @('192.168.65.0/24')
                    destination      = @('ipgtest')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('3389')
                }
                'Wifi-All-offices-RDP-To-All-Production'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('3389')
                }
                'Wifi-All-offices-RDP-To-All-Test'         = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('ipgtest')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('3389')
                }
                'All-DomainPorts-To-All-DomainControllers' = @{
                    source           = @(
                        '10.0.0.0/8'
                        '172.16.0.0/12'
                        '192.168.0.0/16'
                    )
                    destination      = @('ipgdomaincontroller')
                    ipProtocols      = @('any')
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
                'All-Https-To-All-ADFS' = @{
                    source           = @(
                        '10.0.0.0/8'
                        '172.16.0.0/12'
                        '192.168.0.0/16'
                    )
                    destination      = @('ipgadfs')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '443'
                    )
                }
                'All-Offices-Https-To-WAC' = @{
                    source           = @(
                        '10.126.40.0/23'
                        '192.168.65.0/24'
                    )
                    destination      = @('10.126.196.132')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '443'
                    )
                }
                'SthlmOffice-SSH-To-All-Production'              = @{
                    source           = @('192.168.65.0/24')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('22')
                }
                'Wifi-All-offices-SSH-To-All-Production'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('22')
                }
                'SthlmOffice-SSH-To-All-test'              = @{
                    source           = @('192.168.65.0/24')
                    destination      = @('ipgtest')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('22')
                }
                'Wifi-All-offices-SSH-To-All-test'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('ipgtest')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('22')
                }
                'Wifi-All-offices-To-PrintServer'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('10.129.73.0/29')
                    ipProtocols      = @(
                        'tcp'
                        'udp'
                        )
                    destinationPorts = @(
                        '137-139'
                        '443'
                        '445'
                    )
                }
                'Wired-All-offices-To-PrintServer'   = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    destination      = @('10.129.73.0/29')
                    ipProtocols      = @(
                        'tcp'
                        'udp'
                    )
                    destinationPorts = @(
                        '137-139'
                        '443'
                        '445'
                        '5742'
                        '7500'
                        '7700'
                        '50002-50003'
                    )
                }
                'Wired-All-offices-To-PrintServer-TempRule-Allow-Any'   = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    destination      = @('10.129.73.0/29')
                    ipProtocols      = @(
                        'Any'
                    )
                    destinationPorts = @(
                        '*'
                    )
                }
                'Wifi-All-offices-Https-To-Netbox'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('netbox.bluestep.se')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'Wired-All-offices-Https-To-Netbox'   = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    destination      = @('netbox.bluestep.se')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'Wired-All-Offices-To-GoAnywhere' = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    destination      = @('10.129.73.20')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '443'
                        '8000-8001'
                        '22'
                    )
                }
                'Wifi-All-offices-To-GoAnywhere'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @('10.129.73.20')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '443'
                        '8000-8001'
                        '22'
                    )
                }
                'All-Offices-to-ModeloAPPTest'        = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.46.0/24'
                        '10.126.40.0/23'
                        '10.126.50.0/23'
                        )
                    destination      = @('10.129.40.0/29')
                    ipProtocols      = @('tcp')
                    destinationPorts = @(
                        '80'
                        '443'
                    )
                }
                'All-Offices-to-ModeloSQLTest'        = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.46.0/24'
                        '10.126.40.0/23'
                        '10.126.50.0/23'
                        )
                    destination      = @('10.129.40.8/29')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('1433')
                }                
                'All-offices-HTTPS-To-SmartAdminPrivateLink'         = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.46.0/24'
                        '10.126.40.0/23'
                        )                    
                        destination      = @(
                        '10.128.128.7'
                        '10.128.128.4'
                        '10.128.128.6'
                        )
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'All-offices-HTTPS-To-SmartAdminPrivateLink-Prod'         = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.46.0/24'
                        '10.126.40.0/23'
                        )                    
                        destination      = @('10.128.35.4')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'Allow_All_ClientNetworks_To_MORS_PRODServers' = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.50.0/23'
                        '10.126.2.0/24'
                        '172.17.80.224/30'
                        '172.17.80.228/30'
                        '10.126.129.48/28'
                        '10.126.129.32/28'
                        '10.126.195.11'
                        '10.126.1.7'
                        )
                        destination      = @(
                        '10.129.48.8/29'
                        '10.129.48.0/29'
                        )
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '139'
                        '445'
                        '1433'
                        '3389'
                        '6677'
                        )
                }                    
                    'From_Client_Networks_To_PrevApp_PROD' = @{
                        source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.50.0/23'
                        '10.126.245.160/27'
                        )
                        destination      = @('10.129.48.16/29')
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                    'Allow_SMB_To_AgressoServers_PROD' = @{
                        source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.146.0/28'
                        '10.126.1.7'
                        '10.126.34.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.25.10'
                        '10.126.26.11'
                        '10.126.146.112/28'
                        '10.126.50.0/23'
                        '10.129.73.16/28'
                        )
                        destination      = @('10.129.48.24/29')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '139'
                        '445'
                        )
                }
                    'Allow_1433_To_UBWSQL_PROD' = @{
                        source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.146.0/28'
                        '10.126.34.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.50.0/23'
                        )
                        destination      = @('10.129.48.40/29')
                    ipProtocols      = @('any')
                    destinationPorts = @('1433')
                }
                    'Allow_Http_and_Https_To_UBWWEB_PROD' = @{
                        source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.1.2/32'
                        '10.126.0.30/32'
                        '10.126.50.0/23'
                        )
                        destination      = @('10.129.48.32/29')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '80'
                        '443'
                        )
                }
                'Allow_All_ClientNetworks_To_MORS_TestServers' = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.50.0/23'
                        '10.126.2.0/24'
                        '172.17.80.224/30'
                        '172.17.80.228/30'
                        '10.126.129.48/28'
                        '10.126.129.32/28'
                        '10.126.195.11'
                        '10.126.1.7'
                    )
                    destination      = @(
                        '10.129.64.8/29'
                        '10.129.64.0/29'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '139'
                        '445'
                        '1433'
                        '3389'
                        '6677'
                    )   
                }
                'From_Client_Networks_To_PreveroTestServers' = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.50.0/23'
                        '10.126.245.160/27'                        
                    )
                    destination      = @('10.129.64.16/29')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '443'
                        '3389'
                    )
                }
                'Port_80_And_443_ToUBWWEBT' = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.0.30/32'
                        '10.126.50.0/23'
                    )
                    destination      = @('10.129.48.32/29')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '80'
                        '443'
                    )
                }                
                'Allow SQL1433 To UBW-SQLT-01' = @{
                    source           = @(
                        '10.126.130.112/28'
                        '192.168.65.0/24'
                        '10.126.40.0/23'
                        '10.126.34.0/24'
                        '10.126.42.0/24'
                        '10.126.60.0/24'
                        '10.126.50.0/23'
                    )
                    destination      = @('10.129.64.40/29')
                    ipProtocols      = @('any')
                    destinationPorts = @('1433')
                }
                'Wifi-All-offices-443-To-aks-ingress'   = @{
                    source           = @('10.126.40.0/23')
                    destination      = @(
                        '10.128.0.250'
                        '10.128.144.250'
                        '10.128.148.250'
                        '10.128.160.250'
                    )
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'Wired-All-offices-443-To-aks-ingress'   = @{
                    source           = @(
                        '192.168.65.0/24'
                        '10.126.42.0/24'
                        '10.126.46.0/24'
                        '10.126.60.0/24'
                    )
                    destination      = @(
                        '10.128.0.250'
                        '10.128.144.250'
                        '10.128.148.250'
                        '10.128.160.250'
                    )
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
            }
        }
    }
}