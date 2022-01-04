# Introduction 
This folder contains different Azure Budgets per department in Azure.

## Onboarding a new subscription
- Add a new Department.bicep file & configure the required parameters
- Update the Parameter for the azure-budget-pipeline called "ListOfDepartmentNames"

## Examples
This example shows a budget for the production department that when exceeding 75% consumed it will notify everyone who has the Bluestep Contributor role,
And once the consumption has reached 90% it will also contact the system owner.
```
module ProductionBudget './modules/budget.bicep' = { 
  name: 'BudgetDeploy-Prod'
  scope: subscription(Production)
  params: {
    amount: 30000
    category: 'Cost'
    timeGrain: 'BillingMonth'
    notifications: {
      First_Notification: {
        contactEmails: []
        CultureCode: CultureCode
        contactGroups: []
        contactRoles: [
            'Bluestep Contributor'
        ]
        enabled: 'True'
        operator: 'GreaterThan'
        threshold: 75
      }
        Second_Notification: {
        contactEmails: [
            'SystemOwner@Bluestep.se'
        ]
        CultureCode: CultureCode
        contactGroups: []
        contactRoles: []
        enabled: 'True'
        operator: 'GreaterThan'
        threshold: 90
      }
    }
  }
}
```

## Links to read more:
Microsoft.Consumption/budgets documentation: https://docs.microsoft.com/en-us/azure/templates/microsoft.consumption/budgets?tabs=json
Creating a budget template: https://docs.microsoft.com/en-us/azure/cost-management-billing/costs/quick-create-budget-template?tabs=PowerShell