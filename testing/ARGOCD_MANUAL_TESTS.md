# 🧪 Manual Testing Guide - Argo CD GitOps

## 🎯 **Argo CD Testing Scenarios**

This guide provides **step-by-step manual tests** you can run to validate your Argo CD GitOps setup.

---

## 1. 🔐 **Access Control Test**

### **Test Argo CD Dashboard Security**

```bash
# 1. Port-forward Argo CD server
kubectl port-forward svc/argocd-server -n argocd 8082:443

# 2. Open browser and navigate to:
open https://localhost:8082

# 3. Try to access without authentication
# Expected: Should redirect to login page

# 4. Login with credentials:
# Username: admin
# Password: <from kubectl get secret argocd-initial-admin-secret>

# 5. Verify you can see the dashboard
# Expected: Should see "Welcome to Argo CD" and your applications

# 6. Test logout functionality
# Expected: Should redirect back to login page
```

### **Verification Checklist:**
- ✅ Dashboard requires authentication
- ✅ Login works with correct credentials
- ✅ Logout functions properly
- ✅ Can view application list

---

## 2. 📊 **Monitoring & Observability Test**

### **Test Argo CD Monitoring Features**

```bash
# 1. View application status
kubectl get applications -n argocd

# Expected Output:
# NAME               SYNC STATUS   HEALTH STATUS
# simple-calculator  Synced        Healthy

# 2. Check detailed application info
kubectl argo app get simple-calculator

# 3. View managed resources tree
kubectl argo app get simple-calculator -o tree

# 4. Check application events
kubectl get events -n argocd --field-selector involvedObject.name=simple-calculator

# 5. View application logs (if enabled)
kubectl argo app logs simple-calculator

# 6. Check resource health
kubectl argo app get simple-calculator --health

# 7. Monitor sync status continuously
kubectl argo app get simple-calculator -w
```

### **Dashboard Monitoring:**
```bash
# 1. In Argo CD dashboard, click on your application
# 2. Check the "Tree" view
# 3. Check the "Timeline" for sync history
# 4. Check the "Details" for health status
```

### **Verification Checklist:**
- ✅ Application sync status visible
- ✅ Health status reported correctly
- ✅ Resource tree shows all components
- ✅ Timeline shows sync history
- ✅ Events provide useful information

---

## 3. 🔬 **End-to-End Application Test**

### **Test Complete Application Functionality**

```bash
# 1. Scale application for load testing
kubectl scale deployment simple-calculator --replicas=3

# 2. Wait for pods to be ready
kubectl wait --for=condition=available --timeout=60s deployment/simple-calculator

# 3. Check all pods are running
kubectl get pods -l app=simple-calculator

# 4. Start port forwarding
kubectl port-forward service/simple-calculator-service 8080:80 &
FORWARD_PID=$!

# 5. Test application accessibility
curl http://localhost:8080

# 6. Verify calculator functionality
# Open browser to http://localhost:8080
# Test calculator operations (addition, subtraction, etc.)

# 7. Test load balancing across replicas
for i in {1..10}; do
  curl -s http://localhost:8080 | grep -o "Calculator"
  sleep 1
done

# 8. Clean up
kill $FORWARD_PID
```

### **Verification Checklist:**
- ✅ All 3 replicas running
- ✅ Application accessible via service
- ✅ Calculator UI loads correctly
- ✅ Mathematical operations work
- ✅ Load balancer distributes requests

---

## 4. ⏪ **Rollback Test**

### **Test Version Rollback Capability**

```bash
# 1. Check current application version
kubectl get deployment simple-calculator -o jsonpath='{.spec.template.spec.containers[0].image}'

# 2. View application history
kubectl argo app history simple-calculator

# 3. Note the current revision number (e.g., 2)

# 4. Make a change to trigger new deployment (optional)
# Edit k8s/deployment.yaml and push to Git

# 5. Wait for new deployment to complete

# 6. Perform rollback to previous version
kubectl argo app rollback simple-calculator 1

# 7. Monitor rollback progress
kubectl argo app get simple-calculator -w

# 8. Verify rollback success
kubectl get deployment simple-calculator -o jsonpath='{.spec.template.spec.containers[0].image}'

# 9. Test application still works after rollback
kubectl port-forward service/simple-calculator-service 8080:80 &
curl http://localhost:8080
```

### **Verification Checklist:**
- ✅ Rollback history shows multiple revisions
- ✅ Rollback command executes successfully
- ✅ Application reverts to previous version
- ✅ Application remains functional after rollback

---

## 5. 🔧 **Self-Healing Test**

### **Test Automatic Drift Correction**

