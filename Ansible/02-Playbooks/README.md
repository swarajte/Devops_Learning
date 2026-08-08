# 02 - Playbooks

This section covers the fundamentals of **Ansible Playbooks**, task execution, registered variables, and basic variable management.

The focus is on understanding how Ansible moves from simple **Ad-hoc commands** to structured and reusable automation.

---

# 🎯 Objective

Learn how to:

* Write basic Ansible Playbooks
* Understand Plays and Tasks
* Target inventory groups
* Capture task output using `register`
* Display task results using `debug`
* Define and reuse variables
* Configure host-specific variables
* Configure group-specific variables

---

# 📚 Topics Covered

* Ansible Playbooks
* YAML document marker `---`
* Plays
* Tasks
* `ansible-playbook`
* Inventory groups
* `register`
* Registered result variables
* `debug`
* Variables
* Jinja2 variable syntax
* `host_vars`
* `group_vars`

---

# 1. Ansible Playbooks

## What is a Playbook?

An Ansible Playbook is a YAML file containing one or more **plays**, where each play defines:

* Which hosts should be targeted
* Which tasks should be executed

Simple mental model:

```text
Playbook
   ↓
 Play
   ↓
 Tasks
   ↓
 Modules
```

---

# 2. Ad-hoc Commands vs Playbooks

## Ad-hoc Command

Used for quick, one-time operations.

Example:

```bash
ansible all -i inventory -m command -a "hostname"
```

## Playbook

Used for structured, repeatable automation.

Example:

```yaml
- name: Get hostname
  command: hostname
```

### Main Difference

```text
Ad-hoc
→ Quick one-time task

Playbook
→ Multiple structured and reusable tasks
```

---

# 3. Basic Playbook Structure

Example:

```yaml
---
- name: My First Ansible Playbook
  hosts: all

  tasks:

  - name: Get hostname
    command: hostname

  - name: Get uptime
    command: uptime

  - name: Get current user
    command: whoami
```

Run it with:

```bash
ansible-playbook -i inventory first-playbook.yml
```

---

# 4. `---` in YAML

```yaml
---
```

is the **YAML document-start marker**.

It indicates the beginning of a YAML document.

It is not mandatory for Ansible Playbooks, but is commonly used as a YAML convention.

---

# 5. Play vs Task

## Play

A Play defines:

* Target hosts
* Collection of tasks

Example:

```yaml
- name: Configure WebLogic
  hosts: weblogic

  tasks:
    ...
```

## Task

A Task is one specific action.

Example:

```yaml
- name: Get hostname
  command: hostname
```

Mental model:

```text
PLAY
 │
 ├── TASK
 ├── TASK
 └── TASK
```

A Playbook can contain multiple Plays.

---

# 6. Inventory Groups

An inventory can contain different groups of servers.

Example:

```ini
[weblogic]
WL01
WL02
WL03

[databases]
DB01
DB02
```

A Play can target a specific group:

```yaml
hosts: weblogic
```

This means the tasks run only against:

```text
WL01
WL02
WL03
```

Using:

```yaml
hosts: databases
```

would target:

```text
DB01
DB02
```

Using:

```yaml
hosts: all
```

targets all inventory hosts.

---

# 7. Why Inventory Groups Are Important

In a real environment we may have:

```text
WebLogic Servers
Database Servers
Monitoring Servers
Application Servers
```

Instead of creating separate inventories, we can organize the servers into groups.

Example:

```text
Inventory
   │
   ├── weblogic
   │      ├── WL01
   │      ├── WL02
   │      └── WL03
   │
   └── databases
          ├── DB01
          └── DB02
```

Then Playbooks can target exactly the required group.

---

# 8. `register`

## Simple Explanation

`register` captures the result of a task and stores it in a variable.

Think:

```text
Task
 ↓
Execute
 ↓
Result
 ↓
register
 ↓
Store result
```

Example:

```yaml
- name: Get hostname
  command: hostname
  register: hostname_result
```

Ansible stores the result inside:

```text
hostname_result
```

---

# 9. What Does a Registered Result Contain?

A registered result contains multiple pieces of information.

Important fields include:

```text
stdout
stderr
rc
changed
failed
```

### `stdout`

Normal output of the command.

Example:

```text
ilcepoc3638
```

### `stderr`

Error output, if present.

### `rc`

Return code.

Generally:

```text
0        → success
non-zero → failure
```

### `changed`

Whether Ansible considers the task to have made a change.

### `failed`

Whether the task failed.

---

# 10. Displaying Registered Output

Example:

```yaml
- name: Get hostname
  command: hostname
  register: hostname_result

- name: Display hostname
  debug:
    var: hostname_result.stdout
```

