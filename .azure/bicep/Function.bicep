targetScope = 'resourceGroup'

@description('Specifies the location for resources.')

param location string = resourceGroup().location
param appName string
param storageAccountName string


resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    tier: 'Free'
    size: 'F1'
    name: 'F1'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  dependsOn: [storageAccount]
}
