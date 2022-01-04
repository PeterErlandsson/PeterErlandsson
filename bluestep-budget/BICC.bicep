targetScope = 'subscription'

param Production string = '9c1f72c2-f361-47ef-9e84-385945de7c43'
param Test string = 'cd477377-d2d8-4b06-bea0-0e8c0c88ace3'
param Sandbox string = '0149c4d7-fb82-4de7-9e90-0ccdc1bcd848'

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
    budgetName: 'Bicc-production-budget'
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
    budgetName: 'Bicc-test-budget'
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

module SandboxBudget './modules/budget.bicep' = { 
  name: 'BudgetDeploy-Sandbox'
  scope: subscription(Sandbox)
  params: {
    budgetName: 'Bicc-sandbox-budget'
    amount: 15000
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

