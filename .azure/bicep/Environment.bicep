targetScope = 'resourceGroup'

param location string = resourceGroup().location
param appServicePlanName string
param appName string
param storageAccountName string
param websiteName string
param keyVaultName string
param azureSubscriptionObjectId string


resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: toLower(appServicePlanName)
  location: location
  sku: {
    tier: 'Basic'
    size: 'B1'
    name: 'B1'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(storageAccountName)
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: toLower(appName)
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

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: toLower(websiteName)
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  kind: 'web'
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  location: location
  name: toLower(keyVaultName)
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    tenantId: subscription().tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    accessPolicies: [
      {
        objectId: 'b87ddac9-f36d-448c-9977-bb8fa8d299a3'
        tenantId: subscription().tenantId
        permissions: {
          keys: [
            'list'
          ]
          secrets: [
            'list'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }}
