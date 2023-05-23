# J Data Platform

Scratch space for learning around data platform.

``` pwsh

az group create -n rg-jdp-dev-001 -l uksouth --tags "productOwner=abc" "application=data platform" "environment=dev" "projectCode=abc" --debug

az deployment group create -f ./main.bicep `
-g rg-jdp-dev-001 `
--parameters environment=dev `
location=uksouth `
octet=0 `
productOwner= `
sqlAdministratorLogin= `
sqlAdministratorLoginPassword= `
--debug

```

## Reference Material

<https://learn.microsoft.com/en-us/azure/synapse-analytics/get-started>

<https://learn.microsoft.com/en-us/azure/synapse-analytics/get-started-analyze-spark>
