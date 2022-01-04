$PersonalToken = 'Super secret token fetched at https://developer.microsoft.com/en-us/graph/graph-explorer'

$Roledefinitions = Get-AzRoleDefinition | Where-Object {
    $_.Name -in @('Bluestep Contributor', 'Owner', 'Reader')
}

$customProddefinition = Get-content .\customProdDefinition.json

$customdefinition = Get-content .\customDefinition.json 

$Header = @{
    Authorization = "Bearer $PersonalToken"
}

# Get all the subscriptions managed with PIM
$PostSplat = @{
    # ContentType = 'application/x-www-form-urlencoded'
    Method  = 'GET'
    # Uri = "https://graph.microsoft.com/beta/privilegedAccess/azureResources/roleSettings/9c1f72c2-f361-47ef-9e84-385945de7c43"
    uri     = 'https://graph.microsoft.com/beta/privilegedAccess/azureResources/resources?$filter=type eq ''subscription'''
    Headers = $Header
}

$Subscriptions = (Invoke-RestMethod @PostSplat).value

$Subscriptions | Where-Object { $_.displayName -notlike 'AZ-*' } | ForEach-Object {
    if ($_.DisplayName -like '*Production') {
        $RoleDefinition = $customProddefinition
    }
    else {
        $RoleDefinition = $customdefinition
    }
    $SubId = $_.id
    $SubName = $_.displayName

    # Get all the role settings for our three roles, owner, reader & bluestep contributor
    $PostSplat = @{
        ContentType = 'application/json'
        Method      = 'GET'
        # Uri = "https://graph.microsoft.com/beta/privilegedAccess/azureResources/roleSettings/9c1f72c2-f361-47ef-9e84-385945de7c43"
        uri         = "https://graph.microsoft.com/beta/privilegedAccess/azureResources/resources/$subid/roleSettings"
        Headers     = $Header
    }

    $Roles = (Invoke-RestMethod @PostSplat).Value
    
    $Roles | Where-Object {
        $_.roleDefinitionId -in $Roledefinitions.id
    } | Foreach-object {
        $RoleId = $_.Id
        $RoleDefId = $_.roleDefinitionId
        Write-Verbose "Updating the role $($RoleDefinitions | Where-object {$_.Id -eq $RoleDefId} | Select-object -ExpandProperty Name) in the subscription: $SubName" -Verbose
        #Here we loop the roles in the subscription and update them accordingly
        $PostSplat = @{
            ContentType = 'application/json'
            Method      = 'PATCH'
            Body        = $RoleDefinition | ConvertFrom-json -depth 100 | ConvertTo-Json -depth 100
            uri         = "https://graph.microsoft.com/beta/privilegedAccess/azureResources/roleSettings/$RoleId"
            Headers     = $Header
        }

        Invoke-RestMethod @PostSplat

    }
}

## Create role assignments for each AD group with correct role

$Subscriptions | Where-Object { $_.displayName -notlike 'AZ-*'} | ForEach-Object {
    $Sub = $_
    #Here we loop the roles in the subscription and update them accordingly
    $Roledefinitions | Foreach-object {
        $AADGroup = 'AZ_Sub_{0}_{1}' -f ($sub.externalId.split('/')[-1]), ($_.Name).replace(' ', '')
        $Subject = Get-AzAdGroup -DisplayName $AADGroup
        
        switch -wildcard ($Sub.displayName) {
            '*_Production' {
                $Environment = 'production'
            }
            '*_Test' {
                $Environment = 'test'
            }
            '*_Sandbox' {
                $Environment = 'sandbox'
            }
        }
        Write-verbose "Updating assignment for group $($Subject.DisplayName) as role: $($_.Name) on scope: $($Sub.DisplayName), Subid: $($Sub.ExternalId)" -verbose
        $PostSplat = @{
            ContentType = 'application/json'
            Method      = 'POST'
            Body        = $(
                [PSCustomObject]@{
                    resourceId       = $Sub.id
                    roleDefinitionId = $_.Id
                    subjectId        = $Subject.Id
                    assignmentState  = $(if ($_.Name -eq 'Reader' -or ($_.Name -eq 'Bluestep Contributor' -and $Environment -ne 'production')) { 'Active' } else { 'Eligible' })
                    type             = 'AdminAdd'
                    reason           = 'Automated assignment'
                    schedule         = [PSCustomObject]@{
                        startDateTime = "2021-03-22T23:37:43.356Z"
                        endDateTime   = $null
                        type          = 'Once'
                    }
                } | ConvertTo-Json -depth 100
            )
            uri         = "https://graph.microsoft.com/beta/privilegedAccess/azureResources/roleAssignmentRequests"
            Headers     = $Header
        }
    
        Invoke-RestMethod @PostSplat
    }

}