@description('The location into which the resources should be deployed.')
param location string

@description('The storage account name.')
param storageAccountName string 

@description('Tags')
param tags object
param storageAccessTier string = 'Hot'

param storageIsHnsEnabled bool = true

param storageAccountType string = 'Standard_RAGRS'

var storageFilesystemName = 'jdpanalyticsdata'

resource storageAccounts 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: toLower(storageAccountName)
  tags: tags
  location: location
  properties: {
    accessTier: storageAccessTier
    supportsHttpsTrafficOnly: true
    isHnsEnabled: storageIsHnsEnabled
    networkAcls: {
      virtualNetworkRules: []
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
}

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${toLower(storageAccountName)}/default/${toLower(storageFilesystemName)}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts
  ]
}

