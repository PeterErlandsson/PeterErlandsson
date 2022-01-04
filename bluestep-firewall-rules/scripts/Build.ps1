Write-verbose "Creating all the Network rules.." -Verbose

$NetworkRuleFiles = Get-ChildItem -Path '.\data\network-rules' -Filter '*.psd1'
$ApplicationRuleFiles = Get-ChildItem -Path '.\data\application-rules' -Filter '*.psd1'

$URI = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=56519'
$HTMLPath = "$Env:Temp\AzuserServices.html"
$JSONPath = "$Env:Temp\AzuserServices.JSON"
Invoke-WebRequest -Uri $URI -UseBasicParsing -OutFile $HTMLPath
$Node = Select-Xml -Path $HTMLPath -Namespace @{ns = 'http://www.w3.org/1999/xhtml' } -XPath '//ns:a[@class = "mscom-link failoverLink"]/@href'
$URI = $Node.node.'#text'
Invoke-WebRequest -Uri $URI -UseBasicParsing -OutFile $JSONPath
$JSON = Get-Content -Path $JSONPath -Raw -Encoding UTF8
$Objects = $JSON | ConvertFrom-Json
$AzureServiceTags = $Objects.values.Name

$NetworkRuleFiles | ForEach-Object -Begin {
    # Array for ALL the RuleCollectionGroups
    $RuleCollectionGroupArray = New-Object System.Collections.ArrayList
} -Process {
    $CurrentFile = Import-PowerShellDataFile -LiteralPath $_.FullName
    $RuleCollectionGroupName = $_.Name -replace '.psd1'
    $RuleCollectionGroupPriority = $CurrentFile['Priority']
    $RuleCollectionGroupCollections = New-Object System.Collections.ArrayList
    $CurrentFile.RuleCollections.GetEnumerator() | Where-Object {
        $_.Name -ne 'Example'
    } | ForEach-Object {
        $CurrentRuleCollectionName = $_.Name
        $NetworkRuleCollectionGroup = New-Object System.Collections.ArrayList
        $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Rules.Keys | ForEach-Object {
            $RuleName = $_
            $RuleObject = $CurrentFile.RuleCollections[$CurrentRuleCollectionName]['Rules'][$RuleName]
            $Rule = [PSCustomObject]@{
                'name'             = $RuleName
                'ruleType'         = 'NetworkRule'
                'ipProtocols'      = $RuleObject.ipProtocols
                'destinationPorts' = $RuleObject.destinationPorts
            }
    
            if ($RuleObject.source -like '*.*.*.*/*' -or $RuleObject.source -like '*.*.*.*' -or $RuleObject.source -eq '*') {
                Add-Member -InputObject $Rule -Name 'sourceAddresses' -Value $RuleObject.source -MemberType NoteProperty
            }
            elseif ($RuleObject.source -like '*ipg*') {
                Add-Member -InputObject $Rule -Name 'sourceIpGroups' -Value @($($RuleObject.source | ForEach-Object {
                            "$_`.id"
                        }))  -MemberType NoteProperty
            }
            else {
                Throw "$RuleName in $RuleCollectionGroupName is missing a valid source!"
            }
    
            if ($RuleObject.destination -like '*.*.*.*/*' -or $RuleObject.destination -like '*.*.*.*' -or $RuleObject.destination -eq '*') {
                Add-Member -InputObject $Rule -Name 'destinationAddresses' -Value $RuleObject.destination -MemberType NoteProperty
            }
            elseif ($RuleObject.destination -like '*ipg*') {
                Add-Member -InputObject $Rule -Name 'destinationIpGroups' -Value @($($RuleObject.destination | ForEach-Object {
                            "$_`.id"
                        })) -MemberType NoteProperty
            }
            elseif (($RuleObject.destination.split('.'))[-1] -in @('se', 'com', 'no', 'fi', 'dk', 'net','ch','org','de','uk','io')) {
                Write-verbose "Assuming that we're targeting a website for the destination: $($RuleObject.destination)" -Verbose
                Add-Member -InputObject $Rule -Name 'destinationFqdns' -Value $RuleObject.destination -MemberType NoteProperty
            }
            elseif ($RuleObject.destination[0] -in $AzureServiceTags) {
                Write-verbose "Found a match for using Azure Service tags: $($RuleObject.destination)" -Verbose
                Add-Member -InputObject $Rule -Name 'destinationAddresses' -Value $RuleObject.destination -MemberType NoteProperty
            }
            else {
                Throw "$RuleName in $RuleCollectionGroupName is missing a valid destination $($RuleObject.destination)!"
            }
            $NetworkRuleCollectionGroup.Add($Rule) | Out-Null
        }
        $RuleCollectionGroupCollections.Add(
            @{
                Name                 = $_.Name
                'ruleCollectionType' = 'FirewallPolicyFilterRuleCollection'
                Priority             = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Priority
                Action               = @{
                    'type' = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Action
                }
                Rules                = $NetworkRuleCollectionGroup
            }
        ) | Out-Null
    }
    
    Write-Verbose "Processing application rules for $RuleCollectionGroupName" -Verbose
    $ApplicationRuleFiles | 
    Where-Object { $_.Name -eq "$RuleCollectionGroupName.psd1" } | 
    ForEach-Object -Process {
        $CurrentFile = Import-PowerShellDataFile -LiteralPath $_.FullName
        $RuleCollectionGroupName = $_.Name -replace '.psd1'
        $CurrentFile.RuleCollections.GetEnumerator() | Where-Object {
            $_.Name -ne 'Example-fqdn'
        } | ForEach-Object {
            $ApplicationRuleCollectionGroup = New-Object System.Collections.ArrayList
            $CurrentRuleCollectionName = $_.Name
            $Priority = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Priority
            $Action = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Action
            $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Rules.Keys | ForEach-Object {
                $RuleName = $_
                $RuleObject = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Rules[$RuleName]
                $Rule = [PSCustomObject]@{
                    'name'            = $RuleName
                    'ruleType'        = 'ApplicationRule'
                    'sourceAddresses' = $RuleObject.sourceAddresses
                    'Protocols'       = $RuleObject.Protocols
                    'terminateTLS'    = $RuleObject.terminateTLS
                    'fqdnTags'        = $RuleObject.fqdnTags
                    'webCategories'   = $RuleObject.webCategories
                    'targetFqdns'     = $RuleObject.targetFqdns
                    'targetUrls'      = $RuleObject.targetUrls
                }

                if ($RuleObject.sourceIpGroups -ne $null) {
                    $RuleObject.sourceIpGroups | ForEach-Object {
                        Add-Member -InputObject $Rule -Name 'sourceIpGroups' -Value @($($RuleObject.sourceIpGroups | ForEach-Object {
                            "$_`.id"
                        })) -MemberType NoteProperty
                    }
                } else {
                    Add-Member -InputObject $Rule -Name 'sourceIpGroups' -Value $RuleObject.sourceIpGroups -MemberType NoteProperty
                }

                $ApplicationRuleCollectionGroup.Add($Rule) | Out-Null
            }
            $RuleCollectionGroupCollections.Add(
                @{
                    name                 = $CurrentRuleCollectionName
                    'ruleCollectionType' = 'FirewallPolicyFilterRuleCollection'
                    Priority             = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Priority
                    Action               = @{
                        'type' = $CurrentFile.RuleCollections[$CurrentRuleCollectionName].Action
                    }
                    Rules                = $ApplicationRuleCollectionGroup
        
                }
            ) | Out-Null
        }
    }

    $RuleCollectionGroupArray.add(
        @{
            name                 = $RuleCollectionGroupName
            Properties = @{
                Priority = $RuleCollectionGroupPriority
                RuleCollections = $RuleCollectionGroupCollections
            }
        }
    ) | Out-Null

}

$RuleJson = $RuleCollectionGroupArray | ConvertTo-Json -Depth 100
$RuleBicep = $RuleJson -replace '"',"'" -replace ',','' -replace "'ipgproduction.id'",'ipgproduction.id' -replace "'ipgtest.id'",'ipgtest.id' -replace "'ipgdomaincontroller.id'",'ipgdomaincontroller.id' -replace "'ipgadfs.id'",'ipgadfs.id' -replace "'ipgsandbox.id'",'ipgsandbox.id'

$MainBicep = Get-content .\main.bicep
$MainBicep = $MainBicep.replace($($MainBicep | Select-String "var rulecollectiongroup = ['placeholder']" -SimpleMatch),"var rulecollectiongroup = $RuleBicep")
$MainBicep | Out-File .\main.bicep

Write-verbose "Downloading the latest stable version of bicep.." -Verbose

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

Write-verbose "Creating a JSON of the bicep file that can be used by open source tools and validate it's syntax." -Verbose
bicep build .\main.bicep
bicep build .\modules\resourceLock.bicep