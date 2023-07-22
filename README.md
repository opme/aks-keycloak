# aks-keycloak

Terraform code
   aks
   keyvault
   azure-sql database
   

Helm charts
   keycloak
   ingress
   sampleapp

Dockerfile

Sample Application



Installation
------------

Installation is into windows machine running wsl

Docker
Install Docker Desktop for windows

Helm

wget https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz
tar -xvf  helm-v3.12.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
helm version

Azure client

Install through apt
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupgsudo 
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc gpg --dearmor sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/nullcurl -sLS https://packages.microsoft.com/keys/microsoft.asc gpg --dearmor sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg


Kubernetes client

cd /tmp
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo cp kubectl /usr/local/bin
