# aks-keycloak

Directory structure:

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


Setting up the sample color application.  First through console and then terraform
Create AD appliction in azure portal
export cookie_secret="$(openssl rand -hex 16)" # Create local variable
az keyvault secret set --vault-name "perfect-grouper-demo-kv" --name "oauth2-proxy-client-id" --value "4c8c2a21-98f4-4482-a7a7-0307fb60ccc1"
az keyvault secret set --vault-name "perfect-grouper-demo-kv" --name "oauth2-proxy-client-secret" --value "2bW8Q~6W4mwxEIY0lLAxyinPZzyGSlHZWwfaRdn7"
az keyvault secret set --vault-name "perfect-grouper-demo-kv" --name "oauth2-proxy-cookie-secret" --value $cookie_secret

Verify the Azure secret store CSI driver is enabled:
az aks addon list –name perfect-grouper-aks  --resource-group perfect-grouper-rg
kubectl get pods -n kube-system -l 'app in (secrets-store-csi-driver,secrets-store-provider-azure)

Query the id of the managed identity in the cluster
az aks show -g perfect-grouper-rg -n perfect-grouper-aks --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -o tsv
c1867a83-acfc-4da7-b021-82be8493bab5

# set policy to access keys in your key vault
az keyvault set-policy -n perfect-grouper-demo-kv --key-permissions get --spn c1867a83-acfc-4da7-b021-82be8493bab5
# set policy to access secrets in your key vault
az keyvault set-policy -n perfect-grouper-demo-kv --secret-permissions get --spn c1867a83-acfc-4da7-b021-82be8493bab5
# set policy to access certs in your key vault
az keyvault set-policy -n perfect-grouper-demo-kv --certificate-permissions get --spn c1867a83-acfc-4da7-b021-82be8493bab5

Add secrets provider
kubectl apply -f SecretProviders.yaml
kubectl apply -f colorswebapi.yaml
kubectl apply -f colorswebapp.yaml

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
