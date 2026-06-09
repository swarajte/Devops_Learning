# 09 - Custom Resources, CRDs & Controllers 🚀

## 📅 Date

09 June 2026

---

# 🎯 Goal

Understand:

* Custom Resource (CR)
* Custom Resource Definition (CRD)
* Custom Controller
* How Kubernetes APIs can be extended
* Basic controller workflow (Watch → Queue → Worker → Reconcile)

---

# 🧠 Why CRDs Exist?

Kubernetes already knows built-in resources:

* Pod
* Deployment
* Service
* ConfigMap
* Secret

Sometimes applications need new resource types such as:

* Database
* Website
* Kafka
* Certificate
* Backup

CRDs allow us to add new resource types to Kubernetes without modifying Kubernetes source code.

---

# 🧠 CRD (Custom Resource Definition)

CRD teaches Kubernetes about a new resource type.

Example:

```text
Website
```

After creating a CRD:

```bash
kubectl api-resources
```

shows the new resource.

Think:

```text
CRD = Blueprint / Schema
```

---

# 🧠 Custom Resource (CR)

A Custom Resource is an actual object created from the CRD.

Example:

```yaml
apiVersion: demo.com/v1
kind: Website

metadata:
  name: my-site

  spec:
    image: nginx
    ```

    Think:

    ```text
    CR = Actual Object
    ```

    ---

    # 🧠 What We Implemented

    Created CRD:

    ```yaml
    kind: CustomResourceDefinition
    name: websites.demo.com
    ```

    Created Custom Resource:

    ```yaml
    kind: Website
    name: my-site
    ```

    Verified:

    ```bash
    kubectl get websites
    kubectl describe website my-site
    ```

    Output showed Kubernetes successfully storing the object.

    ---

    # 🧠 Important Observation

    After creating:

    ```yaml
    kind: Website
    ```

    No Pod was created.

    ```bash
    kubectl get pods
    ```

    showed no new pods.

    Reason:

    ```text
    CRD exists ✅
    CR exists ✅
    Controller does NOT exist ❌
    ```

    Kubernetes only stores the object in etcd.

    Nothing reacts to it.

    ---

    # 🧠 Why Controllers Are Needed?

    Controller gives meaning to a resource.

    Example:

    ```text
    Website Object
          ↓
	  Controller Watches
	        ↓
		Creates Deployment
		      ↓
		      Creates Pods
		      ```

		      Without Controller:

		      ```text
		      Website = Data in etcd
		      ```

		      With Controller:

		      ```text
		      Website = Running Application
		      ```

		      ---

		      # 🧠 Controller Responsibilities

		      Controllers react to:

		      ### Create Event

		      ```text
		      New object created
		      ```

		      Example:

		      ```text
		      Website created
		      ↓
		      Create Pod
		      ```

		      ---

		      ### Update Event

		      ```text
		      Object modified
		      ```

		      Example:

		      ```text
		      image: nginx
		      ↓
		      image: apache
		      ```

		      Controller updates workload.

		      ---

		      ### Delete Event

		      ```text
		      Object removed
		      ```

		      Controller removes associated resources.

		      ---

		      # 🧠 Watcher, Queue & Worker

		      Controllers generally work as:

		      ```text
		      Watch
		        ↓
			Queue
			  ↓
			  Worker
			    ↓
			    Reconcile
			    ```

			    ### Watcher

			    Monitors API Server for:

			    * Create
			    * Update
			    * Delete

			    events.

			    ---

			    ### Queue

			    Stores pending work.

			    Prevents controllers from processing thousands of events simultaneously.

			    ---

			    ### Worker

			    Consumes tasks from queue and executes controller logic.

			    ---

			    ### Reconcile Loop

			    Main job of a controller:

			    ```text
			    Desired State
			          vs
				  Current State
				  ```

				  If different:

				  ```text
				  Fix the cluster
				  ```

				  Example:

				  ```text
				  Desired Pods = 3
				  Current Pods = 2
				  ```

				  Controller creates 1 additional pod.

				  ---

				  # 🧠 Extending Kubernetes API

				  CRDs extend Kubernetes API.

				  Before CRD:

				  ```bash
				  kubectl get pods
				  kubectl get deployments
				  ```

				  After CRD:

				  ```bash
				  kubectl get websites
				  ```

				  New API endpoint becomes available.

				  ---

				  # 🧠 Operator

				  Operator is:

				  ```text
				  CRD + Custom Controller
				  ```

				  Examples:

				  * Prometheus Operator
				  * Cert Manager
				  * ArgoCD Operators
				  * Kafka Operators

				  ---

				  # 🧠 Lab Files

				  ```text
				  CRD.yaml
				  website.yaml
				  controller.sh
				  ```

				  ---

				  # 🎯 Final Understanding

				  ```text
				  CRD = Define new resource type

				  CR = Create an object of that type

				  Controller = Watches the object and takes action

				  Operator = CRD + Controller
				  ```

				  ---

				  # 💡 One-Line Summary

				  Custom Resources allow Kubernetes to understand new object types, while Controllers continuously watch those objects and convert user intent into actual cluster resources.

