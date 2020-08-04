#!/bin/bash

RESOURCE_GROUP_NAME=gbm-demo-rg
VNET_NAME=gmbdemovnet
VNET_SUBNET_NAME=akssubnet
CLUSTER_NAME=gbmcluster
LOCATION=eastus
ACR_NAME=gbmdemoacr


# Create a resource group
echo "Creating the Resource group $RESOURCE_GROUP_NAME at $LOCATION"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Creating the ACR
echo "Creating the ACR: $ACR_NAME"
az acr create -n $ACR_NAME -g $RESOURCE_GROUP_NAME --sku basic

echo "Importing image docker.io/library/nginx:latest fron docker hub"
az acr import  -n $ACR_NAME --source docker.io/library/nginx:latest --image nginx:v1

# Create a virtual network and subnet
echo "Creating the vnet and subnet"
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $VNET_NAME \
    --address-prefixes 192.168.0.0/22 \
    --subnet-name $VNET_SUBNET_NAME \
    --subnet-prefix 192.168.0.0/23

# Create a service principal and read in the application ID
echo "Creating the service principal"
SP=$(az ad sp create-for-rbac --output json)
SP_ID=$(echo $SP | jq -r .appId)
SP_PASSWORD=$(echo $SP | jq -r .password)

# Wait 15 seconds to make sure that service principal has propagated
echo "Waiting for service principal to propagate..."
sleep 15

# Get the virtual network resource ID
echo "Getting the VNET ID"
VNET_ID=$(az network vnet show --resource-group $RESOURCE_GROUP_NAME --name $VNET_NAME --query id -o tsv)

# Assign the service principal Contributor permissions to the virtual network resource
az role assignment create --assignee $SP_ID --scope $VNET_ID --role Contributor

# Get the virtual network subnet resource ID
echo "Getting the VNET ID"
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP_NAME --vnet-name $VNET_NAME --name $VNET_SUBNET_NAME --query id -o tsv)

echo "Creatihg the AKS cluster: $CLUSTER_NAME"
az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
    --node-count 2 \
    --generate-ssh-keys \
    --network-plugin azure \
    --service-cidr 192.168.4.0/22 \
    --dns-service-ip 192.168.4.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --vnet-subnet-id $SUBNET_ID \
    --service-principal $SP_ID \
    --client-secret $SP_PASSWORD \
    --attach-acr $ACR_NAME \
    --network-policy azure

echo "Remeber to get the credentials"
echo "Run: az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME"
