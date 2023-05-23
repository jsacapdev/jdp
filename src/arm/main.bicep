@description('The environment name.')
param environment string = 'dev'

@description('The location.')
param location string = 'uksouth'

@description('Product Owner Name')
param productOwner string

@secure()
param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

@description('The subnet octet range.')
param octet int

//////////////////////
// global variables 
//////////////////////

param tags object = {
  productOwner: productOwner
  application: 'data platform'
  environment: 'dev'
  projectCode: 'nonbillable'
}

var product = 'jdp'

var vnetName = 'vnet-${product}-${environment}-001'
var synapseSubnetName = 'snet-${product}-${environment}-001'

var storageAccountName = 'st${product}${environment}001'

var synapseWorkspaceName = 'synw-${product}-${environment}-001'

module network './modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
    tags: tags
    vnetName: vnetName
    synapseSubnetName: synapseSubnetName
    octet: octet
  }
}

module synstorage './modules/storage.bicep' = {
  name: 'synstorage'
  params: {
    location: location
    tags: tags
    storageAccountName: storageAccountName
  }
}

module synapse './modules/synapse.bicep' = {
  name: 'synapse'
  params: {
    location: location
    tags: tags
    storageAccountName: storageAccountName
    synapseWorkspaceName: synapseWorkspaceName
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
  }
}

