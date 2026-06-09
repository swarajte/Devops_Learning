# Hands-On Summary - Custom Resources, CRDs & Controllers

## 📅 Date

09 June 2026

---

# Objective

Understand how Kubernetes can be extended using:

* Custom Resource Definitions (CRDs)
* Custom Resources (CRs)
* Controllers

---

# Lab Files

```text
CRD.yaml
website.yaml
controller.sh
```

---

# Step 1 - Created a Custom Resource Definition (CRD)

Created a new resource type:

```text
Website
```

Applied:

```bash
kubectl apply -f CRD.yaml
```

Verified:

```bash
kubectl get crd
kubectl api-resources | grep website
```

Observation:

Kubernetes learned a new API resource called:

```text
websites
```

---

# Step 2 - Created a Custom Resource (CR)

Created:

```yaml
apiVersion: demo.com/v1
kind: Website

metadata:
  name: my-site

  spec:
    image: nginx
    ```

    Applied:

    ```bash
    kubectl apply -f website.yaml
    ```

    Verified:

    ```bash
    kubectl get websites
    kubectl describe website my-site
    ```

    Observation:

    Website object was successfully stored inside Kubernetes.

    ---

    # Step 3 - Verified No Workload Was Created

    Checked:

    ```bash
    kubectl get pods
    ```

    Observation:

    No new Pod was created.

    Important Learning:

    ```text
    CRD + CR
    does NOT create anything automatically.
    ```

    Kubernetes only stores the object in etcd.

    ---

    # Step 4 - Understanding Why Controllers Are Needed

    Current State:

    ```text
    Website Resource Exists
            ↓
	    No Controller Exists
	            ↓
		    Nothing Happens
		    ```

		    Learning:

		    A controller is responsible for watching resources and taking actions.

		    Example:

		    ```text
		    Website
		       ↓
		       Controller
		          ↓
			  Deployment
			     ↓
			     Pod
			     ```

			     ---

			     # Step 5 - Created a Simple Controller Simulation

			     Created:

			     ```text
			     controller.sh
			     ```

			     Purpose:

			     ```text
			     Watch Website resource
			             ↓
				     Read image field
				             ↓
					     Create Pod automatically
					     ```

					     Controller Logic:

					     ```text
					     If Website exists
					     AND Pod does not exist

					     Create Pod using image from Website spec
					     ```

					     ---

					     # Step 6 - Controller Workflow Learned

					     Controllers generally work using:

					     ```text
					     Watch
					       ↓
					       Queue
					         ↓
						 Worker
						   ↓
						   Reconcile
						   ```

						   Watcher:

						   * Detects Create
						   * Detects Update
						   * Detects Delete

						   Queue:

						   * Stores pending tasks

						   Worker:

						   * Processes tasks

						   Reconcile:

						   * Makes actual state match desired state

						   ---

						   # Commands Used

						   ```bash
						   kubectl apply -f CRD.yaml

						   kubectl get crd

						   kubectl api-resources | grep website

						   kubectl apply -f website.yaml

						   kubectl get websites

						   kubectl describe website my-site

						   kubectl get website my-site -o yaml

						   kubectl get pods
						   ```

						   ---

						   # Key Learning

						   ```text
						   CRD = New Resource Type

						   CR = Object of that Resource Type

						   Controller = Program that Watches and Reacts

						   Operator = CRD + Controller
						   ```

						   ---

						   # Final Understanding

						   Without Controller:

						   ```text
						   Website Object
						         ↓
							 Stored in etcd
							       ↓
							       Nothing happens
							       ```

							       With Controller:

							       ```text
							       Website Object
							             ↓
								     Controller watches it
								           ↓
									   Creates Deployment / Service / Pod
									         ↓
										 Desired state achieved
										 ```

										 This lab demonstrated the complete lifecycle of extending Kubernetes with a new resource type and understanding why controllers are required to make custom resources useful.

