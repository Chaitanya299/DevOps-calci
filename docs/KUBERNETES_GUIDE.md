# Kubernetes Local Development Guide

Complete guide for running the calculator app on a local Kubernetes cluster using kind.

---

## 🚀 Quick Start

### Option 1: Use the Deployment Script (Easiest)

```bash
cd /Users/parasana/Downloads/CascadeProjects/windsurf-project

# Deploy everything with one command
./deploy-to-k8s.sh
```

This script will:
- ✅ Create/update kind cluster
- ✅ Build Docker image
- ✅ Load image into cluster
- ✅ Deploy application
- ✅ Show access URL

---

## Manual Setup (Step by Step)

### 1. Start/Create Kind Cluster

```bash
# Check if cluster exists
kind get clusters

# Create cluster (if needed)
kind create cluster --name kind

# Verify cluster is running
kubectl cluster-info
```

### 2. Build and Load Docker Image

```bash
# Build the image
docker build -f docker/Dockerfile -t simple-calculator:latest .

# Load into kind cluster
kind load docker-image simple-calculator:latest --name kind
```

### 3. Deploy to Kubernetes

```bash
# Apply deployment
kubectl apply -f k8s/deployment.yaml

# Apply service
kubectl apply -f k8s/service.yaml

# Wait for deployment
kubectl wait --for=condition=available --timeout=60s deployment/simple-calculator
```

### 4. Access the Application

#### Option A: Port Forwarding (Development)
```bash
# Forward port 8080 to the service
kubectl port-forward service/simple-calculator-service 8080:80

# Access at: http://localhost:8080
```

#### Option B: LoadBalancer IP (if available)
```bash
# Get service details
kubectl get services simple-calculator-service

# Use the external IP if available
SERVICE_IP=$(kubectl get service simple-calculator-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://$SERVICE_IP"
```

---

## 🔍 Monitoring and Debugging

### View Pods
```bash
kubectl get pods -l app=simple-calculator
```

### View Services
```bash
kubectl get services
```

### View Logs
```bash
# All calculator pods
kubectl logs -l app=simple-calculator

# Specific pod
kubectl logs <pod-name>
```

### Describe Resources
```bash
kubectl describe deployment simple-calculator
kubectl describe service simple-calculator-service
kubectl describe pods
```

### Check Pod Health
```bash
kubectl get pods -l app=simple-calculator -o wide
```

---

## 🧪 Testing End-to-End

### 1. Scale the Deployment
```bash
# Scale to 3 replicas
kubectl scale deployment simple-calculator --replicas=3

# Scale back to 2
kubectl scale deployment simple-calculator --replicas=2
```

### 2. Update the Application
```bash
# Build new image
docker build -t simple-calculator:v2 .

# Load into cluster
kind load docker-image simple-calculator:v2 --name kind

# Update deployment image
kubectl set image deployment/simple-calculator calculator=simple-calculator:v2

# Watch rolling update
kubectl rollout status deployment/simple-calculator
```

### 3. Test Load Balancing
```bash
# Get all pod IPs
kubectl get pods -l app=simple-calculator -o jsonpath='{.items[*].status.podIP}'

# Make requests to different pods to test load balancing
curl http://<pod-ip>:3000
```

---

## 🛠️ Development Workflow

### 1. Make Code Changes
Edit `index.html`, `server.js`, etc.

### 2. Build New Image
```bash
docker build -t simple-calculator:dev .
```

### 3. Load into Cluster
```bash
kind load docker-image simple-calculator:dev --name kind
```

### 4. Update Deployment
```bash
kubectl set image deployment/simple-calculator calculator=simple-calculator:dev
```

### 5. Watch Logs During Development
```bash
kubectl logs -l app=simple-calculator -f
```

---

## 📊 Kubernetes Dashboard (Optional)

### Install Dashboard
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Create service account for dashboard access
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Create cluster role binding
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

### Access Dashboard
```bash
# Start proxy
kubectl proxy

# Access at: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

---

## 🛑 Cleanup Commands

### Remove Application
```bash
kubectl delete -f k8s/
```

### Stop Kind Cluster
```bash
kind delete cluster --name kind
```

### Remove Docker Images
```bash
docker rmi simple-calculator:latest simple-calculator:v2 simple-calculator:dev
```

### Clean Everything
```bash
# Delete cluster and all resources
kind delete cluster --name kind

# Remove all calculator images
docker images | grep simple-calculator | awk '{print $3}' | xargs docker rmi 2>/dev/null || true
```

---

## 🚨 Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image not found
```bash
# Check if image is loaded
docker exec -it kind-control-plane crictl images

# Reload image
kind load docker-image simple-calculator:latest --name kind
```

### Port forwarding not working
```bash
# Kill existing port-forward
pkill -f "port-forward"

# Start fresh
kubectl port-forward service/simple-calculator-service 8080:80
```

### Service has no external IP
```bash
# This is normal in kind - use port-forwarding instead
kubectl port-forward service/simple-calculator-service 8080:80
```

---

## 📁 Files Created

- ✅ **`k8s/deployment.yaml`** - Application deployment
- ✅ **`k8s/service.yaml`** - Service configuration
- ✅ **`deploy-to-k8s.sh`** - Automated deployment script
- ✅ **This guide** - Complete documentation

---

## 🎯 What You Get

- ✅ **Local Kubernetes cluster** (kind)
- ✅ **Load balanced calculator** (2 replicas)
- ✅ **Health checks** (liveness & readiness probes)
- ✅ **Resource limits** (memory & CPU)
- ✅ **Easy scaling** and updates
- ✅ **Development workflow** ready

---

## 🚀 Ready for Production Testing!

Your calculator is now running on a production-like Kubernetes environment locally. Perfect for:

- **End-to-end testing** of deployments
- **Load balancing verification**
- **Scaling tests** (increase replicas)
- **Rolling update testing**
- **Monitoring and logging** setup

Use `./deploy-to-k8s.sh` for quick setup or follow the manual steps for full control! 🎉
