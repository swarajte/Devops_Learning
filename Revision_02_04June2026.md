# Day 02 Revision - Kubernetes Pods & Deployments

**Date:** 04 June 2026

---

# Topics Revised

## 1. Kubernetes Pods

### What is a Pod?

A Pod is the smallest deployable unit in Kubernetes.

A Pod can contain:

* One Container (most common)
* Multiple Containers (sidecar pattern)

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  spec:
    containers:
      - name: nginx
          image: nginx
	  ```

	  ---

	  ## 2. Creating and Viewing Pods

	  Create Pod:

	  ```bash
	  kubectl create -f simple-pod.yaml
	  ```

	  View Pods:

	  ```bash
	  kubectl get pods
	  ```

	  Detailed View:

	  ```bash
	  kubectl get pods -o wide
	  ```

	  This shows:

	  * Pod Name
	  * Pod IP
	  * Node Name
	  * Status

	  ---

	  ## 3. Pod IP

	  Example:

	  ```text
	  10.244.0.10
	  ```

	  Important:

	  Pod IP is NOT an SSH endpoint.

	  Pods do not normally run SSH servers.

	  Wrong:

	  ```bash
	  ssh user@10.244.0.10
	  ```

	  Correct:

	  ```bash
	  kubectl exec -it <pod-name> -- /bin/sh
	  ```

	  ---

	  ## 4. Accessing a Pod

	  Enter Pod Shell:

	  ```bash
	  kubectl exec -it nginx -- /bin/sh
	  ```

	  Why?

	  Pods are containers, not virtual machines.

	  Kubernetes provides:

	  ```bash
	  kubectl exec
	  ```

	  instead of SSH.

	  Memory Trick:

	  ```text
	  EC2 → SSH
	  Pod → kubectl exec
	  ```

	  ---

	  # Deployments

	  ## What is a Deployment?

	  Deployment manages Pods automatically.

	  Benefits:

	  * Self Healing
	  * Scaling
	  * Rolling Updates
	  * Rollbacks

	  Example:

	  ```yaml
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
							              image: nginx:1.14.2
								      ```

								      ---

								      ## Deployment Components

								      ### replicas

								      ```yaml
								      replicas: 3
								      ```

								      Means:

								      ```text
								      3 Pods should always exist
								      ```

								      ---

								      ### selector

								      ```yaml
								      selector:
								        matchLabels:
									    app: nginx
									    ```

									    Deployment identifies which Pods it owns.

									    ---

									    ### template

									    Defines Pod blueprint.

									    Kubernetes creates Pods using this template.

									    ---

									    # Pod vs Deployment

									    Pod:

									    ```text
									    Single Container Instance
									    ```

									    Deployment:

									    ```text
									    Manager of Pods
									    ```

									    Think:

									    ```text
									    Pod = Employee

									    Deployment = Manager
									    ```

									    ---

									    # Self Healing

									    Created Pod:

									    ```bash
									    kubectl create -f simple-pod.yaml
									    ```

									    Delete Pod:

									    ```bash
									    kubectl delete pod nginx
									    ```

									    Result:

									    ```text
									    Pod disappears permanently
									    ```

									    No one recreates it.

									    ---

									    Created Deployment:

									    ```bash
									    kubectl create -f single-pod-deployment.yaml
									    ```

									    Delete one Pod:

									    ```bash
									    kubectl delete pod <pod-name>
									    ```

									    Result:

									    ```text
									    New Pod created automatically
									    ```

									    Reason:

									    Deployment maintains desired state.

									    ---

									    # Scaling Deployments

									    Current:

									    ```yaml
									    replicas: 1
									    ```

									    Scale manually:

									    ```bash
									    kubectl scale deployment nginx-deployment --replicas=5
									    ```

									    Result:

									    ```text
									    1 Pod
									     ↓
									     5 Pods
									     ```

									     Verified using:

									     ```bash
									     kubectl get pods
									     ```

									     ---

									     # Commands Practiced

									     ```bash
									     kubectl get pods -o wide

									     kubectl get deployments -o wide

									     kubectl create -f deployment.yaml

									     kubectl delete pod <pod-name>

									     kubectl exec -it <pod-name> -- /bin/sh

									     kubectl scale deployment nginx-deployment --replicas=5
									     ```

									     ---

									     # Key Learnings

									     1. Pods are not virtual machines.
									     2. Pod IPs cannot usually be SSH'ed into.
									     3. Use kubectl exec to access a running container.
									     4. Deployments manage Pods.
									     5. Deployments provide self-healing.
									     6. Deployments provide scaling.
									     7. replicas define desired Pod count.
									     8. selector identifies managed Pods.
									     9. template defines Pod configuration.
									     10. Kubernetes constantly works to maintain desired state.

									     ---

									     # Interview Notes

									     Q: What happens if a Pod created by a Deployment is deleted?

									     Answer:

									     The Deployment automatically creates a new Pod to maintain the desired replica count.

									     ---

									     Q: How do you access a running Pod?

									     Answer:

									     ```bash
									     kubectl exec -it <pod-name> -- /bin/sh
									     ```

									     Pods are containers and usually do not run SSH servers.

									     ---

									     Q: Difference between Pod and Deployment?

									     Answer:

									     A Pod is the smallest deployable unit in Kubernetes. A Deployment manages Pods and provides self-healing, scaling, rolling updates, and rollback capabilities.

