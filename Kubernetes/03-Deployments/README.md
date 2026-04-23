# Kubernetes Deployments & Services - Learning Summary 🚀

## 📅 Date

22 April 2026

---

## 🎯 Goal

Understand how to run applications in Kubernetes using **Deployments** and expose them using **Services**.

---

## 🧠 Core Concepts

### 🔹 Deployment

* Manages Pods automatically
* Ensures desired number of Pods are always running (`replicas`)
* Handles:

  * Auto-healing (recreates failed Pods)
    * Scaling (increase/decrease Pods)
      * Rolling updates

      ---

      ### 🔹 Flow

      ```text
      Deployment → ReplicaSet → Pods → Containers
      ```

      ---

      ### 🔹 Labels & Selectors

      * Pods are tagged using **labels**
      * Services use **selectors** to find and route traffic to Pods

      ---

      ## ⚙️ Deployment YAML (example)

      ```yaml id="2g7y4g"
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx-deployment
	spec:
	  replicas: 3
	    selector:
	        matchLabels:
		      app: nginx
		        template:
			    metadata:
			          labels:
				          app: nginx
					      spec:
					            containers:
						          - name: nginx
							          image: nginx
								  ```

								  ---

								  ## 🔧 Commands Used

								  ```bash id="pswdv6"
								  kubectl create deployment nginx-deployment --image=nginx
								  kubectl get deployments
								  kubectl get pods
								  kubectl get pods -o wide
								  kubectl get pods -w
								  ```

								  ---

								  ## 🌐 Services

								  ### 🔹 Why Services?

								  * Pod IPs are dynamic (change on restart)
								  * Services provide **stable access to Pods**

								  ---

								  ### 🔹 Types of Services

								  | Type         | Access                        |
								  | ------------ | ----------------------------- |
								  | ClusterIP    | Internal only (default)       |
								  | NodePort     | Accessible from local machine |
								  | LoadBalancer | Public internet (cloud only)  |

								  ---

								  ## ⚙️ Creating Service

								  ```bash id="fgk6bp"
								  kubectl expose deployment nginx-deployment --type=NodePort --port=80
								  ```

								  ---

								  ## 🔍 Service Output

								  ```bash id="0v8bz6"
								  kubectl get svc
								  ```

								  Example:

								  ```text id="8x1x8c"
								  nginx-deployment   NodePort   10.x.x.x   <none>   80:31414/TCP
								  ```

								  * `ClusterIP` → internal IP
								  * `NodePort` → external port

								  ---

								  ## 🌐 Accessing Application

								  ### ❌ Not working:

								  ```text id="m5m4f0"
								  http://<ClusterIP>:80
								  ```

								  ---

								  ### ✅ Working (Windows + Docker driver):

								  ```bash id="6p9h3r"
								  kubectl port-forward service/nginx-deployment 8080:80
								  ```

								  Then open:

								  ```text id="8nm9sd"
								  http://localhost:8080
								  ```

								  ---

								  ## 🧠 Key Takeaways

								  * Deployment manages Pods (not Pods directly)
								  * ReplicaSet ensures desired number of Pods
								  * Services provide stable access using labels
								  * NodePort exposes app outside cluster
								  * ClusterIP works only inside cluster
								  * On Windows (Docker driver), use **port-forward** or tunnel

								  ---

								  ## 🎯 Final Understanding

								  > Kubernetes runs apps using Deployments and exposes them using Services, allowing reliable, scalable, and accessible applications.

								  ---

