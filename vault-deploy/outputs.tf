output "vault_address" {
  value = "http://localhost:8200"
  description = "The address of the local Vault server."
}

output "vault_root_token" {
  value       = "root" # For dev mode, hardcoded. For server mode, this would be an input/manual step.
  description = "The root token for the local Vault server. ONLY FOR DEV MODE!"
}