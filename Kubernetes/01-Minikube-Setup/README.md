# Kubernetes Setup & Basics (Local Environment)

## 📅 Date

April 2026

---

## 🚀 What I Did

* Installed **Docker Desktop**
* Installed **Minikube**
* Set up a **local Kubernetes cluster**
* Configured and used **kubectl**
* Fixed terminal setup using **MobaXterm**

---

## 🧰 Tools Used

* Docker Desktop
* Minikube
* kubectl
* MobaXterm

---

## 🧠 Key Concepts Learned

### 🔹 Docker

* Used to **run containers**
* Verified setup using:

```bash
docker run hello-world
```

---

### 🔹 Minikube

* Creates a **local Kubernetes cluster**
* Runs cluster inside a **Docker container**
* Command used:

```bash
minikube start --driver=docker
```

---

### 🔹 kubectl

* CLI tool to **interact with Kubernetes cluster**
* Used to:

  * Create resources
    * Check status
      * Debug issues

      ---

      ### 🔹 Kubernetes Cluster (Local)

      * Single-node cluster created using Minikube
      * Node contains:

        * Control Plane (API server, scheduler, etc.)
	  * Worker components (kubelet, pods)

	  ---

	  ## 🔧 Setup Steps

	  ### 1. Install Docker Desktop

	  * Enabled WSL2 backend
	  * Verified:

	  ```bash
	  docker run hello-world
	  ```

	  ---

	  ### 2. Install Minikube

	  * Used installer for Windows
	  * Verified:

	  ```bash
	  minikube version
	  ```

	  ---

	  ### 3. Start Cluster

	  ```bash
	  minikube start --driver=docker
	  ```

	  ---

	  ### 4. Verify Cluster

	  ```bash
	  kubectl get nodes
	  ```

	  Output:

	  ```bash
	  minikube   Ready   control-plane
	  ```

	  ---

	  ## 💻 MobaXterm Setup

	  Since MobaXterm doesn’t directly recognize `.exe` files:

	  ```bash
	  alias minikube="/drives/c/Program\ Files/Kubernetes/Minikube/minikube.exe"
	  alias kubectl="/drives/c/Program\ Files/Docker/Docker/resources/bin/kubectl.exe"
	  ```

	  Saved in:

	  ```bash
	  ~/.bashrc
	  ```

	  ---

	  ## 📦 First Kubernetes Commands

	  ```bash
	  kubectl run nginx --image=nginx
	  kubectl get pods
	  ```

	  ---

	  ## 🔥 Key Takeaways

	  * Docker runs containers
	  * Minikube creates a local Kubernetes cluster
	  * kubectl is used to interact with the cluster
	  * Kubernetes runs applications inside **Pods**
	  * Local setup simulates a real-world cluster (single-node)

	  ---

	  ## 🧠 Summary

	  > Successfully set up a local Kubernetes environment using Minikube and Docker, and executed basic commands to run and manage containers in a cluster.

	  ---
	
