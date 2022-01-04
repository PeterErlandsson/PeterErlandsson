# Bluestep custom role configuration

## Allowed roles
We're recommend that the following roles is to be used in our Subscriptions/Management groups per default:
- Reader
- Owner
- Bluestep Contributor

### Reader role definiton and purpose
The purpose and definition of this is to simply allow reading all the resources and viewing them.
This role does not allow Data read actions so simply viewing the resource groups, resources and configuration of them, not the data inside of them.


### Owner role definition and purpose
The purpose of this role is to allow creation of excluded resources from the Bluestep contributor role.
Such as Public endpoints, firewalls, firewall policies etc.
This role should only be used by the employees in the Infrastructure team

### Bluestep Contributor
The purpose of this role is that it's the default role within Bluestep.
The role itself has the access to create most type of resources in Azure, however some resource types that exposes Bluestep data to internet is blocked (except storage accounts)
It also provides DataAction on the resources, so that you can access the data inside of the resources as well as being able to configure them.

## Production Role configurations
Reader role:
- Active assignment (no need for checkout)

Owner role: 
- Eligible assignment (Need for checkout)
- Maximum allowed check out time: 4 hours

Bluestep contributor role: 
- Eligible assignment (Need for checkout)
- Maximum allowed check out time: 4 hours

## Other environments (dev/test/sandbox) Role configurations
Reader role:
- Active assignment (no need for checkout)

Owner role: 
- Eligible assignment (Need for checkout)
- Maximum allowed check out time: 9 hours

Bluestep contributor role: 
- Eligible assignment (Need for checkout)
- Maximum allowed check out time: 9 hours