The important part is:

```yaml
hostname_result.stdout
```

This extracts the command's standard output.

---

# 11. Display the Complete Registered Result

We can also display the entire registered result:

```yaml
- name: Display complete result
  debug:
    var: hostname_result
```

This allows us to inspect the different fields Ansible stored.

---

# 12. Why `register` Is Useful

The result of one task can be used by later tasks.

Example:

```text
Task A
  ↓
Check something
  ↓
register result
  ↓
Task B
  ↓
Use the result
```

This becomes especially useful when automation needs to make decisions based on what happened on the server.

---

# 13. Variables

## Simple Explanation

A variable is a named value that can be reused.

Example:

```yaml
vars:
  app_name: weblogic
  app_version: "14.1.2"
  app_dir: /opt/weblogic
```

Instead of repeatedly writing:

```text
/opt/weblogic
```

we can use:

```yaml
"{{ app_dir }}"
```

---

# 14. Jinja2 Variable Syntax

Ansible uses Jinja2 syntax to reference variables:

```yaml
{{ variable_name }}
```

Example:

```yaml
vars:
  app_name: weblogic
```

Then:

```yaml
debug:
  msg: "Application: {{ app_name }}"
```

Output:

```text
Application: weblogic
```

---

# 15. Variables with Modules

Variables can be used with modules.

Example:

```yaml
---
- name: Variables with File Module
  hosts: all

  vars:
    demo_dir: /tmp/ansible-demo
    demo_file: /tmp/ansible-demo/hello.txt

  tasks:

  - name: Create demo directory
    file:
      path: "{{ demo_dir }}"
      state: directory

  - name: Create demo file
    file:
      path: "{{ demo_file }}"
      state: touch
```

The same variable can be reused by multiple tasks.

---

# 16. Why Use Variables?

Without variables:

```yaml
path: /opt/weblogic
```

might need to be repeated in multiple tasks.

With variables:

```yaml
vars:
  app_dir: /opt/weblogic
```

we can use:

```yaml
{{ app_dir }}
```

throughout the Playbook.

If the directory changes, we only need to update the variable.

### Main Benefits

* Reusability
* Maintainability
* Avoid hardcoding
* Separate configuration from automation logic

---

# 17. Host Variables

Sometimes different hosts need different values.

For example:

```text
WL01 → /tmp/wl01
WL02 → /tmp/wl02
```

Ansible provides the conventional:

```text
host_vars/
```

directory.

Structure:

```text
02-Playbooks/
│
├── inventory
│
├── host_vars/
│   ├── wl01.yml
│   └── wl02.yml
│
└── host-specific-demo.yml
```

---

# 18. Host Variable Mapping

Inventory:

```ini
[weblogic]
wl01 ansible_connection=local
wl02 ansible_connection=local
```

Host variables:

```text
wl01
 ↓
host_vars/wl01.yml
```

```text
wl02
 ↓
host_vars/wl02.yml
```

Example:

### `host_vars/wl01.yml`

```yaml
app_dir: /tmp/wl01
```

### `host_vars/wl02.yml`

```yaml
app_dir: /tmp/wl02
```

The same Playbook can then use:

```yaml
{{ app_dir }}
```

and each host receives its own value.

---

# 19. Group Variables

Sometimes multiple hosts need the same value.

For example:

```ini
[weblogic]
wl01
wl02
wl03
```

All WebLogic servers might share:

```text
application = weblogic
port = 7001
environment = production
```

Instead of repeating these values in every `host_vars` file, we can use:

```text
group_vars/
```

Structure:

```text
02-Playbooks/
│
├── inventory
│
├── group_vars/
│   └── weblogic.yml
│
└── group-variable-demo.yml
```

The mapping is:

```text
[weblogic]
      ↓
group_vars/weblogic.yml
```

---

# 20. Group Variable Example

### `group_vars/weblogic.yml`

```yaml
app_name: weblogic
app_port: 7001
environment: production
```

Inventory:

```ini
[weblogic]
wl01 ansible_connection=local
wl02 ansible_connection=local
```

Both hosts receive:

```text
app_name     → weblogic
app_port     → 7001
environment  → production
```

The same Playbook can use:

```yaml
{{ app_name }}
{{ app_port }}
{{ environment }}
```

---

# 21. Host Variables vs Group Variables

| Type         | Purpose                    | Example                |
| ------------ | -------------------------- | ---------------------- |
| `vars`       | Values defined in the Play | `app_name: weblogic`   |
| `host_vars`  | Values for one host        | `wl01 → /tmp/wl01`     |
| `group_vars` | Values shared by a group   | `weblogic → port 7001` |

