targetScope = 'subscription'
resource bluestepcontributor 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid('bluestepcontributor',subscription().id)
  // scope: Subscription
  properties: {
    roleName: 'Bluestep Contributor'
    description: 'The contributor role at Bluestep, providing both resource and data actions'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/*/Delete'
          'Microsoft.Authorization/*/Write'
          'Microsoft.Authorization/elevateAccess/Action'
          'Microsoft.Blueprint/blueprintAssignments/write'
          'Microsoft.Blueprint/blueprintAssignments/delete'
          'Microsoft.Network/connections/write'
          'Microsoft.Network/expressRouteCircuits/authorizations/write'
          'Microsoft.Network/expressRouteCircuits/join/action'
          'Microsoft.Network/expressRouteCircuits/peerings/connections/write'
          'Microsoft.Network/expressRouteCircuits/peerings/write'
          'Microsoft.Network/expressRouteCircuits/write'
          'Microsoft.Network/expressRouteCrossConnections/join/action'
          'Microsoft.Network/expressRouteCrossConnections/peerings/write'
          'Microsoft.Network/expressRouteGateways/expressRouteConnections/write'
          'Microsoft.Network/expressRoutePorts/write'
          'Microsoft.Network/loadBalancers/inboundNatRules/write'
          'Microsoft.Network/p2sVpnGateways/write'
          'Microsoft.Network/publicIPAddresses/write'
          'Microsoft.Network/publicIPPrefixes/write'
          'Microsoft.Network/routeTables/routes/write'
          'Microsoft.Network/routeTables/write'
          'Microsoft.Network/virtualNetworkGateways/write'
          'Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write'
          'Microsoft.Network/virtualRouters/peerings/write'
          'Microsoft.Network/virtualRouters/write'
          'Microsoft.network/virtualWans/p2sVpnServerConfigurations/write'
          'Microsoft.Network/virtualWans/write'
          'microsoft.network/vpnGateways/vpnConnections/write'
          'Microsoft.Network/vpnGateways/write'
          'Microsoft.Network/vpnServerConfigurations/write'
          'Microsoft.Network/vpnsites/write'
        ]
        dataActions: [
          '*'
        ]
        notDataActions: [
        ]
      }
    ]
assignableScopes: [
    placeholder
]
  }
}
