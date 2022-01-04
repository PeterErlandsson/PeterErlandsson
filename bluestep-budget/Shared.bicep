targetScope = 'subscription'

param Production string = '15fd53fd-1f42-46b2-8d17-b4e4177147cb'
param Test string = 'e151adf0-bce6-4aad-ab51-8accf2021f77'
param Sandbox string = '40ef3b89-6881-410d-882f-cd0c7fb8d205'

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
    budgetName: 'Shared-production-budget'
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
    budgetName: 'Shared-test-budget'
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
    budgetName: 'Shared-sandbox-budget'
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

