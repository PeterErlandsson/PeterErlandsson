targetScope = 'subscription'

param Production string = '1a4b8123-9a77-4b77-9c37-0fe324ee7588'
param Test string = 'ad9a9cc4-f2cc-42a9-9941-49acae2ffb87'
param Sandbox string = 'acd59361-7d2f-4939-a846-bb9266a6d622'

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
    budgetName: 'Web-production-budget'
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
    budgetName: 'Web-test-budget'
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
    budgetName: 'Web-sandbox-budget'
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

