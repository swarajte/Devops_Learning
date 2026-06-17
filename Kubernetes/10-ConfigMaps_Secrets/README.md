# 10 - ConfigMaps & Secrets 🔐

## 📅 Date

17 June 2026

---

# 🎯 Goal

Learn:

* ConfigMaps
* Secrets
* Why they are needed
* Difference between ConfigMaps and Secrets
* Environment Variable Injection
* Volume Mounts
* Secret Encoding

---

# 🧠 Why ConfigMaps?

Applications require configuration values such as:

* Database Host
* Database Port
* URLs
* Environment Names
* Application Ports

Instead of hardcoding values inside application code or Docker images, Kubernetes stores configuration separately using ConfigMaps.

Think:

```text
Application = Engine

ConfigMap = Settings File
```

---

# 🧠 What is a ConfigMap?

ConfigMap stores:

```text
Non-Sensitive Configuration Data
```

Examples:

* Hostnames
* Ports
* URLs
* Environment Names

---

# 🧠 ConfigMap Example

Created:

```yaml
apiVersion: v1
kind: ConfigMap

metadata:
  name: test-cm

data:
  db-port: "3306"
```

Applied:

```bash
kubectl apply -f cm.yaml
```

Verified:

```bash
kubectl get cm

kubectl describe cm test-cm
```

---

# 🧠 How Pods Consume ConfigMaps

There are two common methods.

---

## Method 1 - Environment Variables

Flow:

```text
ConfigMap
    ↓
Environment Variable
    ↓
Container
```

Deployment:

```yaml
env:
- name: DB_PORT
  valueFrom:
    configMapKeyRef:
      name: test-cm
      key: db-port
```

Verification:

```bash
kubectl exec -it <pod-name> -- bash

echo $DB_PORT
```

Output:

```text
3306
```

### Learning

ConfigMap value becomes an environment variable inside the container.

---

## Method 2 - Volume Mount

Flow:

```text
ConfigMap
    ↓
File
    ↓
Container
```

Created:

```yaml
apiVersion: v1
kind: ConfigMap

metadata:
  name: app-config

data:
  app.properties: |
    db_port=3306
    environment=production
```

Mounted:

```yaml
volumeMounts:
- name: config-volume
  mountPath: /etc/config

volumes:
- name: config-volume
  configMap:
    name: app-config
```

Verification:

```bash
kubectl exec -it <pod-name> -- bash

cd /etc/config

cat app.properties
```

Output:

```text
db_port=3306
environment=production
```

### Learning

Kubernetes automatically creates files from ConfigMap data and mounts them into the container.

---

# 🧠 What are Secrets?

Secrets store:

```text
Sensitive Data
```

Examples:

* Passwords
* API Keys
* Tokens
* Certificates
* SSH Keys

Think:

```text
ConfigMap = Settings File

Secret = Password Vault
```

---

# 🧠 Secret Example

Created:

```bash
kubectl create secret generic test-secret \
--from-literal=db-port="3306"
```

Verified:

```bash
kubectl get secrets

kubectl describe secret test-secret
```

Output:

```text
Type: Opaque

Data
====
db-port: 4 bytes
```

---

# 🧠 Understanding Secret Storage

Viewed Secret:

```bash
kubectl get secret test-secret -o yaml
```

Output:

```yaml
data:
  db-port: MzMwNg==
```

Decoded:

```bash
echo MzMwNg== | base64 --decode
```

Output:

```text
3306
```

### Important Learning

By default:

```text
Secrets are Base64 Encoded
```

NOT:

```text
Encrypted
```

For stronger security:

```text
Enable Encryption at Rest
```

---

# 🧠 How Pods Consume Secrets

Same methods as ConfigMaps:

### Environment Variables

```text
Secret
    ↓
Environment Variable
    ↓
Container
```

Using:

```yaml
secretKeyRef:
```

---

### Volume Mounts

```text
Secret
    ↓
Mounted File
    ↓
Container
```

Using:

```yaml
secret:
```

---

# 🧠 ConfigMap vs Secret

| ConfigMap          | Secret         |
| ------------------ | -------------- |
| Non-sensitive data | Sensitive data |
| URLs               | Passwords      |
| Ports              | Tokens         |
| Hostnames          | API Keys       |
| Environment Names  | Certificates   |

---

# 🧠 Security Best Practices

* Never store passwords in ConfigMaps
* Store credentials in Secrets
* Enforce RBAC on Secrets
* Follow Least Privilege Principle
* Enable Encryption at Rest

---

# 🧠 Hands-On Performed

Created:

```text
cm.yaml
deployment.yaml

cm-file.yaml
deployment-mount.yaml
```

Verified:

### ConfigMap as Environment Variable

```bash
echo $DB_PORT
```

Output:

```text
3306
```

---

### ConfigMap as Mounted File

```bash
cat /etc/config/app.properties
```

Output:

```text
db_port=3306
environment=production
```

---

### Secret Creation

```bash
kubectl create secret generic test-secret \
--from-literal=db-port="3306"
```

Verified:

```bash
kubectl describe secret test-secret
```

Decoded:

```bash
echo MzMwNg== | base64 --decode
```

Output:

```text
3306
```

---

# 🎯 Final Understanding

```text
ConfigMap
    ↓
Stores Non-Sensitive Configuration

Secret
    ↓
Stores Sensitive Configuration

Pods consume both using:

1. Environment Variables
2. Mounted Files
```

---

# 💡 Interview One-Liner

ConfigMaps store application configuration, Secrets store sensitive credentials, and both can be injected into Pods as environment variables or mounted files.

