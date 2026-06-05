# Revision 03 - Kubernetes Networking & Ingress

**Date:** 05 June 2026

---

# Topics Revised

## 1. Kubernetes Services

### Why Services are Needed

Pods are temporary.

Example:

```text
Pod IP = 10.244.0.23
```

If a Pod dies:

```text
10.244.0.23 ❌
10.244.0.25 ✅
```

Applications depending on Pod IPs will break.

Services provide:

* Stable IP
* Stable DNS
* Load Balancing

---

## 2. ClusterIP Service

Default Kubernetes Service type.

Example:

```yaml
type: ClusterIP
```

Purpose:

```text
Internal communication only
```

Used for:

* Frontend → Backend
* Backend → Database
* Backend → Redis
* Service → Service communication

Example:

```text
frontend-service
    |
    backend-pods
    ```

    ---

    ## 3. NodePort Service

    Purpose:

    ```text
    Expose application outside cluster
    ```

    Example:

    ```yaml
    type: NodePort
    ```

    Kubernetes automatically opens a port on every node.

    Example:

    ```text
    Node IP      = 192.168.49.2
    NodePort     = 30889
    ```

    Access:

    ```text
    http://192.168.49.2:30889
    ```

    Traffic Flow:

    ```text
    Browser
       |
       NodeIP:30889
          |
	  NodePort
	     |
	     ClusterIP Service
	        |
		Pods
		```

		Key Learning:

		NodePort is built on top of ClusterIP.

		---

		## 4. Service Components

		Observed:

		```text
		Pod IP       = 10.244.0.23
		ClusterIP    = 10.101.165.16
		NodePort     = 30889
		Node IP      = 192.168.49.2
		```

		Understanding:

		```text
		Node IP      = Machine Address
		Pod IP       = Pod Address
		ClusterIP    = Service Address
		NodePort     = External Access Point
		```

		---

		## 5. Endpoints

		Command:

		```bash
		kubectl get endpoints
		```

		Example:

		```text
		10.244.0.23:80
		```

		Endpoints represent the actual Pods behind a Service.

		Flow:

		```text
		Service
		   |
		   Endpoints
		      |
		      Pods
		      ```

		      ---

		      ## 6. Ingress

		      ### Why Ingress?

		      Without Ingress:

		      ```text
		      Frontend -> LoadBalancer
		      Backend  -> LoadBalancer
		      Admin    -> LoadBalancer
		      ```

		      Many applications require many LoadBalancers.

		      Expensive and difficult to manage.

		      ---

		      ### Ingress Solution

		      Provides:

		      ```text
		      Single Entry Point
		      Path Routing
		      Host Routing
		      ```

		      Architecture:

		      ```text
		      Internet
		          |
			  Ingress
			      |
			      ----------------
			      |              |
			      Frontend     Backend
			      Service      Service
			      ```

			      ---

			      ## 7. Path-Based Routing

			      Created:

			      ```yaml
			      /api  -> backend-service
			      /     -> frontend-service
			      ```

			      Example:

			      ```text
			      myapp.com/api
			              |
				       backend-service
				       ```

				       ```text
				       myapp.com/
				               |
					        frontend-service
						```

						Ingress routes requests based on URL paths.

						---

						## 8. Ingress Components

						Created:

						```text
						frontend-deployment
						frontend-service

						backend-deployment
						backend-service

						my-ingress
						```

						Ingress Rules:

						```text
						/api -> backend-service
						/    -> frontend-service
						```

						Observed:

						```text
						backend-service:80
						frontend-service:80
						```

						mapped successfully inside Ingress.

						---

						## 9. Deployment Self-Healing Revision

						Deleted Pod:

						```bash
						kubectl delete pod <pod-name>
						```

						Observed:

						```text
						Old Pod Deleted
						New Pod Created Automatically
						```

						Reason:

						Deployment maintains desired state.

						---

						## Important Commands Practiced

						Create Service:

						```bash
						kubectl expose deployment nginx-deployment \
						--type=NodePort \
						--port=80
						```

						View Services:

						```bash
						kubectl get svc -o wide
						```

						View Endpoints:

						```bash
						kubectl get endpoints
						```

						Describe Service:

						```bash
						kubectl describe svc <service-name>
						```

						Create Ingress:

						```bash
						kubectl create -f path_ingress.yaml
						```

						View Ingress:

						```bash
						kubectl get ingress
						```

						Describe Ingress:

						```bash
						kubectl describe ingress my-ingress
						```

						---

						# Key Learnings

						1. Pods are temporary.
						2. Services provide stable access to Pods.
						3. ClusterIP is used for internal communication.
						4. NodePort exposes applications externally.
						5. NodePort is built on top of ClusterIP.
						6. Endpoints represent actual backend Pods.
						7. Ingress routes traffic to different Services.
						8. Ingress supports path-based routing.
						9. Deployments automatically recreate deleted Pods.
						10. Kubernetes networking follows:

						```text
						Ingress
						   |
						   Service
						      |
						      Endpoints
						         |
							 Pods
							 ```

							 ---

							 # Interview Notes

							 ### What problem does a Service solve?

							 Services provide stable networking for Pods whose IPs may change after recreation.

							 ---

							 ### Difference between ClusterIP and NodePort?

							 ClusterIP:

							 ```text
							 Internal Access Only
							 ```

							 NodePort:

							 ```text
							 External Access via NodeIP:Port
							 ```

							 ---

							 ### What is an Endpoint?

							 Endpoints are the actual Pod IPs that receive traffic from a Service.

							 ---

							 ### What is Ingress?

							 Ingress is a Kubernetes resource that routes external HTTP/HTTPS traffic to different Services based on paths or hostnames.

							 ---

							 ### How does traffic flow in Kubernetes?

							 ```text
							 User
							   |
							   Ingress
							     |
							     Service
							       |
							       Endpoints
							         |
								 Pods
								 ```

