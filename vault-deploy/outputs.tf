output "vault_address" {
  # value = "http://${docker_container.vault_dev_server.network_data[0].ip_address}:8200"
  value = "http://localhost:8200"
  description = "The address of the local Vault server."
}

output "vault_root_token" {
  value       = "root" # For dev mode, hardcoded. For server mode, this would be an input/manual step.
  description = "The root token for the local Vault server. ONLY FOR DEV MODE!"
  sensitive   = true
}