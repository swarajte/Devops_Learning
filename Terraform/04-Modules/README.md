# Terraform Modules

## 📖 Overview

As Terraform projects grow, writing all infrastructure in a single `main.tf` file becomes difficult to manage. Resources get duplicated, files become larger, and maintaining the infrastructure becomes challenging.

Terraform **Modules** solve this problem by allowing us to write infrastructure once and reuse it multiple times.

A **Terraform Module** is a reusable collection of Terraform configuration files that creates a logical piece of infrastructure.

---

# Why Do We Need Modules?

Imagine a company has multiple applications.

```
Application 1
Application 2
Application 3
```

Every application requires:

- EC2 Instance
- Security Group
- IAM Role

Without modules, we would write the same Terraform code repeatedly.

```
Application 1
--------------
EC2
Security Group
IAM Role

Application 2
--------------
EC2
Security Group
IAM Role

Application 3
--------------
EC2
Security Group
IAM Role
```

Problems:

- Duplicate code
- Difficult maintenance
- Large Terraform files
- Higher chances of mistakes

Instead, create the infrastructure once inside a module and reuse it.

---

# What is a Terraform Module?

A **Terraform Module** is a reusable collection of Terraform configuration files.

A module can contain:

- Resources
- Variables
- Outputs
- Locals

The same module can be reused multiple times by passing different input values.

---

# Real-Life Example

Suppose your company has three applications.

```
Payment Service

Inventory Service

User Service
```

Each application requires an EC2 instance.

Instead of writing the same code three times:

```
EC2
EC2
EC2
```

Create one reusable module.

```
modules/

└── ec2/
```

Then use it multiple times.

```hcl
module "payment" {
  source = "./modules/ec2"
  instance_name = "payment-server"
}

module "inventory" {
  source = "./modules/ec2"
  instance_name = "inventory-server"
}

module "user" {
  source = "./modules/ec2"
  instance_name = "user-server"
}
```

Only the input values change.

---

# Module Folder Structure

```
Terraform/

├── main.tf

└── modules/

    └── ec2/

        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# What Does a Module Contain?

A module represents a **logical infrastructure component**.

Example:

```
EC2 Module

├── EC2 Instance
├── Security Group
├── IAM Role
└── EBS Volume
```

Another example:

```
VPC Module

├── VPC
├── Public Subnets
├── Private Subnets
├── Internet Gateway
├── NAT Gateway
└── Route Tables
```

A module does **not** have to represent a single AWS resource.

---

# Module Communication

Terraform modules communicate using **Variables** and **Outputs**.

## Variables (Inputs)

The Root Module passes values into the Child Module.

```hcl
module "ec2_instance" {

  source = "./modules/ec2_instance"

  ami_value           = "ami-xxxxxxxx"
  instance_type_value = "t3.micro"

}
```

Inside the module:

```hcl
variable "ami_value" {}

variable "instance_type_value" {}
```

---

## Resources

Resources create the infrastructure.

```hcl
resource "aws_instance" "example" {

  ami           = var.ami_value
  instance_type = var.instance_type_value

}
```

---

## Outputs

Outputs send values back to the Root Module.

Inside module:

```hcl
output "public_ip_address" {

  value = aws_instance.example.public_ip

}
```

Root Module:

```hcl
output "PUBLIC_IP_FOR_EC2" {

  value = module.ec2_instance.public_ip_address

}
```

---

# Module Communication Flow

```
            Root Module

                 │

          Pass Variables

                 │

                 ▼

           Child Module

                 │

      Creates Infrastructure

                 │

                 ▼

          Returns Outputs

                 │

                 ▼

            Root Module
```

---

# Hands-on 1 – Basic Module

Created a simple module.

```
modules/

└── greeting/

    └── main.tf
```

Module:

```hcl
output "message" {

  value = "Hello from Module!"

}
```

Root Module:

```hcl
module "greeting" {

  source = "./modules/greeting"

}

output "module_message" {

  value = module.greeting.message

}
```

Output:

```
Hello from Module!
```

---

# Hands-on 2 – Custom EC2 Module

Created a reusable EC2 module.

Inputs:

- AMI ID
- Instance Type
- Subnet ID

```hcl
module "ec2_instance" {

  source = "./modules/ec2_instance"

