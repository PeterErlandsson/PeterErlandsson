[CmdletBinding()]

$DeployFile = Get-Content .\main.json | ConvertFrom-Json
$FWP = $DeployFile.parameters.azureFirewallPolicyName.defaultValue
$IncomingFirewallRules = $DeployFile.variables.rulecollectiongroup
$Subscription = '2887160a-ea77-4845-aba8-644475701efa'
$RG = 'rg-hub-prod-we'
Select-AzSubscription $Subscription
$ProductionFWRules = (Get-AzFirewallPolicy -Name $FWP -ResourceGroupName $RG).RuleCollectionGroups.id | ForEach-Object {
    Get-AzFirewallPolicyRuleCollectionGroup -AzureFirewallPolicyName $FWP -Name $_.Split('/')[-1] -ResourceGroupName $RG
}

$IPG = Get-AzResource -ResourceGroupName $RG -ResourceType 'Microsoft.Network/ipGroups'

$IncomingFirewallRules | ForEach-Object -begin {
    $AllFWRCG = New-object System.Collections.ArrayList
} -Process {
    $RGWrapper = [Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyRuleCollectionGroupWrapper]::new()
    $RGWrapper.Name = $_.Name
    $CurrentRCG = [Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyRuleCollectionGroup]::new()
    $CurrentRCG.Priority = $_.Properties.Priority
    $CurrentRCG.Name = $_.Name
    $CurrentRCG.Id = "/subscriptions/$Subscription/resourcegroups/$RG/providers/Microsoft.Network/firewallPolicies/$FWP/ruleCollectionGroups/{0}" -f $_.Name
    $_.Properties.RuleCollections | ForEach-Object -begin {
        $ListOfRuleCollections = New-object System.Collections.ArrayList
    } -Process {
        $CurrentRC = [Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyFilterRuleCollection]::new()
        $CurrentRC.Priority = $_.Priority
        $CurrentRC.Name = $_.Name
        $CurrentRC.RuleCollectionType = $_.RuleCollectionType
        $CurrentRC.Action = $(
            $RuleAction = New-object Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyFilterRuleCollectionAction
            $RuleAction.Type = $_.Action.Type
            Write-output $RuleAction
        )
        $_.Rules | Sort | ForEach-Object {
            $CurrentRule = $_
            switch ($_.ruleType) {
                'NetworkRule' {
                    $Rule = [Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyNetworkRule]::new()
                    Write-verbose "Processing Network rules.."
                    switch ($CurrentRule) {
                        { $CurrentRule.sourceAddresses } {
                            $Rule.SourceAddresses = $CurrentRule.sourceAddresses
                            $Rule.SourceIpGroups = @()
                        }
                        { $CurrentRule.SourceIpGroups } {
                            $Rule.SourceIpGroups = $CurrentRule.SourceIpGroups | ForEach-Object {
                                $CurrentSourceIpGroupName = $_
                                $($ipg | where-object { $_.Name -eq $($CurrentSourceIpGroupName.split(',')[-1].trimend(')]').trim().trim("'")) } | Select-object -expand ResourceId)
                            }
                            $Rule.SourceAddresses = @()
                        }
                        { $CurrentRule.DestinationAddresses } {
                            $Rule.DestinationAddresses = $CurrentRule.DestinationAddresses
                            $Rule.DestinationIpGroups = @()
                            $Rule.DestinationFqdns = @()
                        }
                        { $CurrentRule.DestinationIpGroups } {
                            $Rule.DestinationIpGroups = $CurrentRule.DestinationIpGroups | Foreach-object {
                                $CurrentDestinationIpGroupName = $_
                                $($ipg | where-object { $_.Name -eq $($CurrentDestinationIpGroupName.split(',')[-1].trimend(')]').trim().trim("'")) } | Select-object -expand ResourceId)
                            }
                            $Rule.DestinationAddresses = @()
                            $Rule.DestinationFqdns = @()
                        }
                        { $CurrentRule.DestinationFqdns } {
                            $Rule.DestinationFqdns = $CurrentRule.DestinationFqdns
                            $Rule.DestinationAddresses = @()
                            $Rule.DestinationIpGroups = @()
                        }
                    }
                    $Rule.DestinationPorts = $CurrentRule.DestinationPorts
                    $Rule.Name = $CurrentRule.Name
                    $Rule.RuleType = $CurrentRule.RuleType
                    $Rule.protocols = $CurrentRule.ipProtocols
                }
                'ApplicationRule' {
                    $Rule = [Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyApplicationRule]::new()
                    Write-verbose "Processing Application rules.."
                    switch ($CurrentRule) {
                        { $CurrentRule.sourceAddresses } {
                            $Rule.SourceAddresses = $CurrentRule.sourceAddresses
                            $Rule.SourceIpGroups = @()
                        }
                        { $CurrentRule.SourceIpGroups } {
                            $Rule.SourceIpGroups = $(
                                $CurrentRule.SourceIpGroups | ForEach-Object {
                                    $CurrentSourceIpGroupName = $_
                                    $($ipg | where-object { $_.Name -eq $($CurrentSourceIpGroupName.split(',')[-1].trimend(')]').trim().trim("'")) } | Select-object -expand ResourceId)
                                })
                            $Rule.SourceAddresses = @()
                        }
                        { $CurrentRule.TargetFqdns } {
                            $Rule.TargetFqdns = $CurrentRule.TargetFqdns
                            $Rule.TargetUrls = @()
                            $Rule.WebCategories = @()
                            $Rule.FqdnTags = @()
                        }
                        { $CurrentRule.TargetUrls } {
                            $Rule.TargetUrls = $CurrentRule.TargetUrls
                            $Rule.TargetFqdns = @()
                            $Rule.WebCategories = @()
                            $Rule.FqdnTags = @()
                        }
                        { $CurrentRule.WebCategories } {
                            $Rule.WebCategories = $CurrentRule.WebCategories
                            $Rule.TargetFqdns = @()
                            $Rule.TargetUrls = @()
                            $Rule.FqdnTags = @()
                        }
                        { $CurrentRule.FqdnTags } {
                            $Rule.FqdnTags = $CurrentRule.FqdnTags
                            $Rule.WebCategories = @()
                            $Rule.TargetFqdns = @()
                            $Rule.TargetUrls = @()
                        }
                    }
                    $Rule.Protocols = $CurrentRule.Protocols | ForEach-Object {
                        $ProtocolObject = [Microsoft.Azure.Commands.Network.Models.PSAzureFirewallPolicyApplicationRuleProtocol]::new()
                        $ProtocolObject.Port = $_.Port
                        $ProtocolObject.ProtocolType = $_.ProtocolType
                        $ProtocolObject
                    }
                    $Rule.TerminateTLS = $CurrentRule.TerminateTLS
                    $Rule.Name = $CurrentRule.Name
                    $Rule.RuleType = $CurrentRule.RuleType
                }
            }
            $CurrentRC.Rules += $Rule
        }
        $CurrentRCG.RuleCollection += $CurrentRC
    }
    $RGWrapper.Properties += $CurrentRCG
    $AllFWRCG.add($RGWrapper) | Out-null
}

