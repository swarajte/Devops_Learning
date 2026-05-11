BAC (Role Based Access Control) 🔐

## 📅 Date

11 May 2026

---

# 🎯 Goal

Learn Kubernetes RBAC basics and understand:

* What RBAC is
* Why RBAC is needed
* Difference between Users and ServiceAccounts
* Roles & RoleBindings
* Hands-on creation of:

  * ServiceAccount
    * Role
      * RoleBinding
        * Pod using custom ServiceAccount

	---

	# 🧠 What is RBAC?

	RBAC means:

	Role Based Access Control

	Used to decide:

	WHO can do WHAT in Kubernetes

	---

	# 🧠 Real Life Example

	In a company office:

	* Employees have different permissions
	* Managers can access more systems
	* Interns get limited access

	Kubernetes works similarly.

	---

	# 🧠 Why RBAC is Needed?

	Without RBAC:

	Any user/application could perform dangerous operations

	Example:

	```bash
	kubectl delete pods --all
	```

	RBAC helps secure cluster access.

	---

	# 🧠 Authentication vs Authorization

	## 🔹 Authentication

	Checks:

	WHO are you?

	Handled by:

	Identity Providers

	Examples:

	* Active Directory
	* Okta
	* Google
	* AWS IAM

	---

	## 🔹 Authorization

	Checks:

	What are you allowed to do?

	Handled by:

	RBAC

	---

	# 🧠 Identity Providers in Simple Words

	Kubernetes usually does NOT manage human users directly.

	Companies use external login systems:

	Identity Providers

	They verify user identity.

	Example flow:

	```text
	User logs in
	↓
	Identity Provider verifies user
	↓
	RBAC checks permissions
	```

	---

	# 🧠 Users vs ServiceAccounts

	## 👨 Users

	Human identities.

	Examples:

	* DevOps engineers
	* Developers
	* Admins

	Usually managed externally using Identity Providers.

	---

	## 🤖 ServiceAccounts

	Identities for:

	* Pods
	* Applications
	* Controllers

	Managed INSIDE Kubernetes.

	---

	# 🧠 Very Important Understanding

	Pods do NOT directly get Roles.

	Flow is:

	```text
	Pod
	 ↓
	 ServiceAccount
	  ↓
	  RoleBinding
	   ↓
	   Role
	   ```

	   ---

	   # 🧠 Default ServiceAccount

	   Every namespace automatically gets:

	   default ServiceAccount

	   Pods use it automatically unless custom ServiceAccount is specified.

	   ---

	   # 🧠 Checked Existing ServiceAccounts

	   Command:

	   ```bash
	   kubectl get serviceaccount
	   ```

	   ---

	   # 🧠 Checked Pod ServiceAccount

	   Command:

	   ```bash
	   kubectl describe pod demo-pod
	   ```

	   Observed:

	   ```text
	   Service Account: demo-sa
	   ```

	   ---

	   # 🧠 Core RBAC Components

	   ## 🔹 1) Role

	   Defines:

	   WHAT actions are allowed

	   inside:

	   ONE namespace

	   Example:

	   * Can view pods
	   * Can list pods

	   ---

	   ## 🔹 2) ClusterRole

	   Same as Role BUT works across:

	   ENTIRE cluster

	   Example:

	   View all cluster nodes

	   ---

	   ## 🔹 3) RoleBinding

	   Connects:

	   WHO ↔ ROLE

	   inside one namespace.

	   ---

	   ## 🔹 4) ClusterRoleBinding

	   Connects:

	   WHO ↔ ClusterRole

	   across entire cluster.

	   ---

	   # 🧠 Simple Mental Model

	   ```text
	   Role = permissions
	   Binding = assignment
	   ```

	   ---

	   # 🧠 Hands-On Performed

	   ## 🔹 Created ServiceAccount

	   Created:

	   demo-sa

	   YAML:

	   ```yaml
	   apiVersion: v1
	   kind: ServiceAccount
	   metadata:
	     name: demo-sa
	     ```

	     Applied using:

	     ```bash
	     kubectl apply -f serviceaccount.yaml
	     ```

	     ---

	     ## 🔹 Created Role

	     Created role:

	     pod-reader

	     Permissions:

	     * get pods
	     * list pods

	     YAML:

	     ```yaml
	     apiVersion: rbac.authorization.k8s.io/v1
	     kind: Role
	     metadata:
	       name: pod-reader

	       rules:
	       - apiGroups: [""]
	         resources: ["pods"]
		   verbs: ["get", "list"]
		   ```

		   ---

		   ## 🔹 Created RoleBinding

		   Connected:

		   demo-sa ↔ pod-reader

		   YAML:

		   ```yaml
		   apiVersion: rbac.authorization.k8s.io/v1
		   kind: RoleBinding
		   metadata:
		     name: read-pods-binding

		     subjects:
		     - kind: ServiceAccount
		       name: demo-sa
		         namespace: default

			 roleRef:
			   kind: Role
			     name: pod-reader
			       apiGroup: rbac.authorization.k8s.io
			       ```

			       ---

			       # 🧠 Error Faced

			       Mistyped:

			       k9s

			       instead of:

			       k8s

			       in:

			       ```yaml
			       apiGroup: rbac.authorization.k8s.io
			       ```

			       Important learning:

			       Most Kubernetes YAML issues are small typos/spacing mistakes

			       ---

			       ## 🔹 Created Pod Using Custom ServiceAccount

			       YAML:

			       ```yaml
			       apiVersion: v1
			       kind: Pod
			       metadata:
			         name: demo-pod

				 spec:
				   serviceAccountName: demo-sa

				     containers:
				       - name: nginx
				           image: nginx
					   ```

					   ---

					   # 🧠 Most Important Line

					   ```yaml
					   serviceAccountName: demo-sa
					   ```

					   Meaning:

					   Pod now uses demo-sa identity

					   ---

					   # 🧠 Verified Pod

					   Command:

					   ```bash
					   kubectl describe pod demo-pod
					   ```

					   Observed:

					   ```text
					   Service Account: demo-sa
					   ```

					   ---

					   # 🎯 Final Understanding

					   ```text
					   Users = Human identities
					   ServiceAccounts = Pod/Application identities

					   Role = Permissions
					   RoleBinding = Assign permissions

					   RBAC = Permission management system for Kubernetes
					   ```

					   ---

					   # 💡 Final One-Line Summary

					   Kubernetes RBAC controls access by assigning Roles or ClusterRoles to Users or ServiceAccounts using RoleBindings or ClusterRoleBindings.

