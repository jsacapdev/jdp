# J Data Platform

Scratch space for learning around data platform.

``` pwsh

az group create -n rg-jdp-dev-001 -l uksouth --debug

az deployment group create -f ./main.bicep `
-g rg-jdp-dev-001 `
--parameters environment=dev `
location=uksouth `
octet=0 `
sqlAdministratorLogin= `
sqlAdministratorLoginPassword= `
--debug

```
