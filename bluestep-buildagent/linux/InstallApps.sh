wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0 dotnet-sdk-2.1 dotnet-sdk-3.1

sudo apt-get update; \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y aspnetcore-runtime-5.0 aspnetcore-runtime-2.1 aspnetcore-runtime-3.1

sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo apt-get update && sudo apt upgrade -y
curl -fsSL https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_placeholderDocker~3-0~ubuntu-focal_amd64.deb -o docker-ce-cli.deb
curl -fsSL https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_placeholderDocker~3-0~ubuntu-focal_amd64.deb -o docker-ce.deb
curl -fsSL https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_placeholderContainerd_amd64.deb -o containerd.deb
curl -LO placeholderKubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo apt install liblttng-ust-ctl4 liblttng-ust0 liburcu6 nodejs npm unzip zip libgit2-dev -y
sudo dotnet tool install --global GitVersion.Tool
sudo dpkg -i containerd.deb
sudo dpkg -i docker-ce-cli.deb
sudo dpkg -i docker-ce.deb
sudo chmod 666 /var/run/docker.sock
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell