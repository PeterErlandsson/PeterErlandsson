Write-Verbose "Downloading the latest version of ARM-TTK from github, please wait.." -Verbose

Git clone https://github.com/Azure/arm-ttk.git "$env:TMP\git"

Import-Module "$env:TMP\git\arm-ttk\arm-ttk.psm1" -ErrorAction Stop

Test-AzTemplate -TemplatePath "$($PWD.Path)\artifact-assignment.json" -skip @('IDs-Should-Be-Derived-From-ResourceIDs')