```bash
# 1. Check current replica count
kubectl get deployment simple-calculator -o jsonpath='{.spec.replicas}'

# 2. Manually create drift (simulate config drift)
kubectl scale deployment simple-calculator --replicas=1

# 3. Wait a moment
sleep 10

# 4. Check if Argo CD detected the drift
kubectl argo app get simple-calculator

# Expected: Should show "OutOfSync"

# 5. Wait for self-healing
sleep 30

# 6. Check if replicas restored
kubectl get deployment simple-calculator -o jsonpath='{.spec.replicas}'

# Expected: Should be back to original count

# 7. Verify sync status
kubectl argo app get simple-calculator

# Expected: Should show "Synced"
```

### **Verification Checklist:**
- ✅ Argo CD detects configuration drift
- ✅ Application shows "OutOfSync" status
- ✅ Self-healing restores correct configuration
- ✅ Application returns to "Synced" status

---

## 6. 🚀 **Update Application Version**

### **Test Rolling Update with New Version**

```bash
# 1. Build new version of your application
docker build -f docker/Dockerfile -t simple-calculator:v2.0 .

# 2. Load into cluster (if using KinD)
kind load docker-image simple-calculator:v2.0 --name kind

# 3. Update deployment.yaml
vim k8s/deployment.yaml
# Change: image: simple-calculator:latest
# To:     image: simple-calculator:v2.0

# 4. Commit and push to Git
git add k8s/deployment.yaml
git commit -m "Update to version 2.0"
git push origin main

# 5. Monitor rolling update
kubectl argo app get simple-calculator -w

# 6. Wait for rollout to complete
kubectl rollout status deployment/simple-calculator

# 7. Verify new version is deployed
kubectl get deployment simple-calculator -o jsonpath='{.spec.template.spec.containers[0].image}'

# 8. Test updated application
kubectl port-forward service/simple-calculator-service 8080:80 &
curl http://localhost:8080
```

### **Verification Checklist:**
- ✅ New Docker image built successfully
- ✅ Image loaded into cluster
- ✅ Deployment updated in Git
- ✅ Argo CD detects and deploys changes
- ✅ Rolling update completes successfully
- ✅ Application uses new version

---

## 7. 📊 **Scale Application Test**

### **Test Horizontal Scaling**

```bash
# 1. Check current replica count
kubectl get deployment simple-calculator -o jsonpath='{.spec.replicas}'

# 2. Scale via kubectl (direct)
kubectl scale deployment simple-calculator --replicas=5

# 3. Wait for scaling to complete
kubectl wait --for=condition=available --timeout=60s deployment/simple-calculator

# 4. Verify all pods are running
kubectl get pods -l app=simple-calculator

# 5. Test with increased load
kubectl port-forward service/simple-calculator-service 8080:80 &
for i in {1..20}; do
  curl -s http://localhost:8080 >/dev/null &
done
wait

# 6. Scale back down
kubectl scale deployment simple-calculator --replicas=2

# 7. Clean up port forward
kill %1
```

### **Alternative: Scale via Git**
```bash
# 1. Edit deployment.yaml
vim k8s/deployment.yaml
# Change replicas from 2 to 5

# 2. Commit and push
git add k8s/deployment.yaml
git commit -m "Scale to 5 replicas for testing"
git push origin main

# 3. Watch Argo CD auto-scale
kubectl argo app get simple-calculator -w

# 4. Verify scaling result
kubectl get pods -l app=simple-calculator
```

### **Verification Checklist:**
- ✅ Can scale via kubectl directly
- ✅ Can scale via Git changes
- ✅ All new pods start successfully
- ✅ Load balancer handles increased traffic
- ✅ Can scale back down successfully

---

## 🎯 **Testing Summary**

### **Quick Test Commands**
```bash
# Quick health check
kubectl argo app get simple-calculator

# Quick application test
kubectl port-forward service/simple-calculator-service 8080:80
curl http://localhost:8080
```

### **Expected Test Results**
- ✅ **Access Control**: Dashboard secured, login functional
- ✅ **Monitoring**: Status visible, events tracked, health reported
- ✅ **End-to-End**: Application accessible, calculator functional
- ✅ **Rollback**: Previous versions available, rollback works
- ✅ **Self-Healing**: Drift detected and corrected automatically
- ✅ **Version Update**: Rolling updates work, new versions deploy
- ✅ **Scaling**: Horizontal scaling functional via Git and kubectl

### **Troubleshooting**
If tests fail:
```bash
# Check Argo CD server
kubectl get pods -n argocd

# Check application status
kubectl argo app get simple-calculator

# Check cluster connectivity
kubectl cluster-info

# View application events
kubectl get events -n argocd
```

**🎉 Use these manual tests to validate your Argo CD GitOps implementation step by step!**
