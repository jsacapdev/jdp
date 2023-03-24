param location string

param vnetName string

param synapseSubnetName string

@description('.')
param octet int

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.${octet}.0/19'
      ]
    }
    subnets: [
      {
        name: synapseSubnetName
        properties: {
          addressPrefix: '10.2.${octet}.0/24'
        }
      }
    ]
  }
}
