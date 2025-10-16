# Argo CD GitOps Setup Guide

Complete guide for using Argo CD to manage your calculator application with GitOps.

---

## 🚀 Quick Start

### 1. Access Argo CD Dashboard

```bash
# Port-forward Argo CD server (Terminal 1)
kubectl port-forward svc/argocd-server -n argocd 8082:443

# Access dashboard in browser
open https://localhost:8082
```

**Login Credentials:**
- **Username:** `admin`
- **Password:** `jWYGGf2ls7OPLJFo` (from installation)

### 2. View Your Application

In the Argo CD dashboard, you'll see:
- **Application:** `simple-calculator`
- **Sync Status:** `Synced` ✅
- **Health Status:** `Progressing` → `Healthy` ✅
- **Source:** Your GitHub repository
- **Destination:** Your KinD cluster

---

## 📋 Argo CD Application Details

### Application Configuration (`argocd/application.yaml`)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: simple-calculator
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Chaitanya299/DevOps-calci.git
    targetRevision: HEAD
    path: k8s  # Watches the k8s/ folder
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true      # Remove resources not in Git
      selfHeal: true   # Auto-sync if cluster drifts
```

### What Argo CD Does

✅ **Watches** your `k8s/` folder in GitHub
✅ **Syncs** changes automatically to your cluster
✅ **Detects drift** between Git and cluster state
✅ **Auto-heals** if cluster state differs from Git
✅ **Prunes** resources removed from Git

---

## 🧪 Testing GitOps Workflow

### 1. Make a Change in Git

Edit any file in the `k8s/` folder:
```bash
# Example: Update replica count
vim k8s/deployment.yaml
# Change replicas from 2 to 3
```

### 2. Commit and Push

```bash
git add k8s/deployment.yaml
git commit -m "Scale calculator to 3 replicas"
git push origin main
```

### 3. Watch Argo CD Sync

In the Argo CD dashboard:
- **Refresh** the application
- **Watch** the sync status change to `OutOfSync`
- **Wait** for automatic sync (should take 10-30 seconds)
- **Verify** new pods are created

### 4. Verify in Cluster

```bash
# Check if new pods are running
kubectl get pods -l app=simple-calculator

# Should show 3 pods now
```

---

## 🔍 Argo CD Commands

### Application Management
```bash
# View application status
kubectl get applications -n argocd

# View detailed application info
kubectl describe application simple-calculator -n argocd

# View sync status
kubectl get application simple-calculator -n argocd -o yaml

# Force sync (if needed)
kubectl argo app sync simple-calculator

# View application logs
kubectl argo app logs simple-calculator
```

### Argo CD Server Management
```bash
# Check Argo CD server status
kubectl get pods -n argocd

# View Argo CD server logs
kubectl logs -l app.kubernetes.io/name=argocd-server -n argocd

# Restart Argo CD server
kubectl rollout restart deployment argocd-server -n argocd
```

---

## 📊 Monitoring GitOps

### Dashboard Views

**Application View:**
- **Tree View:** Shows all resources managed by Argo CD
- **Timeline:** Shows sync history and changes
- **Diff View:** Shows differences between Git and cluster

**Project View:**
- **Repositories:** Shows connected Git repositories
- **Applications:** Lists all managed applications

### CLI Monitoring

```bash
# Watch application status
watch kubectl get applications -n argocd

# Check sync status continuously
kubectl argo app get simple-calculator -o yaml | grep -A 5 -B 5 syncStatus

# View application events
kubectl get events -n argocd --field-selector involvedObject.name=simple-calculator
```

---

## 🚨 Troubleshooting

### Application Not Syncing

```bash
# Check application status
kubectl argo app get simple-calculator

# View application logs for errors
kubectl argo app logs simple-calculator

# Check if repository is accessible
kubectl argo repo list

# Force refresh of repository
kubectl argo app refresh simple-calculator
```

### Cluster Drift Detected

```bash
# Check sync status
kubectl argo app get simple-calculator

# If status is "OutOfSync", Argo CD will auto-sync
# Or manually sync
kubectl argo app sync simple-calculator
```

### Argo CD Server Issues

```bash
# Check Argo CD server pods
kubectl get pods -n argocd

# Check server logs
kubectl logs -l app.kubernetes.io/name=argocd-server -n argocd

# Restart server if needed
kubectl rollout restart deployment argocd-server -n argocd
```

---

## 🔧 Configuration Options

### Sync Policies

**Current:** `automated` with `prune` and `selfHeal`

**Options:**
```yaml
syncPolicy:
  automated:
    prune: true      # Remove resources not in Git
    selfHeal: true   # Auto-sync cluster drift
  syncOptions:
    - CreateNamespace=true  # Create namespaces if needed
    - PrunePropagationPolicy=foreground  # Safer pruning
```

### Revision Control

```yaml
source:
  targetRevision: HEAD        # Always use latest commit
  # OR
  targetRevision: main        # Use specific branch
  # OR
  targetRevision: v1.2.3     # Use specific tag
```

---

## 🏗️ Project Structure for GitOps

```
/Users/parasana/Downloads/CascadeProjects/windsurf-project/
├── k8s/                          # 📁 Kubernetes manifests (watched by Argo CD)
│   ├── deployment.yaml           # Application deployment
│   └── service.yaml              # Service configuration
├── argocd/                       # 🔧 Argo CD configuration
│   └── application.yaml           # Argo CD application definition
├── docs/                         # 📚 Documentation
└── [other project files...]
```

---

## 🎯 GitOps Workflow

1. **Edit** files in `k8s/` folder locally
2. **Commit & Push** changes to GitHub
3. **Argo CD detects** changes in repository
4. **Argo CD syncs** changes to cluster automatically
5. **Cluster state** matches Git state
6. **Repeat** for continuous deployment

---

## 📈 Advanced Features

### Multiple Environments

```bash
# Create staging application
kubectl argo app create simple-calculator-staging \
  --repo https://github.com/Chaitanya299/DevOps-calci.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace staging \
  --sync-policy automated
```

### Application Sets

```yaml
# For managing multiple applications
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: calculator-environments
spec:
  generators:
  - list:
      elements:
      - cluster: staging
        url: https://kubernetes.default.svc
      - cluster: production
        url: https://prod-cluster.example.com
  template:
    metadata:
      name: 'simple-calculator-{{cluster}}'
    spec:
      source:
        repoURL: https://github.com/Chaitanya299/DevOps-calci.git
        path: k8s
      destination:
        server: '{{url}}'
        namespace: default
```

---

## 🛑 Cleanup

```bash
# Delete Argo CD application
kubectl delete -f argocd/application.yaml

# Remove Argo CD completely
kubectl delete namespace argocd

# Clean up port-forwarding
pkill -f "port-forward"
```

---

## 🎉 What You Have Now

✅ **Argo CD installed** in your KinD cluster
✅ **GitOps configured** to watch your repository
✅ **Automatic sync** when you push changes
✅ **Web dashboard** for monitoring and management
✅ **Production-ready** GitOps workflow

**🎯 Your calculator is now managed by GitOps!** Every change you push to GitHub will automatically sync to your cluster.
