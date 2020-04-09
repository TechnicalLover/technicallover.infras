templateFile="template.json"

parameterFile1="parameters.vm1.json"
parameterFile2="parameters.vm2.json"
parameterFile3="parameters.vm3.json"

templateName="initUbuntuVm"

resourceGroup="devResourceGroup"
location="SoutheastAsia"

az.cmd group create \
  --name $resourceGroup \
  --location $location

# deploy vm 1
az.cmd deployment group create \
  --name $templateName \
  --resource-group $resourceGroup \
  --template-file $templateFile \
  --parameters $parameterFile1

# deploy vm 2
az.cmd deployment group create \
  --name $templateName \
  --resource-group $resourceGroup \
  --template-file $templateFile \
  --parameters $parameterFile2

# deploy vm 3
az.cmd deployment group create \
  --name $templateName \
  --resource-group $resourceGroup \
  --template-file $templateFile \
  --parameters $parameterFile3