# aks-keycloak

Directory structure:

Terraform code:<br/>
   aks<br/> 
   keyvault<br/>
   azure-sql database<br/>
   

Helm charts:
   keycloak<br/>
   ingress<br/>
   sampleapp<br/>

Azure Devops Pipelines
   pipelines include:<br/>
      build docker containers<br/>
      Package helm charts<br/>
      Deploy application<br/>

Sample Application<br/>
   Sample application deployed as a helm chart and using Azure AD Workload Identity to access application specific key vaults.  User authentication is handled through external keycloak IDP.<br/>
   Dockerfile<br/>

Keycloak
--------

We are simulating an IDP that is external to the AKS cluster.  This will have a simple setup in a VM that has docker installed and is brought up with docker compose and is accesses through a public ip with a TLS certificate.

AKS Development
---------------

Install the binaries from Development Environment Installation below

cd terraform
terraform init
terraform plan
terraform apply

This is creating the Vnet, Subnet, AKS cluster, ACR

AKS Cluster is using a system defined managed identity to connect to ACR

az aks get-credentials --resource-group perfect-grouper-rg --name perfect-grouper-aks
Merged "perfect-grouper-aks" as current context in /home/mshamber/.kube/config

Install the nginx ingress
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
  --namespace ingress-nginx --create-namespace

See that the public ip is created
kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller

Add FQDN and test
run scripts/fqdn.sh after updating the new public ip address
https://keycloak-aks-oauth-demo.eastus.cloudapp.azure.com


https://cert-manager.io/docs/tutorials/getting-started-aks-letsencrypt/
Add cert manager to get letsencrypt certificate
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade cert-manager jetstack/cert-manager \
    --install \
    --create-namespace \
    --wait \
    --namespace cert-manager \
    --set installCRDs=true


Development Environment Installation
------------------------------------

Installation is into windows machine running Windows Subsystem for Linux (wsl) that can be used to a local kubernetes and also provision the infrastructure in AKS.

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
wget https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_amd64.zip
unzip terraform_1.5.3_amd64.zip
sudo mv terraform /usr/local/bin

Azure client

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

Kubernetes client

cd /tmp
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo cp kubectl /usr/local/bin
