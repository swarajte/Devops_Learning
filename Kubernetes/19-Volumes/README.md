# Kubernetes Volumes

## 📌 Overview

Containers are **ephemeral** by nature.

If a Pod is deleted or recreated, everything stored inside the container filesystem is lost.

Volumes solve this problem by providing storage that can either:

- Live only as long as the Pod (`emptyDir`)
- Persist beyond the Pod lifecycle (`Persistent Volumes`)

In this section, we learned the complete Kubernetes storage architecture, including:

- emptyDir
- Persistent Volumes (PV)
- Persistent Volume Claims (PVC)
- Static Provisioning
- Dynamic Provisioning
- StorageClass
- CSI Drivers

---

# Directory Structure

```
19-Volumes/
│
├── 01-emptyDir/
│
└── 02-persistent-volume/
```

---

# Why Do We Need Volumes?

Without volumes:

```
Pod
 │
 ▼
Container Filesystem

Delete Pod

↓

Everything is Lost ❌
```

Applications like:

- MySQL
- PostgreSQL
- MongoDB
- Redis
- Elasticsearch

cannot store their data inside Pods because Pods are temporary.

> **Pods should use data, not own data.**

---

# Kubernetes Storage Journey

```
No Volume
      │
      ▼
emptyDir
      │
      ▼
Persistent Volume
      │
      ▼
Persistent Volume Claim
      │
      ▼
StorageClass
      │
      ▼
CSI Driver
      │
      ▼
Actual Storage
```

---

# Lab 1 - emptyDir

Directory:

```
01-emptyDir/
```

## What is emptyDir?

`emptyDir` is a temporary directory created by Kubernetes on the worker node and mounted into one or more containers of the same Pod.

```
Worker Node

emptyDir Folder

        │
        ▼

Container

/data
```

## Characteristics

- Created when Pod starts
- Deleted when Pod is deleted
- Shared between containers in same Pod
- Temporary storage only

## Use Cases

- Cache
- Temporary files
- Scratch space
- Sharing files between sidecars

---

## Lifecycle

```
Pod Created

↓

emptyDir Created

↓

Write Data

↓

Delete Pod

↓

Data Lost
```

---

# Lab 2 - Persistent Volumes

Directory:

```
02-persistent-volume/
```

---

## Persistent Volume (PV)

A **Persistent Volume (PV)** is a Kubernetes resource that represents storage available to the cluster.

A PV is **not** the actual disk.

It points to storage such as:

- hostPath
- AWS EBS
- Azure Managed Disk
- Google Persistent Disk
- NFS
- Ceph

---

## Static Provisioning

Administrator manually creates a PV.

```
Admin

↓

Create PV

↓

Developer Creates PVC
```

Example PV:

```yaml
apiVersion: v1
kind: PersistentVolume

metadata:
  name: demo-pv

spec:
  capacity:
    storage: 1Gi

  accessModes:
    - ReadWriteOnce

  persistentVolumeReclaimPolicy: Retain

  storageClassName: manual

  hostPath:
    path: /mnt/data
```

---

## Important PV Fields

### Capacity

```
storage: 1Gi
```

Maximum storage available.

---

### Access Modes

```
ReadWriteOnce (RWO)
```

Meaning:

One node can mount the volume in Read/Write mode.

---

### Reclaim Policy

Retain

```
Delete PVC

↓

PV remains

↓

Data remains
```

Delete

```
Delete PVC

↓

PV deleted

↓

Storage deleted
```

---

# Persistent Volume Claim (PVC)

A PVC is a request for storage.

Think of it like requesting a laptop from the IT department.

The application requests:

- Storage Size
- Access Mode
- StorageClass

Kubernetes finds a matching PV.

PVC Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim

metadata:
  name: demo-pvc

spec:
  storageClassName: manual

  accessModes:
    - ReadWriteOnce

  resources:
    requests:
      storage: 1Gi
```

---

## Binding

```
PVC

⇅

PV
```

Once bound,

that PV cannot be used by another PVC.

---

# Pod using PVC

Pods never directly use a Persistent Volume.

Correct Architecture:

```
Pod

↓

PVC

↓

PV

↓

Storage
```

Example:

```yaml
volumes:
- name: storage
  persistentVolumeClaim:
    claimName: demo-pvc
