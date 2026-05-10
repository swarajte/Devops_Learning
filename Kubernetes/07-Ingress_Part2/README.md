Kubernetes Ingress - Part 2 🚀
📅 Date

10 May 2026

🎯 Goal

Continue learning Kubernetes Ingress by:

Understanding Host-Based Ingress
Understanding how Ingress Controllers work internally
Understanding SSL concepts in Ingress
Troubleshooting real Ingress Controller issues
🧠 Quick Revision - What is Ingress?

Ingress is used to expose multiple services using:

ONE entry point

instead of:

Multiple LoadBalancers / NodePorts
🧠 Traffic Flow
Browser
   ↓
   Ingress Controller
      ↓
      Service
         ↓
	 Pods
	 🧠 Difference Between Path-Based & Host-Based Ingress
	 🔹 Path-Based Ingress

	 Routes traffic using URL paths.

	 Example
	 myapp.com/api  → backend-service
	 myapp.com/     → frontend-service
	 Key Idea
	 Same domain → different paths
	 🔹 Host-Based Ingress

	 Routes traffic using host/domain names.

	 Example
	 api.myapp.com         → backend-service
	 frontend.myapp.com    → frontend-service
	 Key Idea
	 Different domains → different services
	 🧠 Host-Based Ingress YAML Created

	 Created:

	 host-based-ing.yaml

	 Routing rules:

	 frontend.myapp.com → frontend-service
	 api.myapp.com → backend-service
	 🧠 Why hosts File Was Modified

	 Since real DNS was not available locally, entries were added in Windows hosts file:

	 127.0.0.1 frontend.myapp.com
	 127.0.0.1 api.myapp.com

	 This makes local machine resolve custom domains to localhost.

	 🧠 Important Ingress Understanding
	 Ingress Resource

	 Ingress YAML only defines:

	 Routing rules

	 Example:

	 /api → backend-service
	 Ingress Controller

	 Actual software that applies routing rules.

	 Examples:

	 NGINX Ingress Controller
	 Traefik
	 HAProxy
	 AWS Load Balancer Controller
	 🧠 Core Understanding
	 Ingress = WHAT routing should happen
	 Ingress Controller = HOW routing actually happens
	 🧠 How Ingress Controllers Work
	 User creates Ingress YAML
	 Kubernetes stores ingress resource
	 Ingress Controller watches Kubernetes API
	 Controller converts rules into actual routing configuration
	 Traffic starts routing to services
	 🧠 SSL/TLS Concepts Learned
	 🔹 SSL Offloading
	 Browser --HTTPS--> Ingress --HTTP--> App

	 Ingress removes encryption.

	 Backend receives normal HTTP traffic.

	 Most commonly used in companies.

	 🔹 SSL Bridging
	 Browser --HTTPS--> Ingress --HTTPS--> App

	 Traffic remains encrypted even inside cluster.

	 Used in highly secure environments.

	 🧠 minikube tunnel Understanding

	 Command:

	 minikube tunnel

	 Purpose:

	 Creates network bridge between laptop and Minikube cluster

	 Flow:

	 Browser → Tunnel → Ingress → Service → Pods

	 Used mainly for:

	 LoadBalancer services
	 Ingress access
	 🧠 Main Issue Faced

	 While applying ingress:

	 kubectl apply -f host-based-ing.yaml

	 Received error:

	 failed calling webhook
	 connection refused
	 🧠 Root Cause Analysis

	 Checked ingress pods:

	 kubectl get pods -n ingress-nginx

	 Observed:

	 ImagePullBackOff
	 ErrImagePull
	 ContainerCreating
	 🧠 Meaning of Errors
	 ImagePullBackOff

	 Kubernetes unable to download required image.

	 ErrImagePull

	 Image download failed.

	 ContainerCreating

	 Container waiting for dependencies/resources.

	 🧠 Actual Root Cause

	 Minikube unable to access:

	 https://registry.k8s.io

	 Earlier TLS/certificate errors were also observed:

	 x509: certificate signed by unknown authority

	 Meaning:

	 Problem was infrastructure/network related
	 NOT ingress YAML related
	 🧠 Commands Learned
	 Enable Ingress Addon
	 minikube addons enable ingress

	 Installs NGINX Ingress Controller.

	 Watch Ingress Pods
	 kubectl get pods -n ingress-nginx -w

	 Watches pod status live.

	 Describe Pod
	 kubectl describe pod -n ingress-nginx <pod-name>

	 Used for debugging events/errors.

	 Start Tunnel
	 minikube tunnel

	 Creates route between laptop and cluster networking.

	 🧠 Biggest Learning Today

	 Most Kubernetes problems are often:

	 Networking / DNS / Image Registry issues

	 and not YAML syntax issues.

	 🚧 Current Status
	 Deployments → Working ✅
	 Services → Working ✅
	 Ingress YAML → Working ✅
	 Ingress Controller → Failed ❌ (image pull issue)
	 🔧 Next Steps
	 Fix image registry access issue
	 Restart ingress controller
	 Test Host-Based Ingress fully
	 Access apps using:
	 frontend.myapp.com
	 api.myapp.com
	 🎯 Final Mental Model
	 Service → connects pods
	 Ingress → decides WHERE traffic goes
	 Ingress Controller → actually routes traffic
	 Tunnel → allows laptop to reach cluster
	 💡 Final One-Line Summary

	 Kubernetes Ingress provides a single entry point for multiple services using routing rules, while Ingress Controllers implement the actual traffic routing logic.
