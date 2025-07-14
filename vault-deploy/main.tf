# VARIABLES ---------------------------------------------------------------------------------------

# Available images: https://hub.docker.com/r/hashicorp/vault-enterprise/tags
variable "vault_image" { 
  default     = "hashicorp/vault-enterprise:1.20-ent"
  description = "The docker image to use for the Vault server."
  type        = string
}

variable "vault_license_path" { 
  description = "The path to the Vault Enterprise license."
  type        = string
}

# PROVIDERS ---------------------------------------------------------------------------------------

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# VAULT SERVER ------------------------------------------------------------------------------------

# Instantiate docker provider
provider "docker" {}

# Fetch docker image
resource "docker_image" "vault_enterprise_image" {
  name = var.vault_image
}

# Create Vault server as a docker container
resource "docker_container" "vault_enterprise_server" {
  name  = "vault-enterprise-server"
  image = docker_image.vault_enterprise_image.name
  ports {
    internal = 8200
    external = 8200
  }
  command = ["server", "-dev", "-dev-root-token-id=root"]
  env = [
    "VAULT_ADDR=http://0.0.0.0:8200",
    "VAULT_LICENSE_PATH=/vault/license/vault.hclic" # This points to where the license file will be mounted
  ]
  rm = true

  # Mount the license file into the container.
  mounts {
    type   = "bind"
    source = var.vault_license_path
    target = "/vault/license/vault.hclic"
  }

  # The provisioner ensures the container is indeed up and responsive on port 8200
  # before Terraform marks this resource as "complete".
  # This helps the Vault provider connect successfully without connection refused errors.
  provisioner "local-exec" {
    command = <<EOT
      until curl -sS http://localhost:8200/v1/sys/health; do
        echo "Waiting for Vault to be ready..."
        sleep 2
      done
      echo "Vault is ready!"
    EOT
    interpreter = ["bash", "-c"] # Use bash for multi-line command and until loop
  }
}