# aks-keycloak

Terraform code
   aks
   keyvault
   azure-sql database
   

Helm charts
   keycloak
   ingress
   sampleapp

Azure Devops Pipelines
   pipelines include:
      build docker containers 
      Package helm charts
      Deploy application

Sample Application
   Sample application deployed as a helm chart and using Azure AD Workload Identity to access application specific key vaults.  User authentication is handled through external keycloak IDP.
   Dockerfile

Keycloak
--------

We are simulating an IDP that is external to the AKS cluster.  This will have a simple setup in a VM that has docker installed and is brought up with docker compose and is accesses through a public ip with a TLS certificate.

Development Environment Installation
------------------------------------

Installation is into windows machine running wsl that can be used to a local kubernetes and also provision the infrastructure in AKS.

WSL
Enabe WSL v2

Ubuntu for windows
Install ubuntu for windows from the microsoft app store v22

Docker
Install Docker Desktop for windows
Open an ubuntu shell and verify that docker is also working in wsl
docker ps

Helm

wget https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz
tar -xvf  helm-v3.12.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
helm version

Terraform client
cd /tmp
sudo apt-get update 
sudo apt-get upgrade 
sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_darwin_amd64.zip
unzip terraform_1.5.3_darwin_amd64.zip
sudo mv terraform /usr/local/bin

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
