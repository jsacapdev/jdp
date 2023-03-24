@description('The location into which the resources should be deployed.')
param location string

@description('The storage account name.')
param storageAccountName string 

param storageAccessTier string = 'Hot'

param storageIsHnsEnabled bool = true

param storageAccountType string = 'Standard_RAGRS'

var storageFilesystemName = 'jdpanalyticsdata'

resource storageAccounts 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: toLower(storageAccountName)
  location: location
  properties: {
    accessTier: storageAccessTier
    supportsHttpsTrafficOnly: true
    isHnsEnabled: storageIsHnsEnabled
    networkAcls: {
      virtualNetworkRules: []
      bypass: 'AzureServices'
      defaultAction: 'Deny'
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

