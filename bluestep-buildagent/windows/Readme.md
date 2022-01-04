# Requirements for Windows Build machines

## Software

### Installed as part of build
- .Net Framework 4.7.2 SDK (or newer?)
- https://go.microsoft.com/fwlink/?linkid=2088517
- .Net SDK 5.0 (x64)
_https://dotnet.microsoft.com/download - version 3.1_
_https://dotnet.microsoft.com/download/dotnet-framework/net48 - Version 4.8_

- Node js - 11.12.0
_https://nodejs.org/en/download/ - 14.17.5_

- Apache Maven 3.6.1 (or newer)
_https://maven.apache.org/download.cgi - Version 3.8.2_

- Python 3.6.5 (or newer - Anaconda3 5.2.0 64-bit)
_https://docs.anaconda.com/anaconda/install/windows/_

- Java Development kit (64-bit) 12.0.1
_https://www.oracle.com/java/technologies/javase-jdk16-downloads.html - version 16.0.2_

- Microsoft R Client - 3.3.2.1988
_https://aka.ms/rclient/ - Version 3.5.2_ 

- Microsoft Azure CLI
_https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli_
```
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

```

- Kubectl ($env:programFiles\kubectl\kubectl.exe - Path is also added to system wide Path so can be called from shells.)

- Azure PowerShell 7 Module

- Google Chrome

### Optional? (Not installed)
- Notepad++
- Splunk
- Kaseya (?)

### Installed per default
- Git
- .Net Core SDK (x64) - Version 2.1, 2.2, 3.0, 3.1 (Version 2.1.617 per default)
- Visual Studio Code
- Windows Software Development Kit
- Visual Studio Enterprise 2019


## Notes
Change Java path to:
C:\Program Files\Java\jdk-16.0.2
Change Maven to:
C:\apache-maven-3.8.2\bin

## Network connectivity needed:
10.126.137.250:5672 - k8s internal loadbalancer, used by Bluestep.Service.NO.MLC.DataExporter in loans.