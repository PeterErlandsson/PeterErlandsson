$Policies = Get-AzPolicyDefinition -Builtin | Where-Object {$_.Properties.DisplayName -like '*Diagnostic Settings*to Log Analytics workspace*'}

$Policies | % {
    $Name = ($_.Properties.DisplayName).Replace('Deploy','').Replace('Configure','').Replace(' to Log Analytics workspace','').replace(' ','').Replace('-','').Replace('diagnosticsettings','').Replace('DiagnosticSettings','')
    $Info = [PSCustomObject]@{
        Description = $_.Properties.Description
        DisplayName = "Bluestep - $(($_.Properties.DisplayName).Replace('Deploy','').Replace('-','').Trim())"
        Mode = $_.Properties.Mode
        Parameters = $_.Properties.Parameters
        PolicyRule = $_.Properties.PolicyRule
        MetaData = $_.Properties.Metadata
    }
    New-Item -Path .\PolicyDefinitions -Name "bluestep-DiagnosticSettings$Name.json" -Value $($Info | ConvertTo-Json -Depth 100).replace('\u0027',"'")
}