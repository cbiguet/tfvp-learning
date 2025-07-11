# Define Vault container image to use - available images found here: https://hub.docker.com/r/hashicorp/vault-enterprise/tags
variable "vault_image" { 
  default     = "hashicorp/vault-enterprise:1.19.5-ent"
  description = "The docker image to use for the Vault server."
  type        = string
}

variable "vault_license_path" { 
  description = "The path to the Vault Enterprise license."
  type        = string
}