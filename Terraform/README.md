# Terraform - Zero to Hero 🚀

This repository documents my complete Terraform learning journey, including hands-on labs, interview notes, best practices, and production-ready examples.

---

# 📚 Learning Roadmap

## ✅ 01 - Getting Started

### Topics Covered

- What is Infrastructure?
- Infrastructure as Code (IaC)
- Why Terraform?
- Terraform Architecture
- HashiCorp Configuration Language (HCL)
- Providers
- Terraform Installation
- AWS CLI Configuration
- First EC2 using Terraform
- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`
- Terraform State (`terraform.tfstate`)

---

## ✅ 02 - Providers and Variables

### Providers

- Provider Basics
- AWS Provider
- Provider Block
- Multi-Region Providers
- Provider Alias
- Multi-Cloud Providers

### Resources

- Resource Block
- Resource Type
- Resource Name
- Resource Attributes

### Variables

- Input Variables
- Default Values
- Required Variables
- `terraform.tfvars`
- Variable Precedence
- CLI Variables
- Interactive Variables

### Outputs

- Output Block
- Resource Attributes
- Instance ID
- Public IP
- Private IP
- Public DNS

---

## ✅ 03 - Expressions & Functions

### Expressions

- String Interpolation
- Arithmetic Expressions
- Logical Expressions
- Conditional Expressions (Ternary Operator)

### Functions

- String Functions
- Numeric Functions
- Collection Functions
- Encoding Functions

### Locals

- Local Values (`locals`)
- Reusable Expressions
- Centralized Configuration

### Terraform Console

- Evaluating Expressions
- Testing Functions
- Interactive Debugging

---

## ✅ 04 - Modules

### Module Basics

- What are Modules?
- Root Module
- Child Module
- Module Structure
- Variables
- Outputs

### Custom Modules

- EC2 Module
- Reusable Infrastructure
- Module Inputs & Outputs

### Terraform Registry

- Public Modules
- Version Pinning
- Registry Best Practices

---

## ✅ 05 - Backend

### Terraform State

- Desired State vs Current State
- Terraform State File
- State Management

### Backends

- Local Backend
- Remote Backend
- Amazon S3 Backend
- Backend Initialization
- Backend Migration

### State Locking

- Race Conditions
- DynamoDB State Locking
- Lock Lifecycle
- `terraform init -reconfigure`
- `terraform plan` Locking
- `terraform apply` Locking
- Native S3 Lockfiles (`use_lockfile`)
- Legacy DynamoDB Locking (`dynamodb_table`)

---

# 🚧 Upcoming Topics

- Workspaces
- Data Sources
- Lifecycle Meta Arguments
- Provisioners
- Remote State
- Import Existing Infrastructure
- Dependency Management
- Terraform Cloud
- Projects & Real-world Architectures

---

# 🎯 Skills Covered

- Infrastructure as Code (IaC)
- AWS Infrastructure Provisioning
- Terraform State Management
- Remote State with Amazon S3
- State Locking
- Terraform Modules
- Variables & Outputs
- Expressions & Functions
- Multi-Region Deployments
- Multi-Cloud Provider Basics
- Production Best Practices

---

# 📁 Repository Structure

```text
Terraform/
│
├── 01-Getting-Started/
├── 02-Providers-and-Variables/
├── 03-Expressions-and-Functions/
├── 04-Modules/
├── 05-Backend/
│
└── README.md
```

---

## ⭐ Repository Goal

This repository is built as a **complete Terraform learning resource**, covering concepts from beginner to advanced with:

- 📖 Concept explanations
- 🛠️ Hands-on labs
- 💼 Interview questions
- 🏗️ Production best practices
- 🚀 Real-world examples
