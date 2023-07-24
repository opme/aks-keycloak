# set a fqdn for a public ip address 

# Public IP address of your ingress controller
IP="20.232.68.112"

# Name to associate with public IP address
DNSLABEL="keycloak-aks-oauth-demo"

# Get the resource-id of the public IP
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public IP address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSLABEL

# Display the FQDN
az network public-ip show --ids $PUBLICIPID --query "[dnsSettings.fqdn]" --output tsv
