# Revision 04 - Namespaces & RBAC

**Date:** 08 June 2026

---

# Topics Revised

## 1. Kubernetes Namespaces

### Why Namespaces?

Namespaces provide logical separation inside a Kubernetes cluster.

Without namespaces:

```text
dev-team nginx
qa-team nginx
prod-team nginx
```

would create naming conflicts.

With namespaces:

```text
dev/nginx
qa/nginx
prod/nginx
```

can coexist.

---

### Real World Usage

Typical Production Cluster:

```text
Cluster
├── dev
├── qa
├── staging
├── prod
├── monitoring
└── logging
```

Benefits:

* Resource Isolation
* Team Separation
* Environment Separation
* RBAC Integration

---

### Common Commands

Create Namespace:

```bash
kubectl create ns dev
```

List Namespaces:

```bash
kubectl get ns
```

Deploy Into Namespace:

```bash
kubectl apply -f deployment.yaml -n dev
```

---

## 2. RBAC (Role Based Access Control)

### What Problem Does RBAC Solve?

RBAC controls:

```text
WHO
can do WHAT
on WHICH resource
```

Example:

```text
Developer
  ✓ View Pods
    ✓ View Logs

      ✗ Delete Namespace
        ✗ Modify Production
	```

	---

	### Core Components

	#### Role

	Defines permissions.

	Example:

	```text
	Can:
	get pods
	list pods
	watch pods
	```

	Think:

	```text
	Role = Permission Set
	```

	---

	#### RoleBinding

	Assigns a Role.

	Think:

	```text
	RoleBinding = Permission Assignment
	```

	Example:

	```text
	Developer
	     |
	     RoleBinding
	          |
		  Role
		  ```

		  ---

		  #### ClusterRole

		  Cluster-wide permissions.

		  Used for:

		  ```text
		  Nodes
		  PersistentVolumes
		  Namespaces
		  ```

		  ---

		  #### ClusterRoleBinding

		  Assigns ClusterRole permissions.

		  ---

		  ## 3. ServiceAccount

		  ### What is a ServiceAccount?

		  A ServiceAccount is an identity used by Pods.

		  Example:

		  ```yaml
		  apiVersion: v1
		  kind: ServiceAccount

		  metadata:
		    name: demo-sa
		    ```

		    Think:

		    ```text
		    ServiceAccount = Kubernetes User
		    ```

		    ---

		    ## 4. Practical RBAC Lab

		    Created:

		    ```text
		    ServiceAccount:
		    demo-sa
		    ```

		    Created:

		    ```text
		    Role:
		    pod-reader
		    ```

		    Permissions:

		    ```text
		    pods:
		      get
		        list
			```

			Created:

			```text
			RoleBinding:
			read-pods-binding
			```

			Binding:

			```text
			demo-sa
			    ↓
			    RoleBinding
			        ↓
				pod-reader
				```

				---

				## 5. Pod Using ServiceAccount

				Created Pod:

				```yaml
				serviceAccountName: demo-sa
				```

				Flow:

				```text
				Pod
				 ↓
				 ServiceAccount
				  ↓
				  RoleBinding
				   ↓
				   Role
				    ↓
				    Permissions
				    ```

				    ---

				    ## 6. RBAC Verification

				    Verified using:

				    ```bash
				    kubectl auth can-i
				    ```

				    Results:

				    ```bash
				    kubectl auth can-i list pods \
				    --as=system:serviceaccount:default:demo-sa
				    ```

				    Output:

				    ```text
				    yes
				    ```

				    ---

				    ```bash
				    kubectl auth can-i get pods \
				    --as=system:serviceaccount:default:demo-sa
				    ```

				    Output:

				    ```text
				    yes
				    ```

				    ---

				    ```bash
				    kubectl auth can-i delete pods \
				    --as=system:serviceaccount:default:demo-sa
				    ```

				    Output:

				    ```text
				    no
				    ```

				    ---

				    ```bash
				    kubectl auth can-i create pods \
				    --as=system:serviceaccount:default:demo-sa
				    ```

				    Output:

				    ```text
				    no
				    ```

				    ---

				    ### Understanding The Result

				    Role Permissions:

				    ```text
				    get
				    list
				    ```

				    Allowed:

				    ```text
				    ✓ View Pods
				    ✓ List Pods
				    ```

				    Denied:

				    ```text
				    ✗ Create Pods
				    ✗ Delete Pods
				    ✗ Update Pods
				    ```

				    ---

				    ## 7. Authentication vs Authorization

				    Very Common Interview Question.

				    ### Authentication

				    Question:

				    ```text
				    Who are you?
				    ```

				    Handled by:

				    ```text
				    ServiceAccount Token
				    ```

				    ---

				    ### Authorization

				    Question:

				    ```text
				    What are you allowed to do?
				    ```

				    Handled by:

				    ```text
				    RBAC
				    ```

				    ---

				    Flow:

				    ```text
				    Pod
				     ↓
				     ServiceAccount Token
				      ↓
				      API Server
				       ↓
				       RBAC Check
				        ↓
					Allow / Deny
					```

					---

					## 8. ServiceAccount Token

					Kubernetes automatically mounts:

					```text
					/var/run/secrets/kubernetes.io/serviceaccount
					```

					inside Pods.

					Contains:

					```text
					token
					namespace
					ca.crt
					```

					Purpose:

					```text
					Authenticate Pod with Kubernetes API Server
					```

					---

					# Key Learnings

					1. Namespaces provide logical isolation.
					2. RBAC controls access to cluster resources.
					3. Role defines permissions.
					4. RoleBinding assigns permissions.
					5. ServiceAccount provides Pod identity.
					6. Pods authenticate using ServiceAccount tokens.
					7. RBAC authorizes actions after authentication.
					8. kubectl auth can-i is used to verify permissions.
					9. Roles are namespace scoped.
					10. ClusterRoles are cluster scoped.

					---

					# Interview Notes

					### What is RBAC?

					RBAC is Kubernetes authorization mechanism that controls who can perform which actions on which resources.

					---

					### Difference Between Role and ClusterRole?

					Role:

					```text
					Namespace Scoped
					```

					ClusterRole:

					```text
					Cluster Scoped
					```

					---

					### Difference Between Authentication and Authorization?

					Authentication:

					```text
					Who are you?
					```

					Authorization:

					```text
					What can you do?
					```

					---

					### How Does A Pod Authenticate With Kubernetes API?

					A Pod uses a ServiceAccount token mounted inside the container. The API Server validates the token and RBAC determines the permissions available to that Pod.

					---

					### RBAC Architecture

					```text
					Pod
					  ↓
					  ServiceAccount
					    ↓
					    RoleBinding
					      ↓
					      Role
					        ↓
						Permissions
						```

