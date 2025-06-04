# VARIABLES ---------------------------------------------------------------------------------------

# Declare variables for the vault provider
# Notes: 
#  - Best practice is to define variables in a separate variables.tf file
#  - The login_password variable does not have a default - you will be prompted for its value
variable "vault_address" {
  default     = "http://localhost:8200"
  description = "The address of the Vault server."
  type        = string
}

variable "login_username" {
  default     = "dev-vault-user"
  description = "Username of the dev user"
  type        = string
}

variable "login_password" {
  description = "Password of the dev user"
  type        = string
  sensitive   = true
}

# PROVIDERS ---------------------------------------------------------------------------------------

# Specify the required terraform providers
# Note: The providers are loaded when the "terraform init" command is executed
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

# Create vault provider - Log in with the dev-vault-user credentials using the userpass auth method
provider "vault" {
  address = var.vault_address
  auth_login_userpass {
    mount    = "userpass"
    username = var.login_username
    password = var.login_password
  }
}

# SECRETS -----------------------------------------------------------------------------------------

# Create secret in dev-secrets kvv2 secrets engine
resource "vault_kv_secret_v2" "creds" {
  mount = "dev-secrets"
  name  = "creds"
  data_json = jsonencode(
    {
      password = "my-long-password",
    }
  )
}

# Read secret from dev-secrets
data "vault_kv_secret_v2" "example_secret" {
  mount = "dev-secrets"
  name  = vault_kv_secret_v2.creds.name
}