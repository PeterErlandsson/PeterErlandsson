Git clone https://github.com/Azure/arm-ttk.git "$env:TMP\git"

Import-Module "$env:TMP\git\arm-ttk\arm-ttk.psm1" -ErrorAction Stop

Test-AzTemplate -TemplatePath "$($PWD.Path)\artifact-policies.json" -skip @('DeploymentTemplate-Must-Not-Contain-Hardcoded-Uri', 'IDs-Should-Be-Derived-From-ResourceIDs', 'ResourceIds-should-not-contain', 'Template-Should-Not-Contain-Blanks','apiVersions-Should-Be-Recent-In-Reference-Functions','apiVersions-Should-Be-Recent')