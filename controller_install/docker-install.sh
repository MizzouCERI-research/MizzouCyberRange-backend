# Install docker
# sudo apt-get update
# sudo apt-get install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo apt-key fingerprint 0EBFCD88
# sudo add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) \
#    stable"
# sudo apt-get update
# sudo apt-get install -y docker-ce
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# Give $USER permission to run docker commands without sudo
sudo usermod -aG docker $USER