$AllFWRCG  | ForEach-Object {
    $IncomingChangeObject = $_
    $ProductionObject = $ProductionFWRules | Where-object { $_.Name -eq $IncomingChangeObject.Name }
    if ($ProductionObject) {
        Write-verbose "Processing rule collection group $($_.Name)" -verbose
        # Compare-Object $IncomingChangeObject.Properties -DifferenceObject $ProductionObject.Properties
        if ($ProductionObject.Properties.RuleCollection) {
            $RuleCollection = $ProductionObject.Properties.RuleCollection
            $IncomingChangeObject.Properties.RuleCollection.Rules | ForEach-Object {
                if ($_.Name -notin @($RuleCollection.Rules.Name)) {
                    Write-warning "CREATE: This rule is not in production today, RCG: $($IncomingChangeObject.Name)"
                    $_ | Select Name, *Text
                }
            }
            $RuleCollection.Rules | ForEach-Object {
                if ($_.Name -notin @($IncomingChangeObject.Properties.RuleCollection.Rules.Name)) {
                    Write-warning "REMOVE: This rule will be removed, RCG: $($IncomingChangeObject.Name)"
                    $_ | Select Name, *Text
                }
            }
            # Compare-Object $($IncomingChangeObject.Properties.RuleCollection | Select-object * -ExcludeProperty 'RulesText') -DifferenceObject $($ProductionObject.Properties.RuleCollection | Select-object * -ExcludeProperty 'RulesText')
            # Compare-Object $($ProductionObject.Properties.RuleCollection.Rules) -DifferenceObject $($IncomingChangeObject.Properties.RuleCollection.Rules)
            $IncomingChangeObject.Properties.RuleCollection.Rules | ForEach-Object {
                $RuleName = $_.Name
                Write-Verbose "Processing rule $RuleName in RCG: $($IncomingChangeObject.Name)" -Verbose
                $ProdObject = $($ProductionObject.Properties.RuleCollection.Rules | Where-object { $_.Name -eq $RuleName })
                if ($ProdObject) {
                    $result = Compare-Object -ReferenceObject $_ -DifferenceObject $ProdObject -Property SourceIpGroups, DestinationIpGroups, DestinationPortsText, protocolsText, SourceAddresses, DestinationAddresses, DestinationFqdns, Name, RuleType, TargetFqdnsText, FqdnTagsText, WebCategoriesText, TargetUrlsText, TerminateTLS
                    if ($result) {
                        Write-verbose "CHANGE: Found a change on the rule '$RuleName' in the Rule Collection Group '$($IncomingChangeObject.Name)'" -Verbose
                        Write-Verbose "=> indicates current production object. <= indicates incoming changes." -Verbose
                        $result
                    }
                }
            }
        }
        else {
            if ($IncomingChangeObject.Properties.RuleCollection) {
                Write-warning "CREATE: $($_.Name) does not contain any rule collections today. Will add all the following changes:`nNew Rule collection:"
                $IncomingChangeObject.Properties.RuleCollection | Select-object * -ExcludeProperty 'RulesText'
                Write-warning "CREATE: New rules in the rule collection:"
                $IncomingChangeObject.Properties.RuleCollection.Rules
            }
            else {
                Write-verbose "INFO: There's no configured rules or rule collections for $($IncomingChangeObject.Name)" -verbose
            }

        }
    }
    else {
        Write-warning "INFO: Unable to find $($_.Name) in production!" -verbose
    }
}