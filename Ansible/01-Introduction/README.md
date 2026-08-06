# 01 - Introduction to Ansible

## 🎯 Objective

Understand the fundamentals of Ansible before writing Playbooks.

This section focuses on **why Ansible exists**, **how it works internally**, and the core building blocks required for automation.

---

# 📚 Topics Covered

- What is Configuration Management?
- Why Configuration Management is Needed
- Problems with Manual Server Management
- What is Ansible?
- Features of Ansible
- Agentless Architecture
- Control Node vs Managed Node
- Communication using SSH
- Inventory
- Default vs Custom Inventory
- Ad-hoc Commands
- Ansible Modules
- Difference between `command` and `shell`
- Commonly Used Modules

---

# 🧠 Key Concepts Learned

## Configuration Management

Managing and maintaining server configuration in a consistent manner.

Examples:

- Installing packages
- Creating users
- Managing services
- Copying files
- Deploying applications
- Applying patches

---

## Ansible

An open-source Automation and Configuration Management tool used to automate repetitive administrative tasks across multiple servers.

---

## Agentless Architecture

Ansible communicates with Linux servers using SSH.

No additional software (agent) needs to be installed on managed Linux servers.

---

## Architecture

```
                 Control Node
                       │
                  SSH Connection
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
   Managed Node   Managed Node   Managed Node
```

---

## Inventory

Inventory contains the list of servers managed by Ansible.

Current inventory:

```ini
localhost ansible_connection=local
```

Since only localhost is available, all commands are executed on the local machine.

---

# 🛠 Ad-hoc Commands Practiced

### Connectivity Check

```bash
ansible all -i inventory -m ping
```

---

### Hostname

```bash
ansible all -i inventory -m command -a "hostname"
```

---

### Current User

```bash
ansible all -i inventory -m command -a "whoami"
```

---

### Uptime

```bash
ansible all -i inventory -m command -a "uptime"
```

---

# 📦 Modules Explored

## command

Executes simple Linux commands.

Example:

```bash
ansible all -m command -a "hostname"
```

---

## shell

Executes commands using the system shell.

Supports:

- Pipes (`|`)
- Redirection (`>`)
- Environment Variables (`$HOME`)
- Multiple Commands (`&&`)

Example:

```bash
ansible all -m shell -a "ps -ef | grep ssh"
```

---

## copy

Copies files from the Control Node to Managed Nodes.

---

## file

Used for:

- Creating directories
- Deleting directories
- Creating files
- Managing permissions

---

## service

Manages Linux services.

Examples:

- Start
- Stop
- Restart
- Enable

---

## dnf / apt

Package Management Modules.

---

## stat

Retrieves file metadata.

---

## debug

Displays variables and debugging information.

---

## get_url

Downloads files from URLs.

---

## unarchive

Extracts compressed archives.

---

## git

Clones Git repositories.

---

# 📂 Files

```
01-Introduction/
│
├── inventory
├── hello.txt
└── README.md
```

---

# 🎯 Interview Questions Covered

- What is Ansible?
- Why Ansible?
- What is Configuration Management?
- What is Inventory?
- What is a Control Node?
- What is a Managed Node?
- What is an Ansible Module?
- Difference between `command` and `shell`
- Why Ansible instead of Shell Scripting?
- What is Agentless Architecture?

---

# 💡 Key Learnings

- Ansible automatically iterates over hosts listed in the Inventory.
- Modules are the fundamental building blocks of Ansible.
- Ad-hoc commands are useful for one-time administrative tasks.
- Inventory tells Ansible where to execute tasks.
- Playbooks provide reusable automation and are the next step after Ad-hoc commands.

---

# 🚀 Next Topic

➡️ Writing the first Ansible Playbook.
