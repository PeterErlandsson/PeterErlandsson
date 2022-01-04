[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $WhatIf,
    
    # ResourceGroupName
    [Parameter(Mandatory)]
    [string]
    $ResourceGroupName
)

### This deploys the full solution where rules use the ip groups
$params = @{
    Name = 'Bluestep-Firewall-rules'
    TemplateFile = '.\main.bicep'
    #TemplateParameterFile = '.\parameters.json'
    ResourceGroupName = $ResourceGroupName
}

#IP Group configuration
$ProductionIP = @(
    '10.128.0.0/18'
    '10.129.0.0/21'
    '10.129.24.0/21'
    '10.129.48.0/21'
    '10.129.72.0/21'
    '10.129.96.0/21'
    '10.129.120.0/21'
    '10.129.152.0/21'
)

$DomainControllerIP = @(
    '10.126.196.20'
    '10.126.196.22'
    '10.126.0.11'
    '10.126.0.12'
)

$ADFSIP = @(
    '10.126.196.36'
    '10.126.196.37'
    '10.126.196.38'
)

$TestIP = @(
    '10.128.128.0/18'
    '10.129.16.0/21'
    '10.129.40.0/21'
    '10.129.64.0/21'
    '10.129.88.0/21'
    '10.129.112.0/21'
    '10.129.136.0/21'
    '10.129.160.0/21'
)

$SandboxIP = @(
    '10.128.64.0/18'
    '10.129.8.0/21'
    '10.129.32.0/21'
    '10.129.56.0/21'
    '10.129.80.0/21'
    '10.129.104.0/21'
    '10.129.128.0/21'
)

if ($WhatIf.IsPresent) {
    $params.whatif = $true 
    Write-Verbose "Doing a whatif deployment.." -Verbose
} else {
    $ProductionIPG = Get-AzIPgroup -Name 'ipg-production'
    if (! $ProductionIPG) {
        New-AzIpGroup -Name 'ipg-production' -ResourceGroupName $params.ResourceGroupName -Location $params.Location -IpAddress $ProductionIP
    } else {
        $ProductionIP | Foreach-object {
            if ($_ -in $ProductionIPG.IpAddresses) {
                Write-Verbose "The IP range $_ is found in the Production IP Group." -Verbose
            } else {
                $ProductionIPG.IpAddresses = $ProductionIP
                Set-AzIpGroup -IpGroup $ProductionIPG
                Write-Verbose "Stopping processing for production IPG, as a mismatch was found, a new full deployment is made." -Verbose
                Break
            }
        }
    }
    
    $TestIPG = Get-AzIPgroup -Name 'ipg-test'
    if (! $TestIPG) {
        New-AzIpGroup -Name 'ipg-test' -ResourceGroupName $params.ResourceGroupName -Location $params.Location -IpAddress $TestIP
    } else {
        $TestIP | Foreach-object {
            if ($_ -in $TestIPG.IpAddresses) {
                Write-Verbose "The IP range $_ is found in the Test IP Group." -Verbose
            } else {
                $TestIPG.IpAddresses = $TestIP
                Set-AzIpGroup -IpGroup $TestIPG
                Write-Verbose "Stopping processing for test IPG, as a mismatch was found, a new full deployment is made." -Verbose
                Break
            }
        }
    }
    
    $DomainControllerIPG = Get-AzIPgroup -Name 'ipg-domaincontroller'
    if (! $DomainControllerIPG) {
        New-AzIpGroup -Name 'ipg-domaincontroller' -ResourceGroupName $params.ResourceGroupName -Location $params.Location -IpAddress $DomainControllerIP
    } else {
        $DomainControllerIP | Foreach-object {
            if ($_ -in $DomainControllerIPG.IpAddresses) {
                Write-Verbose "The IP range $_ is found in the Domain controller IP Group." -Verbose
            } else {
                $DomainControllerIPG.IpAddresses = $DomainControllerIP
                Set-AzIpGroup -IpGroup $DomainControllerIPG
                Write-Verbose "Stopping processing for Domain controller IPG, as a mismatch was found, a new full deployment is made." -Verbose
                Break
            }
        }
    }

    $ADFSIPG = Get-AzIPgroup -Name 'ipg-ADFS'
    if (! $ADFSIPG) {
        New-AzIpGroup -Name 'ipg-ADFS' -ResourceGroupName $params.ResourceGroupName -Location $params.Location -IpAddress $ADFSIP
    } else {
        $ADFSIP | Foreach-object {
            if ($_ -in $ADFSIPG.IpAddresses) {
                Write-Verbose "The IP range $_ is found in the ADFS IP Group." -Verbose
            } else {
                $ADFSIPG.IpAddresses = $ADFSIP
                Set-AzIpGroup -IpGroup $ADFSIPG
                Write-Verbose "Stopping processing for ADFS IPG, as a mismatch was found, a new full deployment is made." -Verbose
                Break
            }
        }
    }
    
    $SandboxIPG = Get-AzIPgroup -Name 'ipg-sandbox' 
    if (! $SandboxIPG) {
        New-AzIpGroup -Name 'ipg-sandbox' -ResourceGroupName $params.ResourceGroupName -Location $params.Location -IpAddress $SandboxIP
    } else {
        $SandboxIP | Foreach-object {
            if ($_ -in $SandboxIPG.IpAddresses) {
                Write-Verbose "The IP range $_ is found in the Sandbox IP Group." -Verbose
            } else {
                $SandboxIPG.IpAddresses = $SandboxIP
                Set-AzIpGroup -IpGroup $SandboxIPG
                Write-Verbose "Stopping processing for Sandbox IPG, as a mismatch was found, a new full deployment is made." -Verbose
                Break
            }
        }
    }
}

# Create the install folder
$installPath = "$env:USERPROFILE\.bicep"
$installDir = New-Item -ItemType Directory -Path $installPath -Force
$installDir.Attributes += 'Hidden'
# Fetch the latest Bicep CLI binary
(New-Object Net.WebClient).DownloadFile("https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe", "$installPath\bicep.exe")
# Add bicep to your PATH
$currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
if (-not $currentPath.Contains("%USERPROFILE%\.bicep")) { setx PATH ($currentPath + ";%USERPROFILE%\.bicep") }
if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }

New-AzResourceGroupDeployment @params