# Terraform Secrets Management with HashiCorp Vault 🔐

## 📅 Date

05 August 2026

---

# 🎯 Objective

Learn how Terraform securely manages sensitive information using **HashiCorp Vault** instead of hardcoding credentials inside Terraform configuration.

---

# 📚 Topics Covered

- Why Secrets Management is required
- What is HashiCorp Vault?
- Terraform + Vault Architecture
- Installing Vault on Ubuntu EC2
- Vault Development Mode
- Vault Provider
- Reading Secrets from Vault
- Troubleshooting Vault Installation
- Troubleshooting Vault Connectivity

---

# ❓ Problem Statement

Suppose we configure Terraform like this:

```hcl
provider "aws" {
  access_key = "AKIAxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxx"
}
```

Problem:

AWS credentials are stored directly inside the Terraform code.

If this code is pushed to GitHub, the credentials become exposed.

---

# Solution

Store credentials inside **HashiCorp Vault**.

Terraform reads secrets securely during execution.

```text
Terraform
      │
      ▼
HashiCorp Vault
      │
      ▼
AWS Credentials
      │
      ▼
AWS
```

Secrets are never hardcoded inside Terraform files.

---

# What is HashiCorp Vault?

HashiCorp Vault is a **Secrets Management Tool**.

It securely stores:

- Passwords
- API Keys
- AWS Credentials
- Database Credentials
- Tokens
- Certificates

Terraform retrieves these secrets whenever required.

---

# Terraform + Vault Workflow

```text
terraform apply
        │
        ▼
Terraform Starts
        │
        ▼
Connects to Vault
        │
        ▼
Authenticates
        │
        ▼
Reads Secret
        │
        ▼
Uses Secret
        │
        ▼
Creates AWS Resources
```

---

# Installing Vault

## Install GPG

```bash
sudo apt update
sudo apt install gpg
```

Purpose:

Verify package authenticity.

---

## Download HashiCorp Signing Key

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg \
| sudo gpg --dearmor \
-o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

Purpose:

Import HashiCorp public key.

---

## Add HashiCorp Repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Purpose:

Tell Ubuntu where Vault packages are available.

---

## Refresh Package List

```bash
sudo apt update
```

---

## Install Vault

```bash
sudo apt install vault
```

---

# Running Vault

```bash
vault server -dev -dev-listen-address="0.0.0.0:8200"
```

Meaning:

- Development Mode
- Auto initialized
- Auto unsealed
- Listens on all interfaces
- Accessible using EC2 Public IP

---

# Terraform Vault Provider

```hcl
provider "vault" {

  address = "http://<EC2-IP>:8200"

  skip_child_token = true

  auth_login {

    path = "auth/approle/login"

    parameters = {

      role_id = "<role-id>"

      secret_id = "<secret-id>"

    }

  }

}
```

Purpose:

Allows Terraform to authenticate with Vault.

---

# Reading Secrets

```hcl
data "vault_kv_secret_v2" "example" {

  mount = "secret"

  name = "test-secret"

}
```

Purpose:

Reads the secret named **test-secret** from Vault.

---

# Using Secret

```hcl
Secret = data.vault_kv_secret_v2.example.data["foo"]
```

Terraform retrieves:

```text
Vault

↓

test-secret

↓

foo = value

↓

Terraform
```

---

# Complete Flow

```text
Terraform

↓

Vault Provider

↓

Authenticate

↓

Read Secret

↓

AWS Provider

↓

Create EC2
```

---

# Troubleshooting Performed

## HashiCorp Repository Error

Error:

```
NO_PUBKEY
```

Reason:

Corrupted GPG key.

Fix:

- Remove old key
- Download again
- Import correctly

---

## Vault UI Not Opening

Checked:

✔ Vault Process

✔ Listening Port

✔ Security Group

✔ UFW

✔ Vault Health API

Vault was healthy.

Remaining possibility:

Local network / VPN / Browser restrictions.

---

# Project Structure

```text
08-Secrets-Management/

├── README.md
├── versions.tf
├── provider.tf
├── variables.tf
├── outputs.tf
└── main.tf
```

---

# Important Commands

Install Vault

```bash
sudo apt install vault
```

Start Vault

```bash
vault server -dev -dev-listen-address="0.0.0.0:8200"
```

Check Listening Port

```bash
ss -tlnp
```

Vault Health

```bash
curl http://localhost:8200/v1/sys/health
```

Firewall

```bash
sudo ufw status
```

---

# Key Learnings

- Never hardcode credentials in Terraform.
- Vault securely stores sensitive data.
- Terraform reads secrets during execution.
- Vault only provides secrets.
- Terraform creates infrastructure.
- Development Mode is only for learning.

---

# Interview Questions

### What is HashiCorp Vault?

A secrets management tool used to securely store and retrieve sensitive information.

---

### Why integrate Terraform with Vault?

To avoid storing secrets inside Terraform configuration and retrieve them securely at runtime.

---

### What is the Vault Provider?

A Terraform provider used to connect and authenticate with Vault.

---

### What does `vault_kv_secret_v2` do?

Reads secrets from Vault.

---

### What is `skip_child_token = true`?

It tells Terraform to use the current Vault token instead of creating another temporary child token.

---

# Final Summary

> HashiCorp Vault acts as a secure locker for secrets. Terraform authenticates with Vault, reads the required secrets, and then uses those secrets to provision infrastructure without exposing sensitive information inside Terraform code.
