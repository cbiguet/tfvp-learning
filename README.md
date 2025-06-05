# Terraform Vault Provider - Learning

## Pre-requisites

Open a terminal and run the following commands to install all pre-requisites:
1.  Install Command Line Tools for Xcode
    ```bash
    xcode-select --install
    ```

2.  Install the homebrew package manager
    ```bash
    /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
    ```

3.  Install the hashicorp tap
    ```bash
    brew tap hashicorp/tap
    ```

4.  Install Vault
    ```bash
    brew install hashicorp/tap/vault
    ```

5.  Install Terraform
    ```bash
    brew install hashicorp/tap/terraform
    ```

6.  Install Docker
    ```bash
    brew install --cask docker
    ```
    *After the installation, you'll need to launch Docker Desktop from your Applications folder (or via Spotlight). The first time it runs, it will likely prompt you to accept its terms and conditions and might ask for your macOS password for necessary configurations.*

## Instructions

To start, retrieve the project from Github:
1. Open a terminal and clone the Github repository [tfvp-learning](https://github.com/cbiguet/tfvp-learning)
    ```bash
    git clone https://github.com/cbiguet/tfvp-learning.git
    ```
2. Navigate to the resulting directory
    ```bash
    cd tfvp-learning
    ```

Each section of this project uses Terraform to accomplish a specific objective:
- `vault-deploy` - Set up a Vault server in dev mode running in a local container
- `vault-ops` - Configure Vault server (enable auth methods, create secrets engines)
- `vault-dev` - Use Vault server (create and retrieve secrets)

Terraform uses declarative language to describe the desired resources; the Terraform Vault Provider (TFVP) provides Vault-specific resources (such as `vault_auth_backend`) for use in Terraform configuration files.

If you want to understand what Terraform does in each section, read the associated `main.tf` file where each step is documented.

### Set up the Vault dev server
(Persona: operations)

You can use Terraform to set up a Vault dev server running in a container locally.

1. Open a terminal in the root directory of the project `tfvp-learning`
2. Navigate to the `vault-deploy` directory
    ```bash
    cd vault-deploy
    ```
2. Initialize the Terraform configuration (*Note: this will download the required Terraform plugins, referred to as providers*)
    ```bash
    terraform init
    ```
3. Apply the Terraform configuration
    ```bash
    terraform apply -auto-approve
    ```

#### Outcome
Creates a local container running Vault in dev mode with the following parameters:
- Vault address - `http://localhost:8200`
- Vault root token - `root`

### Manage Vault with TFVP
(Persona: operations)

You can use the Vault Terraform provider to manage Vault infrastructure through actions such as enabling auth methods and secrets engines.

1. Open a terminal in the root directory of the project `tfvp-learning`
2. Navigate to the `vault-ops` directory
    ```bash
    cd vault-ops
    ```
3. Initialize the Terraform configuration
    ```bash
    terraform init
    ```
4. Apply the Terraform configuration; you will be prompted for the root token value
    ```bash
    terraform apply -auto-approve
    ```

#### Outcome
This will perform the following actions (with the root token):
- Enable the `userpass` auth method at `userpass`
- Create the `dev-vault-user` (auth_method: userpass, password: pass, policy: developer-vault-policy)
- Create the `developer-vault-policy`
- Create a kv-v2 secrets engine at `dev-secrets`

### Use Vault with TFVP
(Persona: Developer)

You can use the Vault Terraform provider to create and read secrets.

1. Open a terminal in the root directory of the project `tfvp-learning`
2. Navigate to the `vault-dev` directory
    ```bash
    cd vault-dev
    ```
3. Initialize the Terraform configuration
    ```bash
    terraform init
    ```
4. Apply the Terraform configuration; you will be prompted for the `dev-vault-user`'s password
    ```bash
    terraform apply -auto-approve
    ```

#### Outcome
This will perform the following actions (with the `dev-vault-user`):
- Create a secret named `creds` in `dev-secrets`
- Read the `creds` secret

## Summary

In this project, you used Terraform (and the Terraform Vault provider) to provision, manage and use Vault. 

You can log into the [Vault UI](http://localhost:8200/ui) to verify the work done in each section.

### Clean up
Run `terraform destroy` in each of the project's sub-directories in the following order: `vault-dev`, `vault-ops`, `vault-deploy`