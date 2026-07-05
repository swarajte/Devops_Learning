# 13 - Kubernetes User Management (Border0)

## 📅 Date

05 July 2026

---

# 🎯 Goal

Learn why enterprises use external Kubernetes User Management solutions like **Border0** instead of relying only on kubeconfig files and Kubernetes RBAC.

---

# 🧠 Challenges with Native Kubernetes User Management

### 1. Kubeconfig Sprawl

- Every user receives a kubeconfig file.
- kubeconfig contains cluster endpoint and authentication credentials.
- Can be copied, shared or downloaded.
- Difficult to track and revoke access.

---

### 2. Over-Privileged Access

Kubernetes RBAC consists of:

- Roles
- ClusterRoles
- RoleBindings
- ClusterRoleBindings

Managing RBAC becomes complex in large organizations.

A small misconfiguration can accidentally grant excessive permissions (e.g., `cluster-admin`).

---

### 3. Just-In-Time (JIT) Access

Developers often require temporary production access.

Problem:

```
Access Granted
      ↓
Issue Fixed
      ↓
Access Still Exists ❌
```

Ideal Flow:

```
Access Requested
      ↓
Approved
      ↓
Temporary Access
      ↓
Automatically Revoked
```

---

# 🧠 Why Border0?

Border0 provides:

- Secure Authentication (SSO)
- Centralized User Management
- Temporary (JIT) Access
- Policy-Based Authorization
- Audit Logs
- Secure cluster access without sharing kubeconfig files

Border0 works **alongside Kubernetes RBAC**, not as its replacement.

---

# 🧠 High-Level Architecture

```
Developer
      │
      ▼
Border0 Portal
      │
      ▼
Border0 Connector (Running inside Kubernetes)
      │
(ServiceAccount + RBAC)
      │
      ▼
Kubernetes API Server
      │
      ▼
Cluster Resources
```

The Border0 Connector runs as a Pod inside the cluster and securely communicates with the Kubernetes API Server using its ServiceAccount permissions.

---

# 🛠 Hands-On Performed

### 1. Created a Local Kind Cluster

```bash
kind create cluster --name demo-border0-cluster
```

Created a local Kubernetes cluster using Docker.

---

### 2. Installed Border0 Connector using Helm

- Added Border0 Helm Repository.
- Installed Border0 Connector.
- A Connector Pod was created inside the Kubernetes cluster.

The connector securely connected the cluster with the Border0 Cloud.

---

### 3. Created a Kubernetes Socket

Created a Kubernetes Socket from the Border0 Portal.

After the connector registered successfully, Border0 was able to discover cluster resources like:

- Pods
- Deployments
- Services
- ConfigMaps
- Secrets
- Nodes
- Namespaces

The Kubernetes cluster became manageable through the Border0 UI.

---

### 4. Created a Policy

Created a Developer Policy allowing access only to:

- ConfigMaps

Assigned this policy to a user and attached it to the Kubernetes Socket.

---

### 5. Verified Access

Logged in using the newly created user.

Observed:

✅ Only ConfigMaps were visible.

Pods, Deployments and other resources were hidden.

---

### 6. Updated the Policy

Added permissions for:

- Pods
- Deployments

Refreshed the Border0 Portal.

Observed:

The user could now access:

- ConfigMaps
- Pods
- Deployments

No connector restart was required.

Only updating the policy immediately changed the user's permissions.

---

# 🎯 Key Takeaways

- Kubernetes RBAC alone becomes difficult to manage at enterprise scale.
- Border0 centralizes authentication and user management.
- Border0 Connector runs inside the Kubernetes cluster.
- The Connector accesses the Kubernetes API Server using a ServiceAccount.
- Users never directly share kubeconfig files.
- Policies determine what Kubernetes resources a user can access.
- Updating policies dynamically changes user permissions.

---

# 💡 Revision Summary

```
Problems

Kubeconfig Sharing
        +
Complex RBAC
        +
No Temporary Access

↓

Border0

↓

Connector (Pod)

↓

Kubernetes API Server

↓

RBAC

↓

Pods / Deployments / ConfigMaps / Secrets
```

## 📌 One-Line Summary

**Border0 provides secure, centralized Kubernetes user management by authenticating users, enforcing policy-based access, and securely connecting to the Kubernetes API through a Connector running inside the cluster, while leveraging Kubernetes RBAC for authorization.**
