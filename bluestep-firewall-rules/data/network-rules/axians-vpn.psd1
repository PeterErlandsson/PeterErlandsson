@{
    'Priority' = 13000
    'RuleCollections' = @{
        'Allow'    = @{
            'Priority' = 1000
            'action' = 'Allow'
            'Rules' = @{
                'VPN-F5-Generic-staff-RDP-To-All-Production' = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('3389')
                }
                'VPN-F5-Generic-staff-RDP-To-All-Test' = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('ipgtest')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('3389')
                }
                'VPN-webdev-clients-RDP-To-All-Production' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('3389')
                }
                'VPN-F5-Generic-staff-VPN-CNGroup-clients-HTTPS-To-SmartAdminPrivateLink'         = @{
                    source           = @(
                        '10.126.50.0/23'
                        '10.126.45.32/27'
                        )                    
                        destination      = @('10.128.128.7'
                                         '10.128.128.4'
                                         '10.128.128.6')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                 'VPN-F5-Generic-staff-VPN-CNGroup-clients-HTTPS-To-SmartAdminPrivateLink-Prod'         = @{
                    source           = @(
                        '10.126.50.0/23'
                        '10.126.45.32/27'
                        )                    
                        destination      = @('10.128.35.4')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'VPN-webdev-clients-RDP-To-All-Test' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('ipgtest')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('3389')
                }
                'VPN-CNGroup-clients-RDP-To-VNet-web-Test' = @{
                    source           = @('10.126.45.32/27')
                    destination      = @('10.129.136.0/21')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('3389')
                }
                'VPN-CNGroup-clients-WWW-To-ag-web-uat-web-Test' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('10.129.136.68')
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '80'
                        '443'
                    )
                }
                'VPN-CNGroup-clients-WWW-To-Frontend-Web-Production-Administration' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('10.129.120.4')
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '80'
                        '443'
                    )
                }
                  'VPN-CNGroup-clients-WWW-To-Frontend-Web-Production' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('10.129.120.64/26')
                    ipProtocols      = @('TCP')
                    destinationPorts = @(
                        '80'
                        '443'
                    )
                }
                'VPN-F5-Generic-staff-SSH-To-All-Production' = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('22')
                }
                'VPN-webdev-clients-SSH-To-All-Production' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('ipgproduction')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('22')
                }
                'VPN-F5-Generic-staff-To-PrintServer'   = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('10.129.73.0/29')
                    ipProtocols      = @(
                        'tcp'
                        'udp'
                    )
                    destinationPorts = @(
                        '139'
                        '443'
                        '445'
                        '50002'
                        '8080'
                        '137-138'
                    )
                }
                'VPN-F5-Generic-staff-Https-To-Netbox'   = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('netbox.bluestep.se')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'VPN-webdev-clients-Https-To-Netbox' = @{
                    source           = @('10.126.45.0/27')
                    destination      = @('netbox.bluestep.se')
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'VPN-F5-Generic-staff-To-GoAnywhere'   = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('10.129.73.20')
                    ipProtocols      = @('any')
                    destinationPorts = @(
                        '443'
                        '8000-8001'
                        '22'
                    )
                }
                'VPN-F5-Generic-staff-SSH-To-All-Test' = @{
                    source           = @('10.126.50.0/23')
                    destination      = @('ipgtest')
                    ipProtocols      = @('TCP')
                    destinationPorts = @('22')
                }
                'Allow_F5_MORS_TO_MORS_Servers' = @{
                    source           = @('10.126.45.224/27')
                    destination      = @(
                                        '10.129.48.8/29'
                                        '10.129.48.0/29'
                                        '10.129.64.0/29'
                                        '10.129.64.8/29'
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
                'Allow_F5_Prevero_to_AgressoPRODServers' = @{
                        source           = @('10.126.245.160/27')
                        destination      = @(
                                    '10.129.48.24/29'
                                    '10.129.48.32/29'
                                    '10.129.48.40/29'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @(
                            '443'
                            '3389'
                    )
                }
                'Allow_F5_Prevero_to_UBWSQLT' = @{
                    source           = @('10.126.245.160/27')
                    destination      = @('10.129.64.40/29')
                    ipProtocols      = @('any')
                    destinationPorts = @('1433')
                }
                'Allow_F5_Prevero_To_UBWWEBT' = @{
                    source           = @('10.126.245.160/27')
                    destination      = @('10.129.64.32/29')
                    ipProtocols      = @('any')
                    destinationPorts = @('443')
                }
                'Allow_F5_Prevero_to_PreveroAppServers' = @{
                        source           = @('10.126.245.160/27')
                        destination      = @(
                                    '10.129.48.16/29'
                                    '10.129.64.16/29'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @(
                            '443'
                            '3389'
                    )
                }
                'Allow_F5_UBW_to_AgressoServers' = @{
                        source           = @(
                                    '10.126.245.64/27'
                                    '10.126.245.96/27'
                    )
                    destination      = @(
                                    '10.129.48.24/29'
                                    '10.129.48.32/29'
                                    '10.129.48.40/29'
                                    '10.129.64.24/29'
                                    '10.129.64.32/29'
                                    '10.129.64.40/29'
                    )
                    ipProtocols      = @('any')
                    destinationPorts = @(
                            '443'
                            '3389'
                    )
                }
                'VPN-F5-Generic-staff-443-To-aks-ingress'   = @{
                    source           = @('10.126.50.0/23')
                    destination      = @(
                        '10.128.0.250'
                        '10.128.144.250'
                        '10.128.148.250'
                        '10.128.160.250'
                    )
                    ipProtocols      = @('tcp')
                    destinationPorts = @('443')
                }
                'VPN-F5-webdev-staff-443-To-aks-ingress'   = @{
                    source           = @('10.126.45.0/27')
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