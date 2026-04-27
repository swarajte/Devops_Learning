 Ingress - First Learning & Hands-on 🧠🚀

 ## 📅 Date

 27 April 2026

 ---

 # 🎯 Why I Learned This

 Till now, I knew:

 * Pods → run containers
 * Deployments → manage pods
 * Services → expose pods

 But problem was:

 ```text
 Multiple services = multiple IPs / ports ❌
 ```

 Example:

 ```text
 http://IP:30001 → frontend
 http://IP:30002 → backend
 ```

 👉 Not practical in real world

 ---

 # 💡 What Problem Ingress Solves

 ```text
 ONE entry point → route to multiple services ✅
 ```

 ---

 # 🧠 Core Idea (MOST IMPORTANT)

 ```text
 Ingress = Routing Rules
 Ingress Controller = Engine that applies rules
 ```

 ---

 # 🧠 How Traffic Flows

 ```text
 User → Ingress → Service → Pod → Container
 ```

 👉 This is the full flow — remember this

 ---

 # 🧠 What I Built Today

 Inside `demo/`:

 ```text
 Frontend (nginx)
 Backend (nginx)
 2 Services
 1 Ingress
 ```

 ---

 # 🔀 Routing Logic I Defined

 ```text
 /        → frontend-service
 /api     → backend-service
 ```

 ---

 # 🧠 How Ingress Decides

 👉 It checks:

 ```text
 URL path
 ```

 Example:

 ```text
 /myapp.com        → frontend
 /myapp.com/api    → backend
 ```

 ---

 # 🧠 Important Concept (CRITICAL)

 ```text
 path: /     → matches EVERYTHING
 path: /api  → matches only /api
 ```

 👉 So order matters:

 ```text
 /api FIRST
 /    SECOND
 ```

 ---

 # 🧠 Types of Ingress (learned today)

 ---

 ## 🔹 Path-Based

 ```text
 Same domain → different paths
 ```

 Example:

 ```text
 /myapp.com/api → backend
 ```

 ---

 ## 🔹 Host-Based

 ```text
 Different domains
 ```

 Example:

 ```text
 api.myapp.com → backend
 frontend.myapp.com → frontend
 ```

 ---

 # 🧠 Key Difference (VERY IMPORTANT)

 ```text
 LoadBalancer → distributes traffic
 Ingress → routes traffic
 ```

 ---

 # ⚙️ What I Created

 ### 🔹 Deployments

 * frontend-deployment (nginx)
 * backend-deployment (nginx)

 ---

 ### 🔹 Services (ClusterIP)

 👉 Why ClusterIP?

 ```text
 Ingress talks to Services internally
 ```

 ---

 ### 🔹 Ingress YAML

 👉 Defined routing rules

 ---

 # ⚠️ Real Issues Faced (IMPORTANT LEARNING)

 ---

 ## ❌ 1. Ingress not enabling

 ```text
 context deadline exceeded
 ```

 👉 Means:
 Ingress controller pods not starting

 ---

 ## ❌ 2. ImagePullBackOff

 ```text
 Pods unable to pull images
 ```

 ---

 ## ❌ 3. TLS Error

 ```text
 x509: certificate signed by unknown authority
 ```

 ---

 # 🧠 ROOT CAUSE (BIG LEARNING)

 ```text
 Cluster cannot access image registry (network issue)
 ```

 👉 Not Kubernetes problem
 👉 Network / SSL / proxy issue

 ---

 # 🧠 Debugging Steps I Learned

 ```text
 kubectl get pods -n ingress-nginx
 kubectl describe pod
 minikube ssh
 docker pull <image>
 ```

 ---

 # 💡 BIGGEST TAKEAWAYS

 ---

 ## 🔥 1

 ```text
 Ingress DOES NOT work alone
 ```

 👉 Needs:

 ```text
 Ingress Controller
 ```

 ---

 ## 🔥 2

 ```text
 Ingress = rules only
 Controller = actual routing
 ```

 ---

 ## 🔥 3

 ```text
 Cluster depends on external registries
 ```

 👉 If network fails → cluster breaks

 ---

 ## 🔥 4

 ```text
 Debugging > commands
 ```

 ---

 # 🚧 Current Status

 ```text
 Deployments → Working ✅
 Services → Working ✅
 Ingress YAML → Ready ✅
 Ingress Controller → Not working ❌ (network issue)
 ```

 ---

 # 🔧 Next Plan

 ```text
 Switch network (hotspot)
 Restart minikube
 Enable ingress again
 Test routing
 ```

 ---

 # 🧠 Final Mental Model (REMEMBER THIS)

 ```text
 Service → connects pods
 Ingress → decides WHERE to send request
 ```

 ---

 # 🎯 One-Line Summary

 > Ingress is used to expose multiple services through a single entry point by routing requests based on path or domain.

 ---

 # 🚀 Next Steps

 * Fix ingress controller
 * Test routing (`/` and `/api`)
 * Learn Host-based ingress
 * Move to ConfigMaps & Secrets

 ---

