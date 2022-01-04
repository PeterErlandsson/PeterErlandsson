Param(
    $Path = $PWD.Path,
    $OutputPath = $PWD.Path
)

$PolicyDefinitionFiles = Get-ChildItem -Path "$Path\PolicyDefinitions" -Filter '*.json'

$PolicyDefinitions = @{
    policyDefinitions = @(
        foreach ($File in $PolicyDefinitionFiles) {
            $PropertiesJson = Get-Content -Path $File.FullName
            # Escape all functions
            $PropertiesJson = $PropertiesJson -replace '"\[', '"[['
            $Properties = $PropertiesJson | ConvertFrom-Json -Depth 100
            @{
                Name       = $File.BaseName
                Properties = $Properties
            }
        }
    )
}

$InitiativeDefinitionFiles = Get-ChildItem -Path "$Path\InitiativeDefinitions" -Filter "*.json"
$InitiativeDefinitions = @{
    policySetDefinitions = @(
        foreach ($File in $InitiativeDefinitionFiles) {
            $PropertiesJson = Get-Content -Path $File.FullName
            # Escape all functions
            $PropertiesJson = $PropertiesJson -replace '"\[', '"[['
            $Properties = $PropertiesJson | ConvertFrom-Json -Depth 100
            foreach($Policy in $Properties.PolicyDefinitions) {
                $Policy.policyDefinitionId = "[concat(variables('scope'), '/providers/Microsoft.Authorization/policyDefinitions/$($Policy.policyDefinitionId)')]"
            }
            @{
                Name       = $File.BaseName
                Properties = $Properties
            }
        }
    )
}

$Template = Get-Content "$Path\Scripts\InitiativeDeploymentTemplateTemplate.json" | ConvertFrom-Json -Depth 100

$Template.Variables.policies = $PolicyDefinitions
$Template.Variables.initiatives = $InitiativeDefinitions

$Template | ConvertTo-Json -Depth 100 | Out-File "$OutputPath\artifact-policies.json"

