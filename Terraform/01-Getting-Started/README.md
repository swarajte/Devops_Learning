# 🚀 Terraform Day 1 - Getting Started

**Date:** 24 July 2026

---

# 🎯 Goal

Understand the fundamentals of Terraform and Infrastructure as Code (IaC).

By the end of this session, we learned how to:

- Install Terraform
- Configure AWS CLI
- Understand Providers
- Write the first Terraform configuration
- Initialize Terraform
- Preview infrastructure changes
- Create an EC2 instance
- Understand Terraform State
- Destroy infrastructure

---

# 📖 What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool developed by **HashiCorp**.

Instead of creating cloud resources manually using the AWS Console, we write code and let Terraform create, update, and delete infrastructure automatically.

---

# 📖 Infrastructure as Code (IaC)

Infrastructure such as:

- EC2
- VPC
- S3
- IAM
- RDS
- Load Balancer

is defined using code instead of manual clicks.

Benefits:

- Automation
- Version Control
- Repeatability
- Collaboration
- Multi-cloud support

---

# ☁️ Multi Cloud Support

Terraform supports multiple providers including:

- AWS
- Azure
- Google Cloud
- OpenStack
- Kubernetes
- Docker

---

# 🔌 Provider

A Provider acts as a bridge between Terraform and a cloud platform.

Flow:

```text
Terraform Code
      │
      ▼
AWS Provider
      │
      ▼
AWS APIs
      │
      ▼
AWS Resources
```

---

# 📝 HCL (HashiCorp Configuration Language)

Terraform uses **HCL** to describe infrastructure.

Example:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}
```

---

# ⚙️ AWS CLI Configuration

Installed AWS CLI and configured credentials using:

```bash
aws configure
```

Terraform uses these credentials to authenticate with AWS.

---

# 📄 First Terraform Configuration

Created `main.tf`:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
}
```

---

# 🔄 Terraform Workflow

```text
Write Code
     │
     ▼
terraform init
     │
Download Provider
     │
     ▼
terraform plan
     │
Preview Changes
     │
     ▼
terraform apply
     │
Create Infrastructure
     │
     ▼
terraform destroy
     │
Delete Infrastructure
```

---

# 📦 terraform init

Purpose:

- Initializes the working directory
- Downloads provider plugins
- Creates `.terraform/`
- Creates `.terraform.lock.hcl`

---

# 📋 terraform plan

Purpose:

- Compares desired state with current state
- Shows changes before applying
- Does not create resources

Example output:

```
Plan: 1 to add, 0 to change, 0 to destroy
```

---

# 🚀 terraform apply

Purpose:

- Creates infrastructure
- Calls AWS APIs through the AWS Provider
- Updates Terraform State

---

# 💥 terraform destroy

Purpose:

- Deletes infrastructure managed by Terraform
- Reads `terraform.tfstate`
- Calls AWS APIs to remove resources

---

# 📂 Terraform State

Terraform stores infrastructure details in:

```
terraform.tfstate
```

State contains:

- EC2 ID
- Public IP
- Private IP
- ARN
- Volume IDs
- Network Interface IDs

Terraform uses this file to determine future changes.

> Never edit the state file manually.

---

# ⚠️ Errors Faced

## 1. Invalid AMI ID

Cause:

Old AMI used in the tutorial no longer existed.

Solution:

Used the latest Ubuntu AMI available in `us-east-1`.

---

## 2. Instance Type Error

Cause:

`t2.micro` wasn't eligible for the account.

Solution:

Changed to `t3.micro`.

---

# 📁 Files Generated

```text
main.tf
terraform.tfstate
terraform.tfstate.backup
.terraform/
.terraform.lock.hcl
```

---

# 📚 Commands Learned

```bash
terraform version
terraform init
terraform plan
terraform apply
terraform destroy
```

---

# 💡 Key Learnings

- Terraform uses HCL.
- Provider communicates with cloud APIs.
- `terraform init` downloads providers.
- `terraform plan` previews changes.
- `terraform apply` creates infrastructure.
- `terraform destroy` removes infrastructure.
- Terraform tracks infrastructure using `terraform.tfstate`.

---

# 🎯 Interview Questions

### What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to provision and manage infrastructure using code.

---

### What is a Provider?

A Provider enables Terraform to communicate with cloud platforms using their APIs.

---

### Difference between `plan` and `apply`?

- `plan` previews changes.
- `apply` executes the changes.

---

### What is Terraform State?

Terraform State is a JSON file that stores the current state of managed infrastructure.

---

### What does `terraform destroy` do?

Deletes infrastructure managed by Terraform using information stored in the state file.
