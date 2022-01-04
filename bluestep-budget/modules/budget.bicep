targetScope = 'subscription'

param amount int

@allowed([
  'Cost'
  'Usage'
])
param category string

@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
  'BillingMonth'
  'BillingQuarter'
  'BillingAnnual'
])
param timeGrain string
param timePeriod object = {
  startDate: '2021-07-01T00:00:00Z'
}
param filter object = {}
param notifications object
param budgetName string

resource budget 'Microsoft.Consumption/budgets@2019-10-01' = {
  name: budgetName
  properties: {
    category: category
    amount: amount
    timeGrain: timeGrain
    timePeriod: timePeriod
    filter: filter
    notifications: notifications
  }
}

output BudgetAmount int = amount

output BudgetNotifications object = budget.properties.notifications
