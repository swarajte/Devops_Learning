# Terraform Backends & State Locking

## 📖 Overview

In this section, we learned one of the most important Terraform concepts used in production environments:

- Local Backend
- Remote Backend
- Amazon S3 Backend
- Terraform State
- Backend Migration
- State Locking
- DynamoDB Locking
- Modern S3 Native Lockfiles

---

# Why do we need a Backend?

Terraform stores information about all managed resources inside a **State File**.

Without a backend, this file is stored locally.

```
terraform.tfstate
```

When working in teams, every engineer would have their own local state file, leading to:

- Stale State
- Inconsistent Infrastructure
- Wrong Execution Plans
- Collaboration Issues

A backend solves this problem by storing the state in a centralized location.

---

# Local Backend

Default backend used by Terraform.

```
terraform.tfstate
```

Stored in the local project directory.

Suitable for:

- Personal learning
- Small projects

Not recommended for production teams.

---

# Remote Backend

A Remote Backend stores the Terraform State remotely.

Popular remote backends include:

- Amazon S3
- Azure Blob Storage
- Google Cloud Storage
- Terraform Cloud
- Consul

Benefits:

- Centralized State
- Team Collaboration
- High Availability
- Better Security
- Versioning Support

---

# Amazon S3 Backend

Backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-swaraj-demo"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
```

---

## Understanding Every Parameter

### bucket

The S3 bucket where Terraform stores the state.

Example:

```
terraform-state-swaraj-demo
```

---

### key

The object path inside the bucket.

Example:

```
dev/terraform.tfstate
```

This allows multiple environments to use the same bucket.

Example:

```
terraform-state

├── dev/
│   └── terraform.tfstate
│
├── qa/
│   └── terraform.tfstate
│
└── prod/
    └── terraform.tfstate
```

---

### region

The AWS Region where the S3 bucket exists.

**Important**

Backend Region does NOT need to match the Provider Region.

---

# Backend Initialization

Whenever backend configuration changes, Terraform must be reinitialized.

Command:

```bash
terraform init -reconfigure
```

This command:

- Reads backend.tf
- Connects to S3
- Verifies bucket exists
- Verifies state exists
- Saves backend configuration locally

No infrastructure changes occur.

---

# Terraform State

Terraform State is Terraform's memory.

It stores:

- Resource IDs
- Public IPs
- Private IPs
- ARNs
- Metadata
- Mapping between Terraform resources and Cloud resources

Terraform compares:

```
Desired State (.tf files)

↓

Current State (terraform.tfstate)

↓

Execution Plan
```

---

# Why doesn't Terraform rely only on AWS APIs?

AWS can tell Terraform **what resources exist**.

It cannot tell Terraform:

> Which resources belong to this Terraform configuration.

Terraform State maintains this mapping.

---

# State Locking

State Locking prevents multiple Terraform operations from modifying the same state simultaneously.

Without locking:

```
Engineer A

↓

Reads State

↓

Engineer B

↓

Reads Same State

↓

Both Modify

↓

State Corruption
```

With locking:

```
Acquire Lock

↓

Read State

↓

Modify Infrastructure

↓

Update State

↓

Release Lock
```

---

# DynamoDB State Locking

Historically, Terraform used DynamoDB to coordinate locking for the S3 backend.

Backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-swaraj-demo"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

Terraform stores:

| Service | Purpose |
|----------|----------|
| Amazon S3 | Terraform State |
| DynamoDB | Lock Information |

---

# DynamoDB Table

Configuration used:

Table Name:

```
terraform-locks
```

Partition Key:

```
LockID
```

Type:

```
String
```

Terraform automatically uses the backend key as the LockID.

Example:

```
terraform-state-swaraj-demo/dev/terraform.tfstate
```

---

# Lock Lifecycle

When running:

```bash
terraform apply
```

Terraform performs:

```
Acquire Lock

↓

Read State

↓

Compare Configuration

↓

Create / Update Infrastructure

↓

Update State

↓

Upload State to S3

↓

Release Lock
```

---

# Does terraform plan acquire a lock?

Yes.

By default:

```
terraform plan
```

also acquires a state lock.

However, it only holds the lock briefly while reading the latest state and generating the execution plan.

```
Acquire Lock

↓

Read State

↓

Generate Plan

↓

Release Lock
```

---

# Real Hands-on Performed

✅ Created S3 Backend

✅ Migrated Terraform State

✅ Created DynamoDB Table

✅ Configured Backend

✅ Ran

```bash
terraform init -reconfigure
```

✅ Executed multiple Terraform commands from different terminals.

Successfully reproduced:

```
Error acquiring the state lock

OperationTypePlan

ConditionalCheckFailedException
```

This demonstrated Terraform's state locking mechanism in action.

---

# Modern Terraform (Important)

Terraform v1.15 introduces native S3 lockfiles.

Instead of:

```hcl
dynamodb_table = "terraform-locks"
```

Terraform now recommends:

```hcl
use_lockfile = true
```

This removes the need for a separate DynamoDB table for new S3 backends.

However, many existing enterprise projects still use DynamoDB-based locking, making it an important concept for interviews and production support.

---

# Best Practices

- Never commit `terraform.tfstate`.
- Store state remotely.
- Enable state locking.
- Enable S3 Versioning for state recovery.
- Restrict access using IAM.
- Keep one state file per environment.
- Commit `.terraform.lock.hcl`.
- Never disable locking in production.

---

# Interview Questions

1. What is a Terraform Backend?
2. Why do we need a Backend?
3. Local Backend vs Remote Backend.
4. Why is Amazon S3 commonly used?
5. What does the `key` parameter represent?
6. What is stored inside Terraform State?
7. Why can't Terraform rely only on AWS APIs?
8. What is State Locking?
9. Why was DynamoDB used with S3?
10. Does `terraform plan` acquire a lock?
11. What is `terraform init -reconfigure`?
12. Why should `terraform.tfstate` never be committed to Git?
13. What is `ConditionalCheckFailedException`?
14. What is the difference between `dynamodb_table` and `use_lockfile`?

---

# Folder Structure

```
05-Backend/
│
├── backend.tf
├── main.tf
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```
