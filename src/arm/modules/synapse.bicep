@description('The location into which the resources should be deployed.')
param location string

param synapseWorkspaceName string 

param storageAccountName string 

@description('Tags')
param tags object

@secure()
param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

param sparkPoolName string = 'sparkpool'
param sparkNodeCount string = '3'
param sparkNodeSizeFamily string = 'MemoryOptimized'
param sparkNodeSize string = 'Small'
param sparkAutoScaleEnabled bool = false
param sparkMinNodeCount int = 1
param sparkMaxNodeCount int = 5
param sparkAutoPauseEnabled bool = false
param sparkAutoPauseDelayInMinutes int = 120
param sparkVersion string = '2.4'
param sparkConfigPropertiesFileName string = ''
param sparkConfigPropertiesContent string = ''
param sessionLevelPackagesEnabled bool = true

var preventDataExfiltration = false

var managedVirtualNetwork = 'default'

var dataLakeStorageAccountUrlSuffix = '.dfs.${environment().suffixes.storage}'

var dataLakeStorageAccountUrl = 'https://${toLower(storageAccountName)}${dataLakeStorageAccountUrlSuffix}'

var managedVnetSettings = {
  preventDataExfiltration: preventDataExfiltration
  allowedAadTenantIdsForLinking: []
}

resource workspaces 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: toLower(synapseWorkspaceName)
  tags: tags
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

resource bigDataPools 'Microsoft.Synapse/workspaces/bigDataPools@2021-03-01' = {
  parent: workspaces
  name: sparkPoolName
  location: location
  tags: tags
  properties: {
    nodeCount: int(sparkNodeCount)
    nodeSizeFamily: sparkNodeSizeFamily
    nodeSize: sparkNodeSize
    autoScale: {
      enabled: sparkAutoScaleEnabled
      minNodeCount: sparkMinNodeCount
      maxNodeCount: sparkMaxNodeCount
    }
    autoPause: {
      enabled: sparkAutoPauseEnabled
      delayInMinutes: sparkAutoPauseDelayInMinutes
    }
    sparkVersion: sparkVersion
    sparkConfigProperties: {
      filename: sparkConfigPropertiesFileName
      content: sparkConfigPropertiesContent
    }
    sessionLevelPackagesEnabled: sessionLevelPackagesEnabled
  }
}

