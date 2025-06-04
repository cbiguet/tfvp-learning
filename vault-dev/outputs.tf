
output "example_secret_data" {
  value       = data.vault_kv_secret_v2.example_secret.data_json
  description = "The data of the example secret."
  sensitive   = true
}