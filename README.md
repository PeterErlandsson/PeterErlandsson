# Introduction 
This repository contains different complete azure solutions/infrastructure as code designs and implementation.

# Getting Started
Develop your solution in either ARM or bicep.
1) Add the arm/bicep template to the repository with whatever build scripts needed.
2) Add a pipeline yaml to the repo: https://bluestepbank.visualstudio.com/Infrastructure/_git/Pipelines
3) Add a build validation pipeline to the repo on the master branch.

## Instruction for a new subscription
### PIM
- Enroll the subscription in PIM (https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-resource-roles-discover-resources)
- Run the \bluestep-customrole\helper.ps1 script 
- This structures all environment subscriptions in its management group and creates Azure AD groups for role assignments.
- Run the restapi.ps1 script 
Result: PIM assignable roles & assignments has been configured for each subscription using the Azure AD groups.
### Network
- Reserve a new network for the subscription in Netbox (https://netbox.bluestep.se)
- Add the network in \Bluestep-virtualnetwork\Environment.bicep (Production/Test/Sandbox)
- Make a Pull request this will:
- Trigger the pipeline/script for Bluestep Virtualnetwork.
Result: New spoke network has been created and peered with the hub.
### Firewall
- Add the network to the correct IP Group in \bluestep-firewall-rules\deploy.ps1
- Add routes for the network in the Firewall Gateway subnet \bluestep-firewall\main.bicep (RouteTableGateway object)
- Make a Pull request this will:
- Trigger the Bluestep-firewall-rules pipeline.
- Trigger the Bluestep-firewall pipeline.
Result: New azure firewall policies will be have applied and created, ip groups updated.
### Configure Azure Security Center
- Configure Azure Security Center to log to log-central-prod-we-001 in the management_production workspace.
### Configure TechData and Playgrounds access on the subscriptions
- Run the PowerShell script "Set-TechDataAndPlaygroundAccessOnSubscription.ps1" from the repo "Scripts".
### Done!