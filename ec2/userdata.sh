#!/bin/bash 
sudo apt update -y && sudo apt upgrade -y 

# Install required packages 
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add Docker's official GPG key
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker 
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

 sudo usermod -aG docker ubuntu && newgrp docker 
 # Installing UNZIP 
 sudo apt install unzip -y 
 # Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install 
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# docker pull furkhan2000/shark:091cd86-vulnmain 
 #docker run -d -p 3000:3000 --restart always furkhan2000/shark:091cd86-vulnmain  

 # installing helm 
 curl -LO https://get.helm.sh/helm-v3.18.4-linux-amd64.tar.gz
 tar -zxvf helm-v3.18.4-linux-amd64.tar.gz
 sudo mv linux-amd64/helm /usr/local/bin/helm 
 
 helm repo add bitnami https://charts.bitnami.com/bitnami 
 #helm repo add artifacthub https://artifacthub.github.io/helm-charts          
 helm repo update   

 helm install opera bitnami/argo-cd 