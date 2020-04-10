location="SoutheastAsia"

secretResourceGroup="devSecretRG"
keyVaultName="sfDevLearningHubKeyVault"
certPassword="Trung1997"
certDNSName="sfDevLearningHubCert"

# create selt-signed certificate
sh new-service-fabric-cluster-certificate.sh \
    $location \
    $secretResourceGroup \
    $keyVaultName \
    $certPassword \
    $certDNSName

templateFile="AzureDeploy.json"
parameterFile="AzureDeploy.Parameters.json"
devResourceGroup="devRG"
templateName="initSfClusterLinux"

# create resource group
# az.cmd group create \
#   --name $devResourceGroup \
#   --location $location


clusterName="sfDevLearningHub"
adminUserName="ldt"
adminPassword="Trung1997"

# deploy
az.cmd deployment group create \
  --name $templateName \
  --resource-group $devResourceGroup \
  --template-file $templateFile \
  --parameters $parameterFile \
               clusterLocation=$location
               clusterName=$clusterName
               adminUserName=$adminUserName
               adminPassword=$adminPassword