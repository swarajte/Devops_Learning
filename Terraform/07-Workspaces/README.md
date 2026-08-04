# Terraform Workspaces 🚀

## 📅 Date

04 August 2026

---

# 🎯 Goal

Learn how Terraform Workspaces help manage multiple environments using the **same Terraform configuration** while keeping their infrastructure isolated through **separate state files**.

We also explored how Workspaces behave with:

- Local Backend
- Remote S3 Backend
- Native S3 State Locking (`use_lockfile = true`)

---

# 📚 Topics Covered

- What are Terraform Workspaces?
- Why Workspaces are needed
- Local Backend vs Remote Backend
- State Isolation
- `terraform.workspace`
- Workspace Commands
- Workspaces with S3 Backend
- Native S3 Locking (`use_lockfile`)
- Backend Reinitialization
- State Migration
- Best Practices

---

# ❓ Problem Statement

Suppose an application has three environments:

```text
Developer
    │
   DEV

QA Team
    │
  TEST

Customers
    │
  PROD
```

Terraform configuration:

```hcl
resource "aws_instance" "server" {

  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t3.micro"

}
```

Question:

How many EC2 instances will Terraform create?

**Answer:** Only **one**, because Terraform doesn't know which environment (Dev/Test/Prod) it should create resources for.

---

# ❌ Wrong Approach

Creating separate Terraform projects:

```text
terraform/

├── dev/
│     main.tf
│
├── test/
│     main.tf
│
└── prod/
      main.tf
```

Problems:

- Duplicate code
- Difficult maintenance
- High chance of configuration drift
- Any change must be repeated in every folder

---

# ✅ Better Approach

Keep only one Terraform configuration.

```text
terraform/

main.tf
variables.tf
outputs.tf
```

Then switch between environments using **Workspaces**.

---

# 🧠 What is a Terraform Workspace?

A **Terraform Workspace** is a feature that allows multiple **isolated state files** while reusing the **same Terraform configuration**.

Each workspace manages its own infrastructure independently.

---

# 💡 ELI5

Imagine one notebook.

```text
Notebook

├── DEV Section
├── TEST Section
└── PROD Section
```

Notebook = Terraform Configuration

Sections = Workspaces

Notes inside each section = Terraform State

Same notebook.

Different sections.

---

# 🧠 Key Idea

Terraform configuration remains the same.

Only the **State File** changes.

```text
               main.tf
                  │
                  │
      ┌───────────┼───────────┐
      ▼           ▼           ▼
    DEV         TEST        PROD
      │           │           │
 terraform.tfstate terraform.tfstate terraform.tfstate
```

---

# Why Separate State?

Terraform State stores:

- Resource IDs
- Public IPs
- Metadata
- Current Infrastructure

Without separate state files Terraform cannot distinguish between environments.

---

# Local Backend

State storage:

```text
terraform.tfstate

terraform.tfstate.d/
    ├── dev/
    │     terraform.tfstate
    │
    └── prod/
          terraform.tfstate
```

---

# S3 Backend

When using an S3 backend:

```text
terraform-workspace-bucket

terraform.tfstate

env:/
    ├── dev/
    │      terraform.tfstate
    │
    └── prod/
           terraform.tfstate
```

Important:

- `default` workspace uses the configured `key`
- Other workspaces automatically use:

```text
env:/<workspace>/terraform.tfstate
```

---

# Built-in Variable

Terraform provides a built-in variable:

```hcl
terraform.workspace
```

Returns the current workspace name.

Example:

```hcl
resource "aws_instance" "server" {

  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t3.micro"

  tags = {
      Name = terraform.workspace
  }

}
```

Current workspace:

```text
dev
```

Terraform automatically converts:

```text
Name = terraform.workspace
```

to

```text
Name = dev
```

Switch workspace:

```text
prod
```

Now Terraform creates:

```text
Name = prod
```

No code changes required.

---

# Workspace Commands

## List Workspaces

```bash
terraform workspace list
```

---

## Current Workspace

```bash
terraform workspace show
```

---

## Create Workspace

```bash
terraform workspace new dev
```

---