```

---

## Persistent Storage Demo

Created:

```
/data/message.txt
```

Deleted Pod.

Recreated Pod.

Verified:

```
message.txt

still exists ✅
```

This proves:

> Data lives in the Volume, not inside the Pod.

---

# Static Provisioning

```
Admin

↓

PV

↓

PVC

↓

Pod
```

Manual process.

Requires creating PV YAML.

---

# Dynamic Provisioning

Instead of manually creating a PV,

the developer only creates a PVC.

```
PVC

↓

StorageClass

↓

Provisioner

↓

PV Created Automatically

↓

PVC Bound

↓

Pod Running
```

No PV YAML required.

---

# StorageClass

A StorageClass is a template that tells Kubernetes how to provision storage dynamically.

StorageClass **does not store data**.

It only defines:

- Provisioner
- Reclaim Policy
- Volume Binding Mode

Our cluster:

```
standard (default)
```

Provisioner:

```
rancher.io/local-path
```

---

# VolumeBindingMode

Our StorageClass used:

```
WaitForFirstConsumer
```

Meaning:

```
PVC Created

↓

Wait

↓

Pod Scheduled

↓

Create Storage

↓

Bind PVC
```

Useful for multi-node clusters.

---

# Dynamic Provisioning Demo

Created only:

- PVC
- Pod

Kubernetes automatically created:

```
PersistentVolume

↓

Bound

↓

Pod Running
```

No manual PV creation was required.

---

# CSI Drivers

CSI stands for:

```
Container Storage Interface
```

CSI is a standard interface that allows Kubernetes to communicate with different storage systems.

It is **not** storage.

Think of CSI like USB.

```
Laptop

↓

USB

↓

Keyboard

Mouse

Printer
```

Similarly,

```
Kubernetes

↓

CSI

↓

AWS EBS

Azure Disk

GCP PD

NetApp

Ceph
```

---

# CSI Driver

A CSI Driver is software written by a storage vendor that implements the CSI standard.

Example:

```
PVC

↓

StorageClass

↓

AWS EBS CSI Driver

↓

AWS API

↓

Creates EBS Disk

↓

PV

↓

Pod
```

Our local cluster used:

```
PVC

↓

StorageClass

↓

rancher.io/local-path

↓

Creates Local Directory

↓

PV
```

---

# Complete Kubernetes Storage Architecture

```
Application
      │
      ▼
Persistent Volume Claim
      │
      ▼
StorageClass
      │
      ▼
Provisioner / CSI Driver
      │
      ▼
Persistent Volume
      │
      ▼
Actual Storage
```

---

# Static vs Dynamic Provisioning

| Static Provisioning | Dynamic Provisioning |
|--------------------|----------------------|
| Admin creates PV | Provisioner creates PV |
| Manual | Automatic |
| Requires PV YAML | Requires only PVC YAML |
| Used for special/manual storage | Used in most production clusters |

---

# Key Takeaways

- Pods are ephemeral.
- Volumes provide persistent storage.
- `emptyDir` is temporary storage tied to Pod lifecycle.
- Persistent Volumes survive Pod deletion.
- PVCs request storage from Kubernetes.
- Pods always use PVCs, never PVs directly.
- Static provisioning requires manually creating PVs.
- Dynamic provisioning automatically creates PVs using StorageClasses.
- StorageClasses define how storage should be provisioned.
- CSI Drivers communicate with storage providers to create and manage storage.
- Modern Kubernetes clusters primarily use CSI-based storage provisioning.

---

# Interview Questions

### Why do we need Volumes?

Pods are ephemeral. Volumes allow data to survive Pod restarts and recreation.

---

### Difference between PV and PVC?

PV = Storage resource

PVC = Request for storage

---

### Can a Pod directly mount a PV?

No.

Pods mount PVCs.

PVCs bind to PVs.

---

### What is StorageClass?

A blueprint that defines how Kubernetes should dynamically provision storage.

---

### What is Dynamic Provisioning?

Automatic creation of a Persistent Volume when a PVC requests storage using a StorageClass.

---

### What is CSI?

Container Storage Interface.

A standard that allows Kubernetes to communicate with different storage providers.

---

### What is a CSI Driver?

A plugin written by the storage vendor that implements the CSI standard and manages storage operations.
