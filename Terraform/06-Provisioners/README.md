# Terraform Provisioners

## 📖 Overview

Terraform is primarily an **Infrastructure Provisioning Tool**.

Its main responsibility is to:

- Create Infrastructure
- Modify Infrastructure
- Destroy Infrastructure

Examples:

- EC2
- VPC
- Subnets
- Security Groups
- S3 Buckets
- IAM Roles

However, sometimes after creating infrastructure, we need to perform a few additional tasks.

For example,

After creating an EC2 instance, we may want to:

- Install Python
- Install Nginx
- Install Apache
- Copy application files
- Execute shell commands
- Configure the server

These post-creation tasks are performed using **Provisioners**.

> **Note:** Provisioners should be considered a **last resort**. Terraform is designed to provision infrastructure, not perform configuration management. For complex server configuration or application deployment, tools like **Ansible**, **cloud-init/User Data**, **AWS Systems Manager (SSM)**, or CI/CD pipelines are generally preferred.

---

# What are Provisioners?

Provisioners are used to execute scripts or commands **before or after** resource creation.

They help automate small configuration tasks on local or remote machines.

---

# Why Do We Need Provisioners?

Imagine Terraform creates an EC2 instance.

```
terraform apply

↓

EC2 Created
```

The EC2 is empty.

There is:

- No Python application
- No Nginx
- No Apache
- No Flask

If your application requires additional software, Terraform alone does not install it.

Provisioners help automate these post-provisioning tasks.

---

# Types of Provisioners

Terraform provides multiple provisioners.

The ones covered are:

- local-exec
- file
- remote-exec

---

# local-exec Provisioner

## What is local-exec?

The `local-exec` provisioner executes commands on the **machine where Terraform is running**, **not** on the remote EC2 instance.

Think of it as:

```
Terraform Machine

↓

Execute Command

↓

Done
```

---

## Use Cases

- Save Public IP to a file
- Trigger a shell script
- Call another program
- Send notifications
- Execute local automation

---

## Example

```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip} > public_ip.txt"
}
```

After `terraform apply`:

```
public_ip.txt

↓

54.xxx.xxx.xxx
```

This file is created on your **local machine**, not on the EC2.

---

# remote-exec Provisioner

## What is remote-exec?

`remote-exec` executes commands **inside the remote EC2 instance** after Terraform successfully connects via SSH.

Think of it as:

```
Terraform Machine

↓

SSH

↓

Ubuntu EC2

↓

Execute Commands
```

Typical tasks include:

- Install software
- Update packages
- Start services
- Configure applications

---

# File Provisioner

## What is the File Provisioner?

The File Provisioner copies files from the **local machine** to the **remote EC2 instance**.

Example:

```
Local Machine

app.py

↓

File Provisioner

↓

EC2

/home/ubuntu/app.py
```

This is similar to running:

```bash
scp app.py ubuntu@<public-ip>:/home/ubuntu/
```

---

# Local vs Remote Provisioners

| local-exec | remote-exec |
|------------|-------------|
| Runs on the Terraform machine | Runs on the EC2 instance |
| Executes local commands | Executes commands over SSH |
| Does not require SSH | Requires SSH connectivity |

---

# Remote Provisioning Architecture

To successfully use `remote-exec`, several AWS networking components are required.

```
Internet

↓

Internet Gateway

↓

Route Table

↓

Public Subnet

↓

Security Group

↓

EC2 Instance
```

Terraform must be able to SSH into the EC2 before any remote provisioner can execute.

---

# Hands-on 1 - local-exec

Created a simple EC2 instance and used the `local-exec` provisioner.

Example:

```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip} > public_ip.txt"
}
```

Result:

```
terraform apply

↓

EC2 Created

↓

public_ip.txt Generated

↓

Public IP Saved
```

This demonstrated that `local-exec` runs on the Terraform machine.

---

# Hands-on 2 - remote-exec

Instead of creating only an EC2 instance, a complete networking stack was built to support SSH connectivity.

Infrastructure created:

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- AWS Key Pair
- EC2 Instance

---

# Network Design

```
                Internet

                     │

                     ▼

            Internet Gateway

                     │

                     ▼

             Public Route Table

                     │

                     ▼

      Route Table Association

                     │

                     ▼

          Public Subnet

                     │

                     ▼

          Security Group

           SSH (22)

           HTTP (80)

                     │

                     ▼

             Ubuntu EC2
```

---

# Understanding Each Resource

## VPC

Creates an isolated private network.

Example:

```
10.0.0.0/16
```

---

## Public Subnet

Creates a subnet inside the VPC.

Example:

```
10.0.1.0/24
```

A subnet becomes **public** only when its Route Table contains a route to an Internet Gateway.

Simply enabling:

```hcl
map_public_ip_on_launch = true
```

does **not** make it a public subnet.

---

## Internet Gateway

Provides Internet connectivity to the VPC.

Without an Internet Gateway:

```
Internet

X

VPC
```

No Internet communication is possible.

---

## Route Table

Controls how traffic flows.

Example:

```hcl
route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
```

Meaning:

> Send all Internet traffic through the Internet Gateway.

---

## Route Table Association

Associates a Route Table with a specific subnet.

Without this association, the subnet won't use that Route Table.

---

## Security Group

Acts as a virtual firewall.