## Switch Workspace

```bash
terraform workspace select dev
```

---

## Delete Workspace

```bash
terraform workspace delete dev
```

---

# Hands-on Performed

## Created DEV Workspace

```bash
terraform workspace new dev
```

Created EC2:

```text
Tag

Name = dev
```

---

## Switched to Default Workspace

```bash
terraform workspace select default
```

Created another EC2:

```text
Tag

Name = default
```

Result:

Two EC2 instances

Each managed independently by its own state.

---

# Backend Configuration

Configured Remote Backend:

```hcl
terraform {

  backend "s3" {

    bucket = "terraform-workspace-bucket-swaraj"

    key = "terraform.tfstate"

    region = "us-east-1"

    use_lockfile = true

  }

}
```

---

# use_lockfile = true

Instead of DynamoDB,

Terraform now supports native S3 state locking.

During:

```bash
terraform apply
```

Terraform creates:

```text
terraform.tfstate.tflock
```

After Apply:

Lock file is automatically removed.

Benefits:

- No DynamoDB required
- Simpler setup
- Native S3 locking
- Recommended for new S3 backend configurations

---

# Backend Initialization

Whenever backend configuration changes:

```bash
terraform init
```

---

## Reconfigure Backend

```bash
terraform init -reconfigure
```

Used when:

- Bucket changes
- Region changes
- Backend configuration changes

Reconfigures backend without migrating state.

---

## Migrate Existing State

```bash
terraform init -migrate-state
```

Moves state from:

```text
Local Backend

↓

Remote Backend
```

---

# State Isolation

Workspace:

```text
default
```

State:

```text
terraform.tfstate
```

Workspace:

```text
dev
```

State:

```text
env:/dev/terraform.tfstate
```

Each workspace manages only its own resources.

---

# Important Learning

`terraform destroy`

✅ Deletes resources

❌ Does NOT delete workspace

Workspace must be deleted separately:

```bash
terraform workspace delete dev
```

---

# Local vs Remote Backend

| Local Backend | Remote Backend |
|--------------|----------------|
| State stored locally | State stored in S3 |
| Suitable for learning | Suitable for teams |
| Difficult collaboration | Shared state |
| No central storage | Centralized storage |
| Risk of losing state | Highly durable |

---

# Best Practices

- Keep one Terraform configuration.
- Use Workspaces for environment isolation.
- Store state remotely using S3.
- Enable Versioning on S3 Bucket.
- Use `use_lockfile = true` for state locking.
- Never commit Terraform State files to GitHub.
- Separate backend configuration into `backend.tf`.

---

# Project Structure

```text
07-Workspaces/

├── backend.tf
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

---

# Interview Questions

### What is a Terraform Workspace?

A Terraform Workspace allows multiple isolated state files to be managed using the same Terraform configuration.

---

### Why do we use Workspaces?

To manage multiple environments (Dev/Test/Prod) without duplicating Terraform code.

---

### What changes between Workspaces?

Only the Terraform State changes.

Terraform configuration remains the same.

---

### What does `terraform.workspace` return?

Returns the name of the currently selected workspace.

---

### Where are workspace states stored in an S3 backend?

Default Workspace:

```text
terraform.tfstate
```

Other Workspaces:

```text
env:/<workspace>/terraform.tfstate
```

---

### Does `terraform destroy` delete the workspace?

No.

It only destroys infrastructure.

Workspace must be deleted manually.

---

# Key Takeaways

- Workspaces isolate Terraform State, not Terraform code.
- Same configuration can be reused across multiple environments.
- `terraform.workspace` dynamically returns the current workspace.
- Default workspace stores state at the configured S3 key.
- Other workspaces use `env:/<workspace>/terraform.tfstate`.
- `use_lockfile = true` provides native S3 state locking.
- `terraform destroy` removes resources but not the workspace.

---

# 🚀 Final One-Line Summary

> **Terraform Workspaces allow the same Terraform configuration to manage multiple isolated environments by maintaining separate state files for each workspace. Combined with an S3 backend and native S3 locking, they provide a scalable and production-ready way to manage infrastructure across environments.**
