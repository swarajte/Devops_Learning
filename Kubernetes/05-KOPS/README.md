# KOPS - What I Did Today 🚀

## 📅 Date

18 April 2026

---

## 🎯 Goal

Set up a **real Kubernetes cluster on AWS using KOPS** and understand how it works internally.

---

## 🧰 Tools Used

* AWS EC2 (control machine)
* kubectl
* AWS CLI
* KOPS

---

## ⚙️ Setup Steps

### 1. Installed tools

* kubectl
* AWS CLI
* KOPS

---

### 2. Configured AWS

```bash
aws configure
```

---

### 3. Created S3 bucket (state store)

```bash
aws s3api create-bucket --bucket kops-swaraj-store --region us-east-1
```

---

### 4. Set state store

```bash
export KOPS_STATE_STORE=s3://kops-swaraj-store
```

---

### 5. Created cluster

```bash
kops create cluster --name=demok8scluster.k8s.local \
--zones=us-east-1a \
--node-count=1 \
--node-size=t3.micro \
--control-plane-size=t3.micro
```

---

### 6. Built cluster

```bash
kops update cluster --name demok8scluster.k8s.local --yes
```

---

### 7. Fixed authentication

```bash
kops export kubeconfig --name demok8scluster.k8s.local --admin
```

---

### 8. Added SSH access

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

kops create secret sshpublickey admin -i ~/.ssh/id_rsa.pub

kops update cluster --yes

kops rolling-update cluster --cloudonly --yes
```

---

### 9. Explored nodes

* SSH into EC2 nodes
* Checked running processes:

```bash
ps -ef | grep kubelet
```

---

## 🧠 Key Learnings

* Node = EC2 instance
* Kubernetes = processes running on nodes
* KOPS creates full infrastructure (EC2, LB, networking)
* Cluster lifecycle:

  * create → update → validate → delete

  ---

  ## 🔥 What I Saw Inside Node

  * kubelet (node agent)
  * kube-apiserver (control plane)
  * etcd connection

  ---

  ## ⚠️ Issues Faced

  * SSH key mismatch
  * Wrong S3 bucket name
  * API timeout (cluster not ready yet)
  * Needed rolling update to apply changes

  ---

  ## 🧹 Cleanup

  ```bash
  kops delete cluster --name demok8scluster.k8s.local --yes
  ```

  ---

  ## 🧠 Final Understanding

  > Kubernetes is not magic — it's just multiple processes running on cloud machines (EC2), managed by tools like KOPS.

  ---