Simple mental model:

```text
vars
 ↓
Play-level value


host_vars
 ↓
One host


group_vars
 ↓
Entire group
```

---

# 💼 Real-World WebLogic Mapping

A WebLogic environment might look like:

```text
                    Inventory
                       │
                 [weblogic]
                       │
             ┌─────────┼─────────┐
             ▼         ▼         ▼
           WL01      WL02      WL03
```

Shared WebLogic configuration:

```text
group_vars/weblogic.yml
```

Could contain values such as:

```yaml
weblogic_port: 7001
patch_dir: /opt/weblogic/patches
weblogic_user: oracle
```

Host-specific configuration could be kept in:

```text
host_vars/wl01.yml
host_vars/wl02.yml
host_vars/wl03.yml
```

For example, if the WebLogic home differs between servers.

---

# 🧪 Hands-on Files Created

During Day 2, the following files and directories were created:

```text
02-Playbooks/
│
├── inventory
│
├── first-playbook.yml
│
├── register-demo.yml
├── register-debug-print.yml
│
├── variables-demo.yml
├── variables-file-demo.yml
│
├── host_vars/
│   ├── wl01.yml
│   └── wl02.yml
│
├── host-specific-demo.yml
│
├── group_vars/
│   └── weblogic.yml
│
└── group-variable-demo.yml
```

---

# 🎯 Interview Questions

## Playbooks

### What is an Ansible Playbook?

A YAML file containing one or more plays that define the target hosts and tasks to be executed.

### What is a Play?

A Play maps a collection of tasks to a group of hosts.

### What is a Task?

A Task is a single unit of work executed using an Ansible module.

### Ad-hoc command vs Playbook?

Ad-hoc commands are useful for quick one-time operations, while Playbooks provide structured and reusable automation.

---

## Register

### What is `register`?

`register` captures the result of a task and stores it in a variable for later use.

### What is `stdout`?

The standard output produced by a command.

### What is `rc`?

The return code of the command. Generally `0` indicates success and non-zero indicates failure.

---

## Variables

### What is a variable?

A named value that can be reused throughout Ansible automation.

### How do you reference a variable?

Using Jinja2 syntax:

```yaml
{{ variable_name }}
```

### Why use variables?

To avoid hardcoding, improve reusability and maintainability, and separate configuration values from automation logic.

### Host variables vs Group variables?

`host_vars` contains values specific to individual hosts, while `group_vars` contains values shared by hosts belonging to a group.

---

# ✍️ Day 2 Handwritten Revision

```text
ANSIBLE DAY 2
=============

PLAYBOOK
--------
YAML file containing one or more Plays.

Play
→ defines target hosts + tasks

Task
→ one specific action using a module


AD-HOC vs PLAYBOOK
------------------
Ad-hoc → quick one-time task
Playbook → structured/reusable automation


INVENTORY GROUPS
----------------

[weblogic]
WL01
WL02

[databases]
DB01
DB02

hosts: weblogic
→ only WebLogic hosts

hosts: all
→ all inventory hosts


REGISTER
--------

register captures task result.

Example:

command: hostname
register: hostname_result

Important fields:

stdout → normal output
stderr → error output
rc → return code
changed → task change status
failed → task failure status

Display:

debug:
  var: hostname_result.stdout


VARIABLES
---------

Variable = named reusable value.

vars:
  app_dir: /opt/weblogic

Use:

{{ app_dir }}

Why?
→ avoid hardcoding
→ reuse values
→ easier maintenance


HOST VARIABLES
--------------

host_vars/
├── wl01.yml
└── wl02.yml

wl01 → host_vars/wl01.yml
wl02 → host_vars/wl02.yml

Used for host-specific values.


GROUP VARIABLES
---------------

group_vars/
└── weblogic.yml

Used for values shared by
all hosts in the group.

HOST vs GROUP:

host_vars  → one host
group_vars → entire group
```

---

# 🚧 Not Covered Yet

These are intentionally left for the next sessions:

* Ansible Facts
* `when` / Conditionals
* Loops
* Templates
* Handlers
* Roles
* Vault
* Advanced variable precedence
* Dynamic Inventory
* WebLogic patching playbook deep dive

---

# 🚀 Day 3 Preview

The next major concept will be:

## Ansible Facts

You've already seen this every time you run a Playbook:

```text
TASK [Gathering Facts]
ok: [localhost]
```

We'll understand **what Ansible is actually gathering**, inspect the facts ourselves, and then use them in automation.

After that we'll move into:

```text
Facts
  ↓
when / Conditions
  ↓
Loops
```

These will be particularly important for understanding how real enterprise Playbooks make decisions and perform repetitive operations.

