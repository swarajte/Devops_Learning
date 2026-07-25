# Expressions and Functions

## 📌 Overview

In the previous chapter, we learned about Providers, Resources, Variables, and Outputs.

In this chapter, we learned how Terraform performs calculations and makes decisions before creating infrastructure.

This chapter covers:

- Expressions
- Terraform Console
- Built-in Functions
- Conditional Expressions
- Locals

These concepts are used in almost every Terraform project.

---

# 1. Expressions

## What is an Expression?

An expression is anything Terraform evaluates to produce a value.

The returned value can be:

- String
- Number
- Boolean
- List
- Map
- Object

### Examples

```hcl
5 + 5

true

"Terraform"

var.instance_type

aws_instance.demo.public_ip
```

Every example above returns a value, making it an expression.

### Why are Expressions Important?

Expressions are used throughout Terraform.

Examples include:

- Resource arguments
- Variables
- Outputs
- Functions
- Conditional Expressions
- Locals
- count
- for_each

Everything in Terraform revolves around expressions.

---

# 2. Terraform Console

Terraform provides an interactive shell called the Terraform Console.

```bash
terraform console
```

It allows us to evaluate expressions without creating infrastructure.

Example:

```hcl
> 5 + 5
10

> upper("terraform")
"TERRAFORM"

> length("Terraform")
9
```

### Benefits

- Test expressions
- Learn Terraform interactively
- Verify functions
- Debug values

---

# 3. Functions

## What are Functions?

Functions are built-in helpers provided by Terraform.

A function accepts one or more arguments, performs an operation, and returns a value.

General syntax:

```hcl
function_name(argument)
```

---

## String Functions

### upper()

Converts text to uppercase.

```hcl
upper("terraform")
```

Output

```text
TERRAFORM
```

---

### lower()

```hcl
lower("AWS")
```

Output

```text
aws
```

---

### title()

Capitalizes each word.

```hcl
title("terraform learning")
```

Output

```text
Terraform Learning
```

---

### replace()

```hcl
replace("terraform","terra","cloud")
```

Output

```text
cloudform
```

---

### trimspace()

```hcl
trimspace("     hello     ")
```

Output

```text
hello
```

---

## Numeric Functions

### max()

Returns the largest number.

```hcl
max(10,50,90,3)
```

Output

```text
90
```

---

### min()

Returns the smallest number.

```hcl
min(10,50,90,3)
```

Output

```text
3
```

---

### abs()

Returns the absolute value.

```hcl
abs(-100)
```

Output

```text
100
```

---

## List Functions

### length()

Returns the number of elements.

```hcl
length([
"EC2",
"S3",
"IAM"
])
```

Output

```text
3
```

---

### join()

Joins list items into a single string.

```hcl
join(",",["EC2","S3","IAM"])
```

Output

```text
EC2,S3,IAM
```

---

### split()

Splits a string into a list.

```hcl
split(",", "EC2,S3,IAM")
```

Output

```text
[
"EC2",
"S3",
"IAM"
]
```

---

# 4. Conditional Expressions

Terraform can make decisions using conditional expressions.

Syntax:

```hcl
condition ? value_if_true : value_if_false
```

Example:

```hcl
5 > 3 ? "Yes" : "No"
```

Output

```text
Yes
```

---

## Real World Example

Development servers don't require large instance types.

Production servers require larger instances.

```hcl
instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
```

If

```text
environment = "dev"
```

Result

```text
t3.micro
```

If

```text
environment = "prod"
```

Result

```text
t3.large
```

Conditional expressions help us write a single Terraform configuration that behaves differently for different environments.

---

# 5. Locals

## What are Locals?

Locals are internal values defined within Terraform.

Unlike variables, locals are not provided by the user.

They are created to avoid repeating the same values throughout the configuration.

Syntax:

```hcl
locals {

  project = "expense-app"

}
```

Usage:

```hcl
local.project
```

Notice:

