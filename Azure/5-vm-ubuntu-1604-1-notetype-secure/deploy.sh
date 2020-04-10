declare location="SoutheastAsia"

declare secretResourceGroup="devSecretRG"
declare keyVaultName="sfDevLearningHubKeyVault"
declare certPassword="Trung1997"
declare certDNSName="sfDevLearningHubCert"
declare keyVaultSecretName=${certDNSName//./-}

echo "Create Self-Signed Certificate"
# create self-signed certificate
sh new-service-fabric-cluster-certificate.sh \
    $location \
    $secretResourceGroup \
    $keyVaultName \
    $certPassword \
    $certDNSName

echo "Fetching certificate values from Key Vault . . ."
# -- Get the values from Key Vault to use in the ARM template --
# Source vault ID
declare keyVaultResourceId=$(az.cmd keyvault show --name $keyVaultName --query id -o tsv)

# Certificate thumbprint
declare certThumbprint=$(az.cmd keyvault certificate show --vault-name $keyVaultName --name $keyVaultSecretName --query x509ThumbprintHex -o tsv)

# Certificate URL
declare certUrl=$(az.cmd keyvault certificate show --vault-name $keyVaultName --name $keyVaultSecretName --query sid -o tsv)

echo
echo "Source Vault Resource Id: "$keyVaultResourceId
echo "Certificate URL: "$certUrl
echo "Certificate Thumbprint: "$certThumbprint

declare templateFile="AzureDeploy.json"
declare parameterFile="AzureDeploy.Parameters.json"
declare devResourceGroup="devRG"
declare templateName="initSfClusterLinux"

# create resource group
# az.cmd group create \
#   --name $devResourceGroup \
#   --location $location

declare clusterName="sfDevLearningHub"
declare adminUserName="ldt"
declare adminPassword="Trung1997"

    "certificateThumbprint": {
      "value": "GEN-SF-CERT-THUMBPRINT"
    },
    "sourceVaultValue": {
      "value": "GEN-KEYVAULT-RESOURCE-ID"
    },
    "certificateUrlValue": {
      "value": "GEN-SF-CERT-URL"
    },
# deploy
az.cmd deployment group create \
    --name $templateName \
    --resource-group $devResourceGroup \
    --template-file $templateFile \
    --parameters $parameterFile \
        clusterLocation=$location \
        clusterName=$clusterName \
        adminUserName=$adminUserName \
        adminPassword=$adminPassword \
        certificateThumbprint=$certThumbprint \
        sourceVaultValue=$keyVaultResourceId \
        certificateUrlValue=$certUrl