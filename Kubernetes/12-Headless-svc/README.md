# 12 - Headless Service & StatefulSet 🚀

## 📅 Date
03 July 2026

---

# 🎯 Goal

Learned:

- Service traffic flow
- Stateless vs Stateful Applications
- Headless Service
- StatefulSet
- Kubernetes DNS
- Stable Pod Identity

---

# 🧠 Kubernetes Service Flow

A request reaches the application in the following order:

```
Client
   ↓
LoadBalancer
   ↓
NodePort
   ↓
ClusterIP (Service)
   ↓
Endpoints
   ↓
Pod
```

- **LoadBalancer** → Chooses a Worker Node.
- **NodePort** → Entry point on the selected Node.
- **ClusterIP** → Stable virtual IP of the Service.
- **Endpoints** → List of Pod IPs behind the Service.
- **kube-proxy** watches Endpoints and forwards traffic to one healthy Pod.

---

# 🧠 Stateless vs Stateful Applications

### Stateless

- Doesn't store data.
- Any Pod can handle any request.

Examples:

- Nginx
- Frontend
- REST APIs

---

### Stateful

- Stores data.
- Every Pod has its own identity.

Examples:

- MySQL
- PostgreSQL
- MongoDB
- Kafka
- Cassandra

---

# 🧠 Why Headless Service?

Normal Services always load balance requests.

For databases, requests may need to reach a **specific Pod**.

Example:

```
INSERT Employee
        ↓
DB-1

SELECT COUNT(*)
        ↓
DB-2 ❌
```

This may return inconsistent data.

---

# 🧠 Headless Service

```yaml
clusterIP: None
```

Removes the ClusterIP.

Instead of returning one Service IP,

it returns the actual Pod IPs.

```
Normal Service

Client
   ↓
ClusterIP
   ↓
One Pod (Load Balanced)

----------------------------

Headless Service

Client
   ↓
Gets all Pod IPs
   ↓
Client chooses Pod
```

---

# 🧠 StatefulSet

Deployment → Stateless Applications

StatefulSet → Stateful Applications

StatefulSet provides:

- Stable Pod Names
- Stable DNS Names
- Ordered Pod Creation
- Persistent Identity

Example:

```
mysql-statefulset-0

mysql-statefulset-1

mysql-statefulset-2
```

If Pod-0 crashes:

```
mysql-statefulset-0

↓

Deleted

↓

mysql-statefulset-0
```

Same name.

New IP.

---

# 🧠 Headless Service + StatefulSet

The StatefulSet uses a Headless Service:

```yaml
serviceName: my-db-headless-service
```

Every Pod gets its own DNS:

```
mysql-statefulset-0.my-db-headless-service.default.svc.cluster.local

mysql-statefulset-1.my-db-headless-service.default.svc.cluster.local

mysql-statefulset-2.my-db-headless-service.default.svc.cluster.local
```

Applications connect using DNS instead of Pod IPs.

---

# 🧠 DNS Name Breakdown

```
<Pod>.<Service>.<Namespace>.svc.cluster.local
```

Example:

```
mysql-statefulset-0
        ↓
Pod Name

my-db-headless-service
        ↓
Headless Service

default
        ↓
Namespace

svc
        ↓
Service DNS

cluster.local
        ↓
Cluster Domain
```

---

# 🧠 DNS Testing

Command:

```bash
kubectl run -it --rm --restart=Never --image=busybox dns-test -- nslookup mysql-statefulset-0.my-db-headless-service.default.svc.cluster.local
```

Purpose:

- Creates a temporary BusyBox Pod.
- Queries Kubernetes DNS.
- Returns the current IP of `mysql-statefulset-0`.
- Pod is deleted automatically after the command.

Reason:

Kubernetes DNS (`*.svc.cluster.local`) works **only inside the cluster**, so we create a temporary Pod to test it.

---

# 🧠 Hands-On

✅ Created a Headless Service

```yaml
clusterIP: None
```

✅ Created a StatefulSet (3 replicas)

```
mysql-statefulset-0

mysql-statefulset-1

mysql-statefulset-2
```

✅ Verified:

```bash
kubectl get pods -o wide
kubectl get svc
kubectl get statefulset
```

✅ Deleted `mysql-statefulset-0`

Observed:

- New Pod recreated automatically.
- Same Pod name.
- New Pod IP.

✅ Verified DNS using `nslookup`.

Observed:

DNS resolved to the **new Pod IP**, proving that StatefulSet provides stable DNS names even when Pod IPs change.

---

# 🎯 Revision Summary

```
Stateless Apps
        ↓
Deployment

Stateful Apps
        ↓
StatefulSet

-------------------------

Normal Service
        ↓
ClusterIP
        ↓
Load Balances Requests

-------------------------

Headless Service
        ↓
No ClusterIP
        ↓
Returns Individual Pod IPs

-------------------------

StatefulSet + Headless Service
        ↓
Stable Pod Names
Stable DNS
Ideal for Databases
```

## 💡 One-Line Summary

**Headless Services (`clusterIP: None`) don't load balance traffic. Instead, they expose individual Pod IPs through stable DNS names. When combined with StatefulSets, each Pod gets a fixed identity, making them ideal for stateful applications like MySQL, PostgreSQL, MongoDB, Kafka, and Cassandra.**
