# Introduction 
The folder .\data contains different type of rules allowed in the Azure Firewall.

## The important thing to be aware of is the following:
Network rules are applied in priority order before application rules. 
The rules are terminating. So, if a match is found in a network rule, no other rules are processed.
If there's no network rule match, and if the protocol is HTTP, HTTPS, or MSSQL, the packet is then evaluated by the application rules in priority order.

### Network rules 
Source: Supports specific IPs, IP ranges or IP Groups.
Destination: Supports specific IPs, IP ranges, Service tags, IP Groups or FQDN.

### Application rules
Source: Supports specific IPs, IP ranges or IP Groups.
Destination: Supports FQDN, FQDN tags, Web categories or URL.


#### Notes
- Network rules do support FQDN, however it does not support TLS inspection.
https://docs.microsoft.com/en-us/azure/firewall/premium-features#tls-inspection

## Links to read more:
Outbound rule processing: https://docs.microsoft.com/en-us/azure/firewall/rule-processing#outbound-connectivity
Inbound rule processing: https://docs.microsoft.com/en-us/azure/firewall/rule-processing#inbound-connectivity

## Available IP Groups: 
#### IPGProduction
- 10.128.0.0/18
- 10.129.0.0/21
- 10.129.24.0/21
- 10.129.48.0/21
- 10.129.72.0/21
- 10.129.96.0/21
- 10.129.120.0/21
- 10.129.152.0/21

#### IPGDomainController
- 10.126.196.20
- 10.126.196.22
- 10.126.0.11
- 10.126.0.12

#### IPGADFS
- 10.126.196.36
- 10.126.196.37
- 10.126.196.38

#### IPGTest
- 10.128.128.0/18
- 10.129.16.0/21
- 10.129.40.0/21
- 10.129.64.0/21
- 10.129.88.0/21
- 10.129.112.0/21
- 10.129.136.0/21
- 10.129.160.0/21

#### IPGSandbox
- 10.128.64.0/18
- 10.129.8.0/21
- 10.129.32.0/21
- 10.129.56.0/21
- 10.129.80.0/21
- 10.129.104.0/21
- 10.129.128.0/21


## Examples
### Network rule called 'AADConnect-to-Internet' with a source IP, to any destination and allow 443 + 80 (https/http)
```PowerShell
'AADConnect-to-Internet' = @{
    ruleType         = 'NetworkRule'
    source           = @('10.129.72.0/24')
    destination      = @('*')
    ipProtocols      = @('TCP')
    destinationPorts = @('443','80')
}
```

### Network rule called 'AADConnect-to-ProductionIPG' with a source IP, to any destination in the IP group "ipg-production" and allow 445 (smb)
```PowerShell
'AADConnect-to-IPG-Production' = @{
    ruleType         = 'NetworkRule'
    source           = @('10.129.72.0/24')
    destination      = @('ipg-production')
    ipProtocols      = @('TCP')
    destinationPorts = @('445')
}
```

### Application rule called 'Netbox' that allow traffic to a specific IP or FQDN from any source over https and http.
```PowerShell
'Netbox' = @{
    Protocols = @(
        @{
            protocolType = 'Https'
            port = 443
        }
        @{
            protocolType = 'Http'
            port = 80
        }
    )
    fqdnTags             = @()
    webCategories        = @()
    targetFqdns          = @('netbox.bluestep.se')
    targetUrls           = @()
    terminateTLS         = $false
    sourceAddresses      = @('*')
    sourceIpGroups       = @()
}
```