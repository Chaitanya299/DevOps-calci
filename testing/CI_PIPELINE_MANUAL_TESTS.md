# 🧪 Manual Testing Guide - CI/CD Pipeline

## 🎯 **CI/CD Pipeline Testing Scenarios**

This guide provides **step-by-step manual tests** you can run to validate your educational CI/CD pipeline.

---

## 1. 🎨 **Color Palette Test**

### **Test UI Customization Changes**

```bash
# 1. Edit the HTML file to change colors
vim index.html

# Example changes in the <style> section:
# Change background color
# background-color: #f0f0f0; → background-color: #e8f4f8;

# Change button colors
# background-color: #4CAF50; → background-color: #2196F3;

# Change text colors
# color: #333; → color: #2c3e50;

# 2. Save and commit changes
git add index.html
git commit -m "Test: Change color palette to blue theme"
git push origin main

# 3. Wait for CI/CD pipeline to run (check GitHub Actions)

# 4. Verify deployment completed
kubectl argo app get simple-calculator

# 5. Test updated UI
kubectl port-forward service/simple-calculator-service 8080:80 &
open http://localhost:8080

# 6. Verify color changes are visible
# Expected: Blue theme instead of green
```

### **Verification Checklist:**
- ✅ CI pipeline runs successfully
- ✅ Docker image builds with changes
- ✅ Kubernetes deployment updates
- ✅ New colors visible in browser
- ✅ Calculator functionality still works

---

## 2. 🔤 **Text Content Test**

### **Test Content Modification**

```bash
# 1. Edit the HTML title or headings
vim index.html

# Example changes:
# Change title: "Calculator" → "Simple Calculator App"
# Change heading: "Calculator" → "My Awesome Calculator"

# 2. Save and commit
git add index.html
git commit -m "Test: Update page title and heading"
git push origin main

# 3. Wait for pipeline completion

# 4. Test updated content
kubectl port-forward service/simple-calculator-service 8080:80 &
curl http://localhost:8080 | grep -A 5 -B 5 "Simple Calculator"

# 5. Verify in browser
open http://localhost:8080
```

### **Verification Checklist:**
- ✅ CI pipeline validates HTML changes
- ✅ Docker build includes new content
- ✅ Application serves updated text
- ✅ No broken HTML or JavaScript

---

## 3. 🧮 **Calculator Functionality Test**

### **Test Mathematical Operations**

```bash
# 1. Start the application
kubectl port-forward service/simple-calculator-service 8080:80 &
FORWARD_PID=$!

# 2. Test basic calculations via HTTP requests
echo "Testing calculator operations..."

# Test responses (you'll need to check actual calculator behavior)
# Since this is a UI calculator, test via browser instead:

# 3. Manual testing in browser:
open http://localhost:8080

# 4. Test operations:
# - Click number buttons (1, 2, 3, etc.)
# - Click operation buttons (+, -, *, /)
# - Click equals (=)
# - Verify calculations are correct
# - Test decimal numbers
# - Test clear button

# 5. Verify error handling
# - Division by zero
# - Very large numbers
# - Invalid operations

# 6. Clean up
kill $FORWARD_PID
```

### **Verification Checklist:**
- ✅ Application loads without errors
- ✅ Number input works correctly
- ✅ Mathematical operations function
- ✅ Display updates properly
- ✅ Clear button resets calculator

---

## 4. 🚀 **Performance Test**

### **Test Application Responsiveness**

```bash
# 1. Start application
kubectl port-forward service/simple-calculator-service 8080:80 &

# 2. Test response times
echo "Testing response times..."
for i in {1..5}; do
  START=$(date +%s%N)
  curl -s -o /dev/null -w "%{time_total}\n" http://localhost:8080
  END=$(date +%s%N)
  DURATION=$((END - START))
  echo "Request $i: $((DURATION/1000000))ms"
done

# 3. Test concurrent requests
echo "Testing concurrent load..."
for i in {1..10}; do
  curl -s http://localhost:8080 >/dev/null &
done
wait

# 4. Monitor resource usage
kubectl top pods -l app=simple-calculator

# 5. Check application logs
kubectl logs -l app=simple-calculator -f

# 6. Clean up
kill %1
```

### **Verification Checklist:**
- ✅ Response times under 100ms
- ✅ Handles concurrent requests
- ✅ Resource usage reasonable
- ✅ No errors in application logs

---

## 5. 🔒 **Security Headers Test**

### **Test Security Implementation**

