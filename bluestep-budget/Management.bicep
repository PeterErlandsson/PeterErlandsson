targetScope = 'subscription'

param Production string = 'd903b703-93ed-43c2-ad4c-0c3815e44fba'
param Test string = '37aa9fba-943a-47bb-89f1-6be68d729ec3'

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
    budgetName: 'Management-production-budget'
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

module TestBudget './modules/budget.bicep' = { 
  name: 'BudgetDeploy-Test'
  scope: subscription(Test)
  params: {
    budgetName: 'Management-test-budget'
    amount: 20000
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
