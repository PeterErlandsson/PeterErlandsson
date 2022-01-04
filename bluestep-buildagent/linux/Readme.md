# Requirements for Linux Build machines

## Software

### Installed as part of build
- liblttng-ust-ctl4
- liblttng-ust0
- liburcu6
- libgit2-dev
- nodejs
- omi
- unzip
- zip

### Not simply installable without adding remote repository:
- aspnetcore-runtime-2.1
- aspnetcore-runtime-3.1
- containerd.io
- docker-ce
- docker-ce-cli
- docker-cimprov
- dotnet-apphost-pack-5.0
- dotnet-host
- dotnet-hostfxr-2.1
- dotnet-hostfxr-5.0
- dotnet-runtime-2.1
- dotnet-runtime-5.0
- dotnet-runtime-deps-2.1
- dotnet-runtime-deps-5.0
- dotnet-sdk-2.1
- dotnet-sdk-3.1
- dotnet-sdk-5.0
- Kubectl
- Az cli

## Notes
### Install command for all applications not requiring remote repo to be added:
```
sudo apt install liblttng-ust-ctl4 liblttng-ust0 liburcu6 nodejs omi unzip zip
```

### aspnetcore runtime
Installing with APT can be done with a few commands. Before you install .NET, run the following commands to add the Microsoft package signing key to your list of trusted keys and add the package repository.

Open a terminal and run the following commands:
```
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
```
Install the SDK
The .NET SDK allows you to develop apps with .NET. If you install the .NET SDK, you don't need to install the corresponding runtime. To install the .NET SDK, run the following commands:
```
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0
```
Install the runtime
The ASP.NET Core Runtime allows you to run apps that were made with .NET that didn't provide the runtime. The following commands install the ASP.NET Core Runtime, which is the most compatible runtime for .NET. In your terminal, run the following commands:
```
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-5.0
```
Source:
https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#1804-

### Docker Engine (docker-ce)
Before you install Docker Engine for the first time on a new host machine, you need to set up the Docker repository. Afterward, you can install and update Docker from the repository.

Set up the repository
Update the apt package index and install packages to allow apt to use a repository over HTTPS:

```
 sudo apt-get update
 sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
Add Docker’s official GPG key:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
Use the following command to set up the stable repository. To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below:
```
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:
```
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
```
To install a specific version of Docker Engine, list the available versions in the repo, then select and install:

a. List the versions available in your repo:
```
apt-cache madison docker-ce
```
Install a specific version using the version string from the second column, for example, 5:18.09.1~3-0~ubuntu-xenial.
#### Note - Old build machine had version 5:19.03.8~3-0
```
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
```
#### Installed 20.10.8 - command: sudo apt-get install docker-ce=5:20.10.8~3-0~ubuntu-bionic docker-ce-cli=5:20.10.8~3-0~ubuntu-bionic containerd.io
Verify that Docker Engine is installed correctly by running the hello-world image.
```
sudo docker run hello-world
```

Source:
https://docs.docker.com/engine/install/ubuntu/


### Available Docker versions on ubuntu focal
 docker-ce | 5:20.10.8~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.7~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.6~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.5~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.4~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.3~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.2~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.1~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.0~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.15~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.14~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.13~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.12~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.11~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.10~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.9~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages