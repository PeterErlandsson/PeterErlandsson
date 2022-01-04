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
Get-ChildItem -Filter '*.bicep' | ForEach-Object {
    try {
        bicep build $_.name
    } catch {
        'FAIL'
        throw
    }
}