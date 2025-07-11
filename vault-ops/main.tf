# VARIABLES ---------------------------------------------------------------------------------------

# Define variables for the vault provider
# Notes: 
#  - Best practice is to define variables in a separate variables.tf file
#  - The vault_token variable does not have a default - you will be prompted for its value
variable "vault_address" {
  default     = "http://localhost:8200"
  description = "The address of the Vault server."
  type        = string
}

variable "vault_token" {
  description = "The root token for the Vault server."
  type        = string
  sensitive   = true
}

# PROVIDERS ---------------------------------------------------------------------------------------

# Specify the required terraform providers (loaded when executing "terraform init")
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
    }
  }
}

# Create vault provider - Log in with the root token
provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

# AUTH METHODS ------------------------------------------------------------------------------------

# Create basic userpass auth method
resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# Create dev-vault-user for the userpass auth method
# Note: No resource in TVFP for this use case;
#       the vault_generic_endpoint is used to make the correspond API call to Vault
resource "vault_generic_endpoint" "dev-vault-user" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/dev-vault-user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "token_policies": ["developer-vault-policy"],
  "password": "pass"
}
EOT
}

# POLICIES ----------------------------------------------------------------------------------------

# Create developer policy
# Note: The last path is required for the developer user to interact with Vault through TFVP
resource "vault_policy" "developer-vault-policy" {
  name = "developer-vault-policy"

  policy = <<EOT
path "dev-secrets/+/creds" {
  capabilities = ["create", "update"]
}
path "dev-secrets/+/creds" {
  capabilities = ["read"]
}
## Vault TF provider requires ability to create a child token
path "auth/token/create" {  
  capabilities = ["create", "update", "sudo"]  
}
EOT
}

# SECRETS ENGINES ---------------------------------------------------------------------------------

# Create key-value version 2 secrets engine
resource "vault_mount" "dev-secrets" {
  path        = "dev-secrets"
  type        = "kv"
  description = "KV2 for dev secrets"
  options     = { version = "2" }
}
