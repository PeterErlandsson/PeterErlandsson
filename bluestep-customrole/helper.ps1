Login-AzAccount

Select-AzSubscription  -SubscriptionId '9d957d40-b4aa-47b6-83ec-2f5bc899a938' | Set-AzContext -ErrorAction Stop
$Roles = @('BluestepContributor','Reader','Owner')

$Subscriptions = Get-AzSubscription | Where-object { $_.SubscriptionPolicies[0].QuotaId -ne "MSDN_2014-09-01" }
$ManagementGroups = Get-AzManagementGroup -GroupName 'Bluestep' -Recurse -Expand
$MGNames = @($ManagementGroups.Name) + $($ManagementGroups.Children.DisplayName -replace ' ', '_')

$ProdSubs = $Subscriptions | Where-Object {$_.Name -like '*Production'}
$TestDevSubs = $Subscriptions | Where-Object {$_.Name -like '*Test'}
$SandboxSubs = $Subscriptions | Where-Object {$_.Name -like '*Sandbox'}
# Add production CSP subscriptions
$Subscriptions | Where-Object {
    $_.Name -like '*_Production' -and $_.SubscriptionPolicies.QuotaId -like 'CSP*'
} | ForEach-Object {
    New-AzManagementGroupSubscription -GroupId 'BluestepProd' -SubscriptionId $_.Id
}

# Add production non CSP subscriptions
$Subscriptions | Where-Object {
    $_.Name -like 'Az-Prod*'
} | ForEach-Object {
    New-AzManagementGroupSubscription -GroupId 'BluestepProd' -SubscriptionId $_.Id
}

# Add Test subscriptions
$Subscriptions | Where-Object {
    $_.Name -like '*_Test'
} | ForEach-Object {
    New-AzManagementGroupSubscription -GroupId 'BluestepTest' -SubscriptionId $_.Id
}

# Add Sandbox subscriptions
$Subscriptions | Where-Object {
    $_.Name -like '*_Sandbox'
} | ForEach-Object {
    New-AzManagementGroupSubscription -GroupId 'BluestepSandbox' -SubscriptionId $_.Id
}


$Subscriptions.Id + $MGNames | ForEach-Object -begin {
    $AdGroupList = New-object System.Collections.ArrayList
} -Process {
    $CurrentObject = $_

    try {
        [guid]::Parse($CurrentObject) | Out-null
        $IsManagementGroup = $False
    }
    catch {
        $IsManagementGroup = $True
    }

    $Roles | Foreach-object {

        $CurrentRole = $_

        switch ($IsManagementGroup) {
            $true {
                if ($CurrentObject -eq 'Bluestep') {
                    $AdGroupName = 'AZ_MG_{0}_Root_{1}' -f $CurrentObject, $CurrentRole
                } else {
                    $AdGroupName = 'AZ_MG_{0}_{1}' -f $CurrentObject, $CurrentRole
                }
            }
            $false {
                $AdGroupName = 'AZ_Sub_{0}_{1}' -f $CurrentObject, $CurrentRole
            }
        }

        $AdGroup = (Get-AzADGroup -DisplayName $AdGroupName)

        if (!$AdGroup) {
            Write-warning "Cannot find the ad group $AdGroupName, will create it."
            $params = @{
                DisplayName  = $AdGroupName
                MailNickname = $AdGroupName
                Description  = "Gives access to {0} as $CurrentRole" -f $CurrentObject
            }
            $AdGroup = New-AzADGroup @params
            $AdGroupList.Add($AdGroup) | Out-null
        }
        else {
            Write-verbose "Found the AD group: $AdGroupName" -verbose
            $AdGroupList.Add($AdGroup) | Out-null
        }
    }
}

$Bicep = Get-content -path .\templateMain.bicep 

$Placeholder = $Bicep | Select-String 'Placeholder'
$Bicep -replace $Placeholder, "$($Subscriptions.id | Foreach-object {
    "'/subscriptions/{0}'`n" -f $_
})" | Set-content .\main.bicep

New-AzSubscriptionDeployment -Name 'BluestepContributorDeploy' -Location 'West Europe' -TemplateFile .\main.bicep

# Add each AZ AD group that should give on management group level, access to the subscriptions in the management group.
# This cannot be done yet using the ARM api.
$ManagementGroups.Children | ForEach-Object -Process {
    $CurrentMGName = $_.DisplayName

    $_.Children | ForEach-Object {
        Add-AzADGroupMember -MemberObjectId (Get-AzAdGroup -DisplayName ("AZ_MG_{0}_Reader" -f $($CurrentMGName -replace ' ','_'))).Id -TargetGroupDisplayName ("AZ_Sub_{0}_Reader" -f $($_.Name -replace ' ','_'))
        Add-AzADGroupMember -MemberObjectId (Get-AzAdGroup -DisplayName ("AZ_MG_{0}_Owner" -f $($CurrentMGName -replace ' ','_'))).Id -TargetGroupDisplayName ("AZ_Sub_{0}_Owner" -f $($_.Name -replace ' ','_'))
        Add-AzADGroupMember -MemberObjectId (Get-AzAdGroup -DisplayName ("AZ_MG_{0}_BluestepContributor" -f $($CurrentMGName -replace ' ','_'))).Id -TargetGroupDisplayName ("AZ_Sub_{0}_BluestepContributor" -f $($_.Name -replace ' ','_'))
    }
}

# Deploy role assignments to each subscription / Management group
# $ReaderGroups = Get-AzADGroup -DisplayNameStartsWith 'AZ_Sub_' | Where-Object {$_.DisplayName -like '*_Reader'}
# $OwnerGroups = Get-AzADGroup -DisplayNameStartsWith 'AZ_Sub_' | Where-Object {$_.DisplayName -like '*_Owner'}
# $BluestepContributorGroups = Get-AzADGroup -DisplayNameStartsWith 'AZ_Sub_' | Where-Object {$_.DisplayName -like '*_BluestepContributor'}