```bash
# 1. Check HTTP security headers
kubectl port-forward service/simple-calculator-service 8080:80 &
curl -s -I http://localhost:8080

# 2. Look for security headers:
# - X-Content-Type-Options: nosniff
# - X-Frame-Options: DENY
# - X-XSS-Protection: 1; mode=block

# 3. Test HTTPS (if configured)
# curl -s -I https://your-app.com

# 4. Test for common vulnerabilities
# - Check if directory listing is disabled
# curl -s http://localhost:8080/nonexistent-file

# 5. Verify no sensitive files exposed
# curl -s http://localhost:8080/.env
# curl -s http://localhost:8080/package.json

# 6. Clean up
kill %1
```

### **Verification Checklist:**
- ✅ Security headers present
- ✅ No directory listing
- ✅ Sensitive files not accessible
- ✅ HTTPS working (if configured)

---

## 6. 🌐 **Cross-Browser Compatibility Test**

### **Test Application Across Browsers**

```bash
# 1. Deploy application
kubectl port-forward service/simple-calculator-service 8080:80 &
echo "Application available at: http://localhost:8080"

# 2. Manual testing instructions:
echo ""
echo "📋 Test the following browsers:"
echo "   1. Chrome:  Open http://localhost:8080"
echo "   2. Firefox: Open http://localhost:8080"
echo "   3. Safari:  Open http://localhost:8080"
echo "   4. Edge:    Open http://localhost:8080"
echo ""
echo "✅ Checklist for each browser:"
echo "   - Calculator UI renders correctly"
echo "   - Button clicks work"
echo "   - Display updates properly"
echo "   - Mathematical operations function"
echo "   - No JavaScript errors in console"

# 3. Test responsive design
echo ""
echo "📱 Responsive Design Test:"
echo "   - Resize browser window"
echo "   - Test on mobile device (if possible)"
echo "   - Verify layout adapts correctly"

# 4. Clean up
kill $FORWARD_PID
```

### **Verification Checklist:**
- ✅ Works in Chrome
- ✅ Works in Firefox
- ✅ Works in Safari
- ✅ Works in Edge
- ✅ Responsive design functional

---

## 7. 🔄 **GitOps Integration Test**

### **Test Complete CI/CD + Argo CD Workflow**

```bash
# 1. Make a change to the application
vim index.html
# Add a comment or small change

# 2. Commit and push
git add index.html
git commit -m "Test: GitOps integration test"
git push origin main

# 3. Monitor CI/CD pipeline
# Check GitHub Actions tab for pipeline status

# 4. Monitor Argo CD sync
kubectl argo app get simple-calculator -w

# 5. Verify deployment
kubectl get pods -l app=simple-calculator

# 6. Test updated application
kubectl port-forward service/simple-calculator-service 8080:80 &
curl http://localhost:8080

# 7. Verify in Argo CD dashboard
kubectl port-forward svc/argocd-server -n argocd 8082:443
open https://localhost:8082
# Check application sync status and timeline

# 8. Clean up
kill %1 %2
```

### **Verification Checklist:**
- ✅ GitHub Actions pipeline runs
- ✅ Docker image builds successfully
- ✅ Argo CD detects changes
- ✅ Application deploys automatically
- ✅ Changes visible in browser
- ✅ Argo CD dashboard shows sync

---

## 🎯 **Testing Summary**

### **Quick Test Commands**
```bash
# Quick application test
kubectl port-forward service/simple-calculator-service 8080:80
curl http://localhost:8080
open http://localhost:8080

# Quick Argo CD check
kubectl argo app get simple-calculator

# Quick CI/CD check (GitHub Actions)
# Visit your repository on GitHub and check Actions tab
```

### **Expected Test Results**
- ✅ **Color Palette**: UI customization works, colors update
- ✅ **Text Content**: Content changes deploy successfully
- ✅ **Calculator Function**: Mathematical operations work correctly
- ✅ **Performance**: Fast response times, handles load
- ✅ **Security**: Headers present, no vulnerabilities
- ✅ **Cross-Browser**: Works across different browsers
- ✅ **GitOps Integration**: End-to-end CI/CD + Argo CD workflow

### **Troubleshooting**
If tests fail:
```bash
# Check application logs
kubectl logs -l app=simple-calculator

# Check Argo CD status
kubectl argo app get simple-calculator

# Check CI/CD pipeline (GitHub)
# Visit Actions tab in your repository

# Check Docker build
docker build -f docker/Dockerfile -t test .
```

**🎉 Use these manual tests to validate your complete CI/CD pipeline from code changes to deployment!**
