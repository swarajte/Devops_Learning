# Providers, Resources, Variables & Outputs

This section covers the core building blocks of every Terraform project.

---

# Folder Structure

```
02-Providers-and-Variables/

├── 01-Basic-Provider/
├── 02-Multi-Region/
├── 03-Multi-Cloud/
├── 04-Variables/
└── screenshots/
```

---

# Topics Covered

## 1. Providers

- What is a Provider?
- Provider Block
- AWS Provider
- Provider Plugins
- Terraform → Provider → Cloud API

### Multi Region

- Provider Alias
- Using Multiple AWS Regions
- Resource-Level Provider Selection

### Multi Cloud

- AWS Provider
- Azure Provider
- How Terraform supports multiple cloud providers

---

## 2. Resources

Covered

- Resource Block
- Resource Type
- Resource Name
- Resource Attributes

Example

```hcl
resource "aws_instance" "demo" {}
```

---

## 3. Variables

Covered

- Input Variables
- Variable Types
- Default Values
- Required Variables
- terraform.tfvars
- Interactive Variables
- CLI Variables

Example

```hcl
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
```

---

## 4. Outputs

Covered

- Output Block
- Resource Attributes
- Printing Resource Information

Example

```hcl
output "instance_id" {
  value = aws_instance.demo.id
}
```

---

# Hands-on Performed

- Created EC2 using Variables
- Used terraform.tfvars
- Used Required Variables
- Used Default Variables
- Passed Variables using CLI
- Interactive Variable Input
- Updated EC2 Instance Type
- Observed In-place Update (~)
- Created Outputs
- Printed EC2 Instance ID

---

# Interview Questions Covered

- What is a Provider?
- What is a Resource?
- Difference between Provider and Resource
- Multi Region vs Multi Cloud
- What are Variables?
- Variable Types
- terraform.tfvars
- Required vs Default Variables
- What are Outputs?
- Difference between Variables and Outputs

---

# Key Learnings

- Terraform automatically loads every `.tf` file in the working directory.
- File names such as `provider.tf`, `variables.tf`, `main.tf`, and `outputs.tf` are for organization only.
- Providers communicate with cloud APIs.
- Resources define infrastructure.
- Variables pass values into Terraform.
- Outputs expose values from Terraform after deployment.
