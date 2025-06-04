variable "vault_address" {
  default     = "http://localhost:8200"
  description = "The address of the Vault server."
  type        = string
}

variable "vault_token" {
  default     = "root"
  description = "The root token for the Vault server."
  type        = string
  sensitive   = true
}