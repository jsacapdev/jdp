@description('The environment name.')
param environment string = 'dev'

@description('The location.')
param location string = 'uksouth'

@secure()
param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

@description('The subnet octet range.')
param octet int

//////////////////////
// global variables 
//////////////////////

var product = 'jdp'

var vnetName = 'vnet-${product}-${environment}-001'
var synapseSubnetName = 'snet-${product}-${environment}-001'

var storageAccountName = 'st${product}${environment}001'

var synapseWorkspaceName = 'synw-${product}-${environment}-001'

module network './network.bicep' = {
  name: 'network'
  params: {
    location: location
    vnetName: vnetName
    synapseSubnetName: synapseSubnetName
    octet: octet
  }
}

module synstorage './storage.bicep' = {
  name: 'synstorage'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

module synapse './synapse.bicep' = {
  name: 'synapse'
  params: {
    location: location
    storageAccountName: storageAccountName
    synapseWorkspaceName: synapseWorkspaceName
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
  }
}

