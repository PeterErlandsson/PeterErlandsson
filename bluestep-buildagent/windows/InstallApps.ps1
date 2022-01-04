$path = (pwd).path
$wc = New-Object net.webclient

$MavenVersion = '3.8.3'

Write-verbose "Downloading Anaconda.." -verbose
$wc.Downloadfile('https://repo.anaconda.com/archive/Anaconda3-2021.05-Windows-x86_64.exe',"$path\Anaconda.exe")
Write-verbose "AZ Cli" -verbose
$wc.DownloadFile('https://aka.ms/installazurecliwindows',"$path\AzureCLI.msi")
Write-verbose "Maven $MavenVersion" -verbose
$wc.DownloadFile("https://ftpmirror1.infania.net/mirror/apache/maven/maven-3/$MavenVersion/binaries/apache-maven-$MavenVersion-bin.zip","$path\apache-maven.zip")
Write-verbose "Nodejs 14.17.5" -verbose
$wc.DownloadFile('https://nodejs.org/dist/v14.17.5/node-v14.17.5-x64.msi',"$path\nodejs.msi")
Write-verbose "RClient" -verbose
$wc.DownloadFile('https://aka.ms/rclient/',"$path\RClientSetup.exe")
Write-verbose ".net SDK 3.1" -verbose
$wc.Downloadfile('https://download.visualstudio.microsoft.com/download/pr/046165a4-10d4-4156-8e65-1d7b2cbd304e/a4c7b01f6bf7199669a45ab6a03803ac/dotnet-sdk-3.1.412-win-x64.exe',"$path\dotnet-sdk-3.1.412-win-x64.exe")
Write-verbose ".net SDK 5.0" -verbose
$wc.DownloadFile('https://download.visualstudio.microsoft.com/download/pr/c1bfbb13-ad09-459c-99aa-8971582af86e/61553270dd9348d7ba29bacfbb4da7bd/dotnet-sdk-5.0.400-win-x64.exe',"$path\dotnet-sdk-5.0.400-win-x64.exe")
Write-verbose ".net Framework 4.8" -verbose
$wc.DownloadFile('https://go.microsoft.com/fwlink/?linkid=2088517',"$path\dotnet-4.8.exe")
Write-verbose "Kubectl" -verbose
$wc.DownloadFile('https://dl.k8s.io/release/v1.22.0/bin/windows/amd64/kubectl.exe',"$path\kubectl.exe")

mkdir "$env:programFiles\kubectl"
Copy-item $path\kubectl.exe -Destination "$env:programFiles\kubectl\kubectl.exe" -Force
Expand-Archive -Path .\apache-maven.zip -DestinationPath 'C:\' -Force
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
Start-Process msiexec.exe -Wait -ArgumentList '/I nodejs.msi /quiet'
Start-Process .\Anaconda.exe -Wait -ArgumentList '/InstallationType=AllUsers /AddToPath=1 /S'
Start-Process .\RClientSetup.exe -Wait -ArgumentList '/quiet'
Start-Process .\dotnet-sdk-3.1.412-win-x64.exe -wait -ArgumentList '/install /quiet /norestart'
Start-Process .\dotnet-sdk-5.0.400-win-x64.exe -wait -ArgumentList '/install /quiet /norestart'
Start-Process .\dotnet-4.8.exe -wait -ArgumentList '/install /quiet /norestart'
Invoke-restmethod https://aka.ms/install-powershell.ps1 -outfile Install-pwsh.ps1
.\Install-pwsh.ps1 -Quiet -UseMSI

[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\program files\kubectl;C:\apache-maven-$MavenVersion\bin;C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin;C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;C:\Program Files\PowerShell\7;", [System.EnvironmentVariableTarget]::Machine)

rm "C:\Windows\Panther" -Force -Confirm:$false -Recurse