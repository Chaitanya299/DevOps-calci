#!/bin/bash

# Deploy Calculator to Kubernetes
# This script sets up a local Kubernetes cluster and deploys the calculator app

set -e

echo "🚀 Deploying Simple Calculator to Kubernetes..."

# Check if kind cluster exists
if ! kind get clusters | grep -q "^kind$"; then
    echo "📦 Creating kind cluster..."
    kind create cluster --name kind
else
    echo "✅ Kind cluster already exists"
fi

# Build Docker image
echo "🔨 Building Docker image..."
docker build -f docker/Dockerfile -t simple-calculator:latest .

# Load image into kind cluster
echo "📤 Loading image into kind cluster..."
kind load docker-image simple-calculator:latest --name kind

# Apply Kubernetes manifests
echo "☸️  Applying Kubernetes manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/simple-calculator

# Get service information
echo "📋 Getting service information..."
kubectl get pods -l app=simple-calculator
kubectl get services simple-calculator-service

# Get the service URL (for LoadBalancer type)
SERVICE_IP=$(kubectl get service simple-calculator-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
SERVICE_PORT=$(kubectl get service simple-calculator-service -o jsonpath='{.spec.ports[0].port}')

if [ -n "$SERVICE_IP" ] && [ "$SERVICE_IP" != "null" ]; then
    echo "🎉 Calculator is ready!"
    echo "🌐 Access your app at: http://$SERVICE_IP:$SERVICE_PORT"
else
    echo "🎉 Calculator is ready!"
    echo "🔗 Use port-forwarding to access: kubectl port-forward service/simple-calculator-service 8080:80"
    echo "🌐 Then visit: http://localhost:8080"
fi

echo ""
echo "📊 Useful commands:"
echo "  kubectl get pods"
echo "  kubectl get services"
echo "  kubectl logs -l app=simple-calculator"
echo "  kubectl describe deployment simple-calculator"
echo ""
echo "🛑 To clean up:"
echo "  kubectl delete -f k8s/"
echo "  kind delete cluster --name kind"
