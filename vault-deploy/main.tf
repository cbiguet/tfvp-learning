terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "vault_image" {
  name = "hashicorp/vault:latest"
}

resource "docker_container" "vault_dev_server" {
  name  = "vault-dev-server"
  image = docker_image.vault_image.name
  ports {
    internal = 8200
    external = 8200
  }
  command = ["server", "-dev", "-dev-root-token-id=root"]
  env = ["VAULT_ADDR=http://0.0.0.0:8200"]
  rm = true

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