Definition uses

```hcl
locals
```

Usage uses

```hcl
local
```

---

## Why Use Locals?

Instead of writing

```hcl
Project = "expense-app"
```

inside every resource,

store it once.

```hcl
locals {

project = "expense-app"

}
```

Then use

```hcl
Project = local.project
```

If the project name changes, only one place needs updating.

---

## Locals Can Use Variables

```hcl
locals {

instance_name = "${var.environment}-${var.project_name}-server"

}
```

If

```text
environment = dev

project_name = expense-app
```

Result

```text
dev-expense-app-server
```

---

## Locals Can Use Functions

```hcl
locals {

project_upper = upper(var.project_name)

}
```

Output

```text
EXPENSE-APP
```

---

## Locals Can Use Conditional Expressions

```hcl
locals {

instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

}
```

This combines variables, functions, expressions, and conditionals.

---

# Variables vs Locals

| Variables | Locals |
|------------|---------|
| Input from user | Internal value |
| Defined in variables.tf | Defined in locals block |
| User provides value | Terraform computes or stores value |
| Used for customization | Used for reuse and cleaner code |

---

# Hands-on

Created files:

```
05-Hands-On/

├── main.tf
├── variables.tf
├── terraform.tfvars
├── locals.tf
├── terraform.tfstate
└── terraform.tfstate.backup
```

### variables.tf

```hcl
variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}
```

---

### terraform.tfvars

```hcl
environment = "dev"

project_name = "expense-app"
```

---

### locals.tf

```hcl
locals {

  instance_name = "${var.environment}-${var.project_name}-server"

  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

  owner = var.environment == "prod" ? "DevOps Team" : "Developers"

  project_upper = upper(var.project_name)

  is_production = var.environment == "prod"

}
```

---

### main.tf

```hcl
output "instance_name" {
  value = local.instance_name
}

output "instance_type" {
  value = local.instance_type
}

output "owner" {
  value = local.owner
}

output "project_upper" {
  value = local.project_upper
}

output "is_production" {
  value = local.is_production
}
```

---

### Output (Development)

```text
instance_name = "dev-expense-app-server"

instance_type = "t3.micro"

owner = "Developers"

project_upper = "EXPENSE-APP"

is_production = false
```

---

### Output (Production)

```text
instance_name = "prod-expense-app-server"

instance_type = "t3.large"

owner = "DevOps Team"

project_upper = "EXPENSE-APP"

is_production = true
```

---

# Key Takeaways

- Expressions are anything Terraform evaluates to produce a value.
- Functions are built-in helpers that transform values.
- Conditional expressions allow Terraform to make decisions.
- Locals store reusable internal values.
- Locals reduce duplication and improve readability.
- Variables provide input, locals compute reusable values, and outputs expose final values.
- Terraform Console is a great tool for experimenting with expressions and functions.

---

# Interview Questions

### 1. What is an expression in Terraform?

Anything Terraform evaluates to produce a value.

---

### 2. What is the purpose of Terraform Console?

It provides an interactive environment to test expressions and functions without creating infrastructure.

---

### 3. What are Terraform Functions?

Built-in helper functions that accept input values, perform operations, and return computed values.

---

### 4. Can we create custom functions in Terraform?

No. Terraform only supports built-in functions.

---

### 5. What is the syntax of a conditional expression?

```hcl
condition ? value_if_true : value_if_false
```

---

### 6. What are Locals?

Reusable internal values defined inside Terraform to reduce duplication.

---

### 7. Difference between Variables and Locals?

Variables are user inputs.

Locals are internal reusable values.

---

# Summary

```
User Input (Variables)
        │
        ▼
Expressions
        │
        ▼
Functions
        │
        ▼
Conditional Expressions
        │
        ▼
Locals
        │
        ▼
Resources / Outputs
        │
        ▼
Infrastructure
```

This flow represents how Terraform processes input values before provisioning infrastructure.
