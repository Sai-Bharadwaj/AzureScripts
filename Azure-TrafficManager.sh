RG=AZUREBATCHHHH

echo "Creating Azure Resource Group"
az group create -l eastus -n ${RG}

echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus

az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n ${RG}-Subnet-2 \
--address-prefixes 10.1.2.0/24

az network vnet create -g ${RG} -n ${RG}-WEST2-vNET1 --address-prefix 10.2.0.0/16 \
--subnet-name ${RG}-WEST2-Subnet-1 --subnet-prefix 10.2.1.0/24 -l westus2

az network vnet subnet create -g ${RG} --vnet-name ${RG}-WEST2-vNET1 -n ${RG}-WEST2-Subnet-2 \
--address-prefixes 10.2.2.0/24

az network vnet create -g ${RG} -n ${RG}-CINDIA-vNET1 --address-prefix 10.3.0.0/16 \
--subnet-name ${RG}-CINDIA-Subnet-1 --subnet-prefix 10.3.1.0/24 -l centralindia

az network vnet subnet create -g ${RG} --vnet-name ${RG}-CINDIA-vNET1 -n ${RG}-CINDIA-Subnet-2 \
--address-prefixes 10.3.2.0/24

echo "Creating Azure NSG & Rules"
az network nsg create -g ${RG} -n ${RG}_NSG1 --location eastus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow   --protocol Tcp --description "Allowing All Traffic"

echo "Creating Azure NSG & Rules"
az network nsg create -g ${RG} -n ${RG}_WEST2_NSG1 --location westus2
az network nsg rule create -g ${RG} --nsg-name ${RG}_WEST2_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow   --protocol Tcp --description "Allowing All Traffic"

echo "Creating Azure NSG & Rules"
az network nsg create -g ${RG} -n ${RG}_CINDIA_NSG1 --location centralindia
az network nsg rule create -g ${RG} --nsg-name ${RG}_CINDIA_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow   --protocol Tcp --description "Allowing All Traffic"


az vm create --resource-group ${RG} --name ${RG}EastVM1 --image UbuntuLTS --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username testuser --admin-password "India@123456" --size Standard_B2s \
--nsg ${RG}_NSG1 --zone 1 --custom-data ./clouddrive/cloud-init.txt

 
az vm create --resource-group ${RG} --name ${RG}EastVM2 --image UbuntuLTS --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-2 --admin-username testuser --admin-password "India@123456" --size Standard_B1ls \
--nsg ${RG}_NSG1 --zone 2 --custom-data ./clouddrive/cloud-init.txt


az vm create --resource-group ${RG} --name ${RG}WestVM1 --image UbuntuLTS --vnet-name ${RG}-WEST2-vNET1 \
--subnet ${RG}-WEST2-Subnet-1 --admin-username testuser --admin-password "India@123456" --size Standard_B1ls \
--nsg ${RG}_WEST2_NSG1 --zone 1 --location westus2 --custom-data ./clouddrive/cloud-init.txt


az vm create --resource-group ${RG} --name ${RG}WestVM2 --image UbuntuLTS --vnet-name ${RG}-WEST2-vNET1 \
--subnet ${RG}-WEST2-Subnet-2 --admin-username testuser --admin-password "India@123456" --size Standard_B1ls \
--nsg ${RG}_WEST2_NSG1 --zone 2 --location westus2 --custom-data ./clouddrive/cloud-init.txt

az vm create --resource-group ${RG} --name ${RG}CINDIAVM1 --image UbuntuLTS --vnet-name ${RG}-CINDIA-vNET1 \
--subnet ${RG}-CINDIA-Subnet-1 --admin-username testuser --admin-password "India@123456" --size Standard_B1ls \
--nsg ${RG}_CINDIA_NSG1 --location centralindia --custom-data ./clouddrive/cloud-init.txt


az vm create --resource-group ${RG} --name ${RG}CINDIAVM2 --image UbuntuLTS --vnet-name ${RG}-CINDIA-vNET1 \
--subnet ${RG}-CINDIA-Subnet-2 --admin-username testuser --admin-password "India@123456" --size Standard_B1ls \
--nsg ${RG}_CINDIA_NSG1 --location centralindia --custom-data ./clouddrive/cloud-init.txt