  ami_value           = "ami-xxxxxxxx"
  instance_type_value = "t3.micro"
  subnet_id_value     = "subnet-xxxxxxxx"

}
```

Output:

```hcl
output "PUBLIC_IP_FOR_EC2" {

  value = module.ec2_instance.public_ip_address

}
```

Successfully launched an EC2 instance using a custom Terraform module.

---

# Terraform Registry Modules

Writing your own modules is useful, but many common infrastructure components are already available on the **Terraform Registry**.

Terraform Registry is an online repository of reusable Terraform modules maintained by HashiCorp, cloud providers, and the community.

Instead of creating your own EC2 module:

```hcl
source = "./modules/ec2"
```

You can use a Registry Module:

```hcl
source = "terraform-aws-modules/ec2-instance/aws"
```

---

# How Registry Modules Work

When you run:

```bash
terraform init
```

Terraform:

1. Reads the module source.
2. Connects to the Terraform Registry.
3. Downloads the module.
4. Stores it locally.
5. Uses the local copy during `terraform plan` and `terraform apply`.

```
Terraform Registry

        │

        ▼

terraform init

        │

        ▼

Downloads Module

        │

        ▼

.terraform/modules/

        │

        ▼

terraform plan / apply
```

Registry modules are downloaded only once (unless the version changes or you reinitialize).

Terraform executes the **local downloaded copy**, not the code directly from the internet.

---

# Local Module vs Registry Module

| Local Module | Registry Module |
|--------------|-----------------|
| Created by us | Created by the community |
| Stored inside the project | Downloaded automatically |
| `source = "./modules/ec2"` | `source = "terraform-aws-modules/ec2-instance/aws"` |
| We maintain it | Community maintains it |

---

# Hands-on 3 – Registry Module

Used the official EC2 Registry Module.

```hcl
module "ec2" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "terraform-registry-demo"

  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
  subnet_id     = "subnet-xxxxxxxx"

}
```

During `terraform init`:

- Module downloaded from Terraform Registry.
- Stored inside:

```
.terraform/modules/
```

During `terraform plan`:

Terraform automatically planned:

- EC2 Instance
- Security Group
- IPv4 Egress Rule
- IPv6 Egress Rule

Even though only a few input values were provided.

This demonstrates how Registry Modules encapsulate complex infrastructure behind a simple interface.

---

# Module Lifecycle

```
            Write Module Call

                  │

                  ▼

          terraform init

                  │

                  ▼

Download Module from Registry

                  │

                  ▼

      .terraform/modules/

                  │

                  ▼

Read:

• main.tf
• variables.tf
• outputs.tf

                  │

                  ▼

terraform plan

                  │

                  ▼

terraform apply

                  │

                  ▼

Infrastructure Created
```

---

# Advantages of Modules

- Code Reusability
- Cleaner Project Structure
- Easier Maintenance
- Standardized Infrastructure
- Better Team Collaboration
- Less Duplicate Code
- Easier Scaling
- Faster Development using Registry Modules

---

# Best Practices

- Keep modules focused on one logical infrastructure component.
- Keep provider configuration in the Root Module.
- Use variables instead of hardcoded values.
- Return useful values using outputs.
- Use meaningful module names.
- Version pin Registry Modules.
- Prefer well-maintained Registry Modules for common infrastructure.

---

# Key Takeaways

- A Terraform Module is a reusable collection of Terraform configuration files.
- Modules communicate using Variables and Outputs.
- Modules represent logical infrastructure components.
- Local Modules are written and maintained by your team.
- Registry Modules are downloaded automatically from the Terraform Registry.
- Registry Modules are stored locally inside `.terraform/modules`.
- Terraform executes the downloaded local copy during `plan` and `apply`.

---

# Interview Questions

### What is a Terraform Module?

A reusable collection of Terraform configuration files that creates a logical infrastructure component.

---

### Why do we use Modules?

To improve reusability, reduce duplicate code, simplify maintenance, and organize infrastructure.

---

### What can a Module contain?

- Resources
- Variables
- Outputs
- Locals

---

### How do Root Modules communicate with Child Modules?

- Variables → Send data into the module.
- Outputs → Receive data from the module.

---

### What is Terraform Registry?

Terraform Registry is an online repository of reusable Terraform modules maintained by HashiCorp and the community.

---

### What happens during `terraform init` for Registry Modules?

Terraform downloads the module from the Registry into `.terraform/modules` and uses the downloaded copy during `terraform plan` and `terraform apply`.

---

### Where are Registry Modules stored?

```
.terraform/modules/
```

---

### Why should we pin module versions?

To ensure consistent, predictable deployments and avoid unexpected behavior caused by newer module releases.

---

# Summary

```
                  Write Once

               Terraform Module

                     │

     ┌───────────────┴───────────────┐

     ▼                               ▼

 Local Module                 Registry Module

 Written by Us           Downloaded from Registry

     │                               │

     └───────────────┬───────────────┘

                     ▼

            Reuse Everywhere

        Different Inputs

             Same Module
```
