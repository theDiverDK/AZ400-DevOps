targetScope = 'resourceGroup'

param location string = resourceGroup().location
param appName string
param storageAccountName string

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appName
  location: location
  sku: {
    tier: 'Basic'
    size: 'B1'
    name: 'B1'
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
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        // Add other app settings as needed
      ]
    }
  }
  dependsOn: [storageAccount]
}
