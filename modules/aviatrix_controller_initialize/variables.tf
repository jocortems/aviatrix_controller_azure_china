variable "avx_controller_public_ip" {
  type        = string
  description = "aviatrix controller public ip address(required)"
}

variable "avx_controller_private_ip" {
  type        = string
  description = "aviatrix controller private ip address(required)"
}

variable "avx_controller_admin_email" {
  type        = string
  description = "aviatrix controller admin email address"
}

variable "avx_controller_admin_password" {
  type        = string
  description = "aviatrix controller admin password"
}

variable "arm_subscription_id" {
  type        = string
  description = "Azure subscription id"
}

variable "arm_application_id" {
  type        = string
  description = "Azure application client id"
}

variable "arm_application_key" {
  type        = string
  description = "Azure application client secret"
}

variable "directory_id" {
  type        = string
  description = "Azure directory tenant id"
}

variable "account_email" {
  type        = string
  description = "aviatrix controller access account email"
}

variable "access_account_name" {
  type        = string
  description = "aviatrix controller access account name"
}

variable "aviatrix_customer_id" {
  type        = string
  description = "aviatrix customer license id"
}

variable "terraform_module_path" {
  type        = string
  description = "terraform module absolute path"
  default     = ""
}

variable "controller_version" {
  type        = string
  description = "Aviatrix Controller version"
}

variable "storage_account_name" {
  type        = string
  description = "Azure storage account used to store the backup"
  default     = ""
}

variable "storage_account_container" {
  type        = string
  description = "Azure storage account container used to store the backup"
  default     = ""
}

variable "storage_account_region" {
  type        = string
  description = "Azure region where "
  default     = ""
}

variable "multiple_backup" {
  type = string
  description = "Enable multiple backups"
}

variable "enable_backup" {
  type        = string
  description = "Whether to enable backup using the storage account created as part of this module. Set to false if you plan to restore from an existing backup"
}

variable "icp_certificate_domain" {
  type = string
  description = "ICP Certificate domain. It can be added afterwards if it is not currently available"
}