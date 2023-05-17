# Launch an Aviatrix Controller in Azure

## Description

These Terraform modules launch an Aviatrix Controller in Azure China and create an access account on the controller. It allows to specify the Certificate Domain, which must be a domain with an ICP registration. This is a requirement for controllers deployed in China. It also allows to specify an Azure storage account to enable backups.

## Prerequisites

1. [Terraform v0.13+](https://www.terraform.io/downloads.html) - execute terraform files
2. [Python3](https://www.python.org/downloads/) - execute `accept_license.py` and `aviatrix_controller_init.py` python
   scripts

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | \>= 2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | \>= 2.0 |


## Available Modules

Module  | Description |
| ------- | ----------- |
|[aviatrix_controller_build](modules/aviatrix_controller_build) |Builds the Aviatrix Controller VM on Azure |
|[aviatrix_controller_initialize](modules/aviatrix_controller_initialize) | Initializes the Aviatrix Controller (setting admin email, setting admin password, upgrading controller version, and setting up access account. Optionally allows specifying an Azure storage account to enable backups and provide a Certificate Domain) |

## Procedures for Building and Initializing a Controller in Azure

## Procedures for Building and Initializing a Controller in Azure

### 1. Create the Python virtual environment and install required dependencies

Install Python3.9 virtual environment.

``` shell
sudo apt install python3.9-venv
```

Create the virtual environment.

``` shell
python3.9 -m venv venv
```

Activate the virtual environment.

``` shell
source venv/bin/activate
```

Install Python3.9-pip

``` shell
sudo apt install python3.9-distutils
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.9 get-pip.py
```

Install required dependencies.

``` shell
pip install -r requirements.txt
```

### 2. Authenticating to Azure

Set the environment in Azure CLI to Azure China:

```shell
az cloud set -n AzureChinaCloud
```

Login to the Azure CLI using:

```shell
az login --use-device-code
````
*Note: Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs#authenticating-to-azure-active-directory) for different methods of authentication to Azure, incase above command is not applicable.*

Pick the subscription you want and use it in the command below.

```shell
az account set --subscription <subscription_id>
```

Set environment variables ARM_ENDPOINT and ARM_ENVIRONMENT to use Azure China endpoints:

  ``` shell
  export ARM_ENDPOINT=https://management.chinacloudapi.cn
  export ARM_ENVIRONMENT=china
  ```

If executing this code from a CI/CD pipeline, the following environment variables are required. The service principal used to authenticate the CI/CD tool into Azure must either have subscription owner role or a custom role that has `Microsoft.Authorization/roleAssignments/write` to be able to succesfully create the role assignments required

``` shell
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```


### 3. Applying Terraform configuration

Build and initialize the Aviatrix Controller

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

module "aviatrix_controller_azure" {
   source                                           = "github.com/jocortems/aviatrix_controller_azure_china"
   controller_name                                  = "my-controller"         # Required; Name of the Aviatrix Controller VM
   incoming_ssl_cidr                                = []                      # Optional; The IP address of the machine that runs this code doesn't need to be added to this variable, it is automatically retrieved using Terraform http provider
   avx_controller_admin_email                       = "john@doe.com"          # Required; Adds this email address to admin account in the Aviatrix Controller. 
   avx_controller_admin_password                    = "P@$$w0rd!"             # Required; Changes admin password to this password. Sensitive
   avx_account_email                                = "john@doe.com"          # Required; Creates an access account with this email address in the Aviatrix Controller.
   avx_access_account_name                          = "azure-account"         # Required; Creates an access account with this name in the Aviatrix Controller.
   aviatrix_customer_id                             = "my-license"            # Required; Aviatrix Controller License Sensitive
   controller_version                               = "latest"                # Optional; Upgrades the controller to this version. Default = "latest" 
   controller_virtual_machine_size                  = "Standard_A4_v2"        # Optional; Creates Scale Set with this size Virtual Machine. Default = "Standard_A4_v2"
   location                                         = "China North 3"         # Required; Azure China Region to create the Controller VM in.
   controller_vnet_cidr                             = "10.0.0.0/24"           # Optional; Creates Virtual Network with this address space. Default = "10.0.0.0/24"
   controller_subnet_cidr                           = "10.0.0.0/24"           # Optional; Creates Subnet with this cidr. Default = "10.0.0.0/24"
   avtx_service_principal_appid                     = "GUID"                  # Required; Azure AD SP object secret to be used to onboard Azure to Aviatrix Controller. Sensitive 
   avtx_service_principal_secret                    = "GUID"                  # Required; Azure AD SP object AppId to be used to onboard Azure to Aviatrix Controller. Sensitive
   enable_backup                                    = true/false              # Optional; Default true. Set to false if you plan to restore the Controller from an existing backup
   enable_multiple_backup                           = true/false              # Optional; Default true; whether to enable multiple backups for Aviatrix Controller
   icp_certificate_domain                           = "yourdomain.net"        # Optional; Registered ICP Domain. If not provided it must be manually configured later on before any gateway deployment
   storage_account_name                             = "mystorage"             # Optional; Required if "enable_backup" is set to true. Name must be unique
   storage_account_container                        = "mycontainer"           # Optional; Required if "enable_backup" is set to true. Container must exist in the storage account specified in "storage_account_name"
   storage_account_region                           = "China North 3"         # Optional; Required if "enable_backup" is set to true. Azure China Region where the storage account was created
}
```

*Execute*

```shell
terraform init
terraform apply
```