Rules configured:

- SSH (22)
- HTTP (80)

```
Internet

↓

Security Group

↓

EC2
```

---

## AWS Key Pair

Used for SSH authentication.

AWS stores the **public key**.

The user keeps the **private key**.

Terraform created the AWS Key Pair using:

```hcl
resource "aws_key_pair" "terraform_key" {

  key_name = "terraform-demo"

  public_key = file("~/.ssh/id_rsa.pub")

}
```

---

# EC2 Instance

The EC2 instance was launched with:

- Ubuntu AMI
- Public Subnet
- Security Group
- AWS Key Pair

---

# Connection Block

Before Terraform can execute remote commands, it must establish an SSH connection.

Example:

```hcl
connection {

  type = "ssh"

  host = self.public_ip

  user = "ubuntu"

  private_key = file("~/.ssh/id_rsa")

}
```

Purpose:

- Connect using SSH
- Authenticate using the private key
- Log in as the Ubuntu user

---

# File Provisioner

Copied the Flask application from the local machine to the EC2.

Example:

```hcl
provisioner "file" {

  source = "app.py"

  destination = "/home/ubuntu/app.py"

}
```

This is equivalent to using:

```bash
scp app.py ubuntu@<public-ip>:/home/ubuntu/
```

---

# remote-exec Provisioner

Executed commands inside the EC2.

Example:

```hcl
provisioner "remote-exec" {

  inline = [

    "echo 'Connected to EC2 successfully!'",

    "sudo apt update -y",

    "sudo apt install -y python3-pip",

    "sudo apt install -y python3-flask",

    "cd /home/ubuntu",

    "sudo python3 app.py &"

  ]

}
```

Execution Flow:

```
SSH

↓

Update Packages

↓

Install pip

↓

Install Flask

↓

Run Flask Application
```

---

# Why use '&'?

Running:

```bash
python3 app.py
```

keeps the process running in the foreground.

Terraform would wait forever.

Instead:

```bash
python3 app.py &
```

starts the application in the background, allowing `terraform apply` to complete.

---

# local-exec (Final Step)

After successful provisioning, another `local-exec` command was used.

```hcl
provisioner "local-exec" {

  command = "echo http://${self.public_ip}:80 > link_to_launch.txt"

}
```

Result:

```
link_to_launch.txt

↓

http://<EC2-Public-IP>:80
```

This file is created on the Terraform machine.

---

# Expected Provisioning Flow

```
terraform apply

↓

Create Network

↓

Create Security Group

↓

Create Key Pair

↓

Launch EC2

↓

SSH

↓

Copy app.py

↓

Install Python Packages

↓

Install Flask

↓

Run Flask

↓

Generate link_to_launch.txt
```

---

# Troubleshooting Encountered

During the lab, Terraform successfully created all AWS resources:

- VPC
- Subnet
- Internet Gateway
- Route Table
- Security Group
- Key Pair
- EC2 Instance

However, the **File Provisioner** failed with:

```
dial tcp <EC2-Public-IP>:22

Connection timed out
```

Investigation confirmed:

- EC2 was running.
- Public IP was assigned.
- Security Group allowed ports **22** and **80**.
- Internet Gateway and Route Table were correctly configured.

Additional testing:

```bash
ssh ubuntu@<EC2-Public-IP>
```

Result:

```
Connection timed out
```

Even testing SSH connectivity to GitHub:

```bash
nc -zv github.com 22
```

also timed out.

Conclusion:

The corporate network blocks outbound SSH (TCP 22), preventing Terraform from establishing an SSH connection to the EC2.

This was **not** a Terraform configuration issue but an environmental/network restriction.

---

# Best Practices

- Use Provisioners only when necessary.
- Prefer **User Data**, **cloud-init**, **AWS Systems Manager (SSM)**, or **Ansible** for complex server configuration.
- Keep Provisioners simple and idempotent.
- Avoid using Provisioners for long-running application deployments.

---

# Interview Questions

## What are Terraform Provisioners?

Provisioners execute scripts or commands before or after resource creation.

---

## What is local-exec?

Executes commands on the machine running Terraform.

---

## What is remote-exec?

Executes commands inside a remote resource over SSH.

---

## What is the File Provisioner?

Copies files from the Terraform machine to the remote resource.

---

## What is the purpose of the Connection Block?

It tells Terraform how to connect to the remote machine using SSH.

---

## Why is a Key Pair required?

Terraform authenticates to the EC2 using the private key, while AWS stores the corresponding public key.

---

## Why did remote-exec fail in the lab?

Because the corporate network blocked outbound SSH (TCP port 22), preventing Terraform from connecting to the EC2 instance.

---

## Why do we use `host = self.public_ip`?

`self.public_ip` dynamically uses the public IP assigned to the current EC2 instance, avoiding hardcoded IP addresses.

---

## Why do we use `&` while running the Flask application?

It runs the application in the background so Terraform can complete the execution without waiting indefinitely.

---

# Key Takeaways

- Terraform creates infrastructure first, then executes Provisioners.
- `local-exec` runs on the Terraform machine.
- `file` copies files to the remote machine.
- `remote-exec` runs commands on the remote machine over SSH.
- Remote provisioners require proper networking, SSH access, and authentication.
- Network connectivity is just as important as Terraform configuration when using `remote-exec`.
