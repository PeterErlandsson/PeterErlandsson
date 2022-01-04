Param(
    $Path = $PWD.Path,
    $OutputPath = $PWD.Path
)

$PolicyAssignmentFiles = Get-ChildItem -Path "$Path\PolicyAssignments" -Filter "*.json"

$PolicyAssignmentDeployments = foreach ($File in $PolicyAssignmentFiles) {
    $PropertiesJson = Get-Content -Path $File.FullName
    # Escape all functions
    $PropertiesJson = $PropertiesJson -replace '"\[', '"[['
    $Properties = $PropertiesJson | ConvertFrom-Json -Depth 10
    foreach ($Assignment in $Properties.PolicyAssignments) {
        $Assignment.properties.policyDefinitionId = "$($Assignment.properties.policyDefinitionId)"
    }
    $Template = Get-Content "$Path\Scripts\AssignmentDeploymentTemplateTemplate.json" | ConvertFrom-Json -Depth 100
    $Template.Variables = @{
            Name       = $File.BaseName
            PolicyAssignments = $Properties.PolicyAssignments
        }
    $Template | ConvertTo-Json -Depth 100
}


$Template = Get-Content "$Path\Scripts\TenantDeploymentTemplate.json" | ConvertFrom-Json -Depth 100
$Template.variables = @{'Deployments' = @(foreach ($Deployment in $PolicyAssignmentDeployments) {
            @{
                mgName             = ($Deployment | convertfrom-json -Depth 100).variables.name
                deploymentTemplate = $( $Deployment = $Deployment -replace '"\[','"[['
                $Deployment | ConvertFrom-Json -Depth 100)

            }
        })
    }
$Template | ConvertTo-Json -Depth 100 | Out-File $OutputPath\artifact-assignment.json