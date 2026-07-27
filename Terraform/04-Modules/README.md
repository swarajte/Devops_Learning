# Terraform Modules

## 📖 Overview

As Terraform projects grow, writing all infrastructure in a single `main.tf` file becomes difficult to manage. Resources get duplicated, files become larger, and maintaining the infrastructure becomes challenging.

Terraform **Modules** solve this problem by allowing us to write infrastructure once and reuse it multiple times.

A module is nothing but a **reusable collection of Terraform configuration files**.

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

Without modules, we would write the same Terraform code for every application.

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

This leads to:

- Duplicate code
- Difficult maintenance
- Large Terraform files
- Higher chances of mistakes

Instead, we create the infrastructure once inside a module and reuse it.

---

# What is a Terraform Module?

A **Terraform Module** is a reusable collection of Terraform configuration files that creates a logical piece of infrastructure.

A module can contain:

- Resources
- Variables
- Outputs
- Locals

The same module can be used multiple times by passing different input values.

---

# Real Life Example

Suppose your company has three applications.

```
Payment Service

Inventory Service

User Service
```

Each application needs one EC2 instance.

Instead of writing EC2 code three times:

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

Then simply call it multiple times.

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

The module code remains the same.

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

# What Do We Write Inside a Module?

A module contains everything required to create a logical infrastructure component.

Example:

```
EC2 Module

├── Security Group

├── EC2 Instance

├── IAM Role

└── EBS Volume
```

These resources together create one complete EC2 server.

Similarly,

```
VPC Module

├── VPC

├── Public Subnet

├── Private Subnet

├── Internet Gateway

├── NAT Gateway

└── Route Tables
```

Notice that a module represents a **logical component**, not necessarily a single AWS resource.

---

# Module Communication

Modules communicate with the root module using:

## 1. Variables (Input)

Variables receive values from the root module.

Example:

```hcl
module "ec2_instance" {

  source = "./modules/ec2_instance"

  ami_value = "ami-xxxxxxxx"

  instance_type_value = "t3.micro"

}
```

Inside the module:

```hcl
variable "ami_value" {}

variable "instance_type_value" {}
```

---

## 2. Resources

Resources create the actual infrastructure.

Example:

```hcl
resource "aws_instance" "example" {

    ami = var.ami_value

    instance_type = var.instance_type_value

}
```

---

## 3. Outputs

Outputs return useful information back to the root module.

Inside module:

```hcl
output "public_ip_address" {

    value = aws_instance.example.public_ip

}
```

Root module:

```hcl
output "PUBLIC_IP_FOR_EC2" {

    value = module.ec2_instance.public_ip_address

}
```

---

# Module Flow

```
                 Root Module

                      │

               Pass Variables

                      │

                      ▼

                Terraform Module

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

# Hands-on 1 - Basic Module

Created a very simple module.

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

Root module:

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

Purpose:

Understand how Terraform calls a module and retrieves outputs.

---

# Hands-on 2 - EC2 Module

Created a reusable EC2 module.

Module accepts:

- AMI ID
- Instance Type
- Subnet ID

Root module:

```hcl
module "ec2_instance" {

    source = "./modules/ec2_instance"

    ami_value = "ami-xxxxxxxx"

    instance_type_value = "t3.micro"

    subnet_id_value = "subnet-xxxxxxxx"

}
```

Module creates:

- EC2 Instance

Module returns:

- Public IP Address

Output:

```hcl
output "PUBLIC_IP_FOR_EC2" {

    value = module.ec2_instance.public_ip_address

}
```

Successfully created an EC2 instance using a custom Terraform module.

---

# Advantages of Modules

- Code Reusability
- Cleaner Project Structure
- Less Duplicate Code
- Easier Maintenance
- Standardized Infrastructure
- Better Team Collaboration
- Easier Scaling

---

# Best Practices

- Keep modules focused on one logical infrastructure component.
- Use variables for configurable values.
- Return useful values using outputs.
- Avoid hardcoding values inside modules.
- Keep provider configuration in the root module.
- Use meaningful module names.

---

# Key Takeaways

- Modules help reuse Terraform code.
- A module is a reusable collection of Terraform configuration files.
- Modules communicate using Variables and Outputs.
- A module can contain multiple related resources.
- The same module can be used multiple times with different input values.

---

# Interview Questions

### What is a Terraform Module?

A Terraform Module is a reusable collection of Terraform configuration files that creates a logical infrastructure component.

---

### Why do we use Modules?

To reduce duplicate code, improve maintainability, organize infrastructure, and promote reusability.

---

### What can a Module contain?

- Resources
- Variables
- Outputs
- Locals

---

### How does the Root Module communicate with a Child Module?

- Variables → Send data to the module.
- Outputs → Receive data from the module.

---

### Can a Module contain multiple resources?

Yes.

For example, an EC2 module can include:

- Security Group
- EC2 Instance
- IAM Role
- EBS Volume

All of these together represent one logical infrastructure component.

---

# Summary

```
                 Write Once

                Terraform Module

                      │

        Reuse Multiple Times

      Payment     Inventory     User

           Different Input Values

                  Same Module
```
