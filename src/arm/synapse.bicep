@description('The location into which the resources should be deployed.')
param location string

param synapseWorkspaceName string 

param storageAccountName string 

@secure()
param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

var preventDataExfiltration = false

var managedVirtualNetwork = 'default'

var dataLakeStorageAccountUrlSuffix = '.dfs.core.windows.net'

var dataLakeStorageAccountUrl = 'https://${toLower(storageAccountName)}${dataLakeStorageAccountUrlSuffix}'

var managedVnetSettings = {
  preventDataExfiltration: preventDataExfiltration
  allowedAadTenantIdsForLinking: []
}

resource workspaces 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: toLower(synapseWorkspaceName)
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: dataLakeStorageAccountUrl
      filesystem: toLower(dataLakeStorageAccountUrlSuffix)
    }
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
    managedVirtualNetwork: managedVirtualNetwork
    connectivityEndpoints: {
      dev: 'https://${toLower(synapseWorkspaceName)}.dev.azuresynapse.net'
      sqlOnDemand: '${toLower(synapseWorkspaceName)}-ondemand.sql.azuresynapse.net'
      sql: '${toLower(synapseWorkspaceName)}.sql.azuresynapse.net'
    }
    managedResourceGroupName: '${resourceGroup().name}-managedsynapse'
    managedVirtualNetworkSettings: managedVnetSettings
  }
}
