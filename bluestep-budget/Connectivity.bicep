targetScope = 'subscription'

param Production string = '2887160a-ea77-4845-aba8-644475701efa'

@allowed([
  'cs-cz'
  'da-dk'
  'de-de'
  'en-gb'
  'en-us'
  'es-es'
  'fr-fr'
  'hu-hu'
  'it-it'
  'ja-jp'
  'ko-kr'
  'nb-no'
  'nl-nl'
  'pl-pl'
  'pt-br'
  'pt-pt'
  'ru-ru'
  'sv-se'
  'tr-tr'
  'zh-cn'
  'zh-tw'
])
param CultureCode string = 'sv-se'

module ProductionBudget './modules/budget.bicep' = { 
  name: 'BudgetDeploy-Prod'
  scope: subscription(Production)
  params: {
    budgetName: 'Connectivity-production-budget'
    amount: 30000
    category: 'Cost'
    timeGrain: 'BillingMonth'
    notifications: {
      First_Notification: {
        contactEmails: [
          'IT-Operations@bluestep.se'
        ]
        CultureCode: CultureCode
        contactGroups: []
        contactRoles: []
        enabled: 'True'
        operator: 'GreaterThan'
        threshold: 50
      }
      Second_Notification: {
        contactEmails: [
          'IT-Operations@bluestep.se'
        ]
        CultureCode: CultureCode
        contactGroups: []
        contactRoles: []
        enabled: 'True'
        operator: 'GreaterThan'
        threshold: 75
      }
    }
  }
}
