<# 
 Example adapter from : https://github.com/microsoft/MDCC/tree/main/Confidential%20Computing%20Workshop 
 From : Arnaud Jumelet - Member of CTO Office - Microsoft France
 #>

# Ouvrir le Terminal et se Logger avec l'onglet Azure

# Az login
az login

# Choix de la Sub
az account set --subscription "TGI - MCT Subscribtion"

# Resource Group creation
az group create --name "MeetUp-Devoteam2" --location northeurope

# VM creation Confidential Computing
# Show in the Azure Portal
az vm create --resource-group "MeetUp-Devoteam2" --name "MeetUpConfidentialVMv2" `
--generate-ssh-keys --size Standard_DC4as_v5  --admin-username thibault --admin-password "coucou123456." `
--enable-vtpm true --image "Canonical:0001-com-ubuntu-confidential-vm-focal:20_04-lts-cvm:latest" `
--public-ip-sku Standard   --security-type ConfidentialVM `
--os-disk-security-encryption-type VMGuestStateOnly `
--enable-secure-boot true

##################################################################################
# Below part is to be executed on the Confidential VM that has been generated
##################################################################################

# GitHub https://github.com/Azure-Samples/microsoft-azure-attestation
# Packages needed to compile the Microsoft Azure Attestaton application
sudo apt update && sudo apt-get install build-essential && sudo apt-get install libcurl4-openssl-dev && sudo apt-get install libjsoncpp-dev && sudo apt-get install libboost-all-dev && sudo apt install nlohmann-json3-dev && wget https://packages.microsoft.com/repos/azurecore/pool/main/a/azguestattestation1/azguestattestation1_1.0.2_amd64.deb && sudo dpkg -i azguestattestation1_1.0.2_amd64.deb

# Packages needed to compile the Microsoft Azure Attestaton application 
# Yes to everything 🤣
sudo apt update && sudo apt-get --assume-yes install build-essential && sudo apt-get --assume-yes install libcurl4-openssl-dev && sudo apt-get --assume-yes install libjsoncpp-dev && sudo apt-get --assume-yes install libboost-all-dev && sudo apt --assume-yes install nlohmann-json3-dev && wget https://packages.microsoft.com/repos/azurecore/pool/main/a/azguestattestation1/azguestattestation1_1.0.2_amd64.deb && sudo dpkg -i azguestattestation1_1.0.2_amd64.deb


# Running the application thanks to source from GitHub 
git clone https://github.com/Azure/confidential-computing-cvm-guest-attestation.git && cd confidential-computing-cvm-guest-attestation/cvm-attestation-sample-app && sudo apt --assume-yes install cmake && sudo apt --assume-yes install g++ && sudo cmake . && sudo make

# Running the application thanks to source from GitHub
# Yes to everything 🤣
git clone https://github.com/Azure/confidential-computing-cvm-guest-attestation.git && cd confidential-computing-cvm-guest-attestation/cvm-attestation-sample-app && sudo apt --assume-yes install cmake && sudo apt --assume-yes install g++ && sudo cmake . && sudo make

# Execute the Microsoft Attestation app to get the secured Token
sudo ./AttestationClient -o token
