# Kubernetes Networking & Services - Learning Summary 🚀

## 📅 Date

23 April 2026

---

## 🎯 Goal

Understand how Kubernetes exposes applications using **Services** and how networking works inside and outside the cluster.

---

## 🧠 Core Concepts

### 🔹 Pod Networking

* Each Pod gets its own IP (e.g., `10.244.x.x`)
* Containers inside a Pod share the same IP
* Must use correct application port (e.g., `:8000`)

---

### 🔹 Service

* Provides a **stable way to access Pods**
* Uses **labels & selectors** to route traffic
* Acts as a bridge between users and Pods

---

### 🔹 Types of Services

| Type         | Usage                                      |
| ------------ | ------------------------------------------ |
| ClusterIP    | Internal communication (inside cluster)    |
| NodePort     | Access from outside via Node IP + Port     |
| LoadBalancer | Public access (cloud or simulated locally) |

---

## 🔄 Traffic Flow

```text
User → Service → kube-proxy → Pod → Application
```

---

## ⚙️ Service YAML (NodePort Example)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-python-app
  spec:
    type: NodePort
      selector:
          app: sample-python-app
	    ports:
	        - port: 80
		      targetPort: 8000
		            nodePort: 30007
			    ```

			    ---

			    ## 🔧 Commands Practiced

			    ```bash
			    kubectl get pods
			    kubectl get svc
			    kubectl describe svc my-python-app
			    kubectl apply -f service.yaml
			    kubectl port-forward service/my-python-app 8080:80
			    minikube ssh
			    ```

			    ---

			    ## 🔍 Observations

			    * Deployment created 2 Pods successfully
			    * Faced `ImagePullBackOff` → fixed using `minikube image load`
			    * Verified app using Pod IP + port (`10.x.x.x:8000`)
			    * Service (ClusterIP) worked inside Minikube
			    * NodePort did not work from host (Docker driver limitation)
			    * LoadBalancer required `minikube tunnel`

			    ---

			    ## ⚠️ Challenges & Learnings

			    * Docker driver isolates Minikube network → NodePort not accessible
			    * LoadBalancer shows `<pending>` without cloud or tunnel
			    * `minikube tunnel` failed due to SSH compatibility issue
			    * Local IIS intercepted `127.0.0.1` traffic (important debugging insight)

			    ---

			    ## ✅ Working Solution

			    ```bash
			    kubectl port-forward service/my-python-app 8080:80
			    ```

			    Then access:

			    ```text
			    http://localhost:8080/demo
			    ```

			    ---

			    ## 🧠 Key Takeaways

			    * Pod IP = dynamic → not reliable
			    * Service = stable access point
			    * kube-proxy handles traffic routing
			    * NodePort/LoadBalancer depend on environment
			    * Port-forward is the most reliable local access method

			    ---

			    ## 🌐 Additional Concept

			    ### 🔹 MetalLB

			    * Provides external IPs for LoadBalancer in local/on-prem clusters
			    * Acts as a replacement for cloud load balancer

			    ---

			    ## 🎯 Final Understanding

			    > Kubernetes networking revolves around Services, which provide stable access to dynamically changing Pods, while kube-proxy ensures correct traffic routing across the cluster.

			    ---

