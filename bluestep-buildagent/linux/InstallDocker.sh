sudo apt-get update
sudo apt-get install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --batch

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-cache madison docker-ce

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo apt install liblttng-ust-ctl4 liblttng-ust0 liburcu6 nodejs omi unzip zip libgit2-dev -y

sudo docker run hello-world