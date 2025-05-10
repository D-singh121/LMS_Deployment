#!/bin/bash

echo "Deleting all resources in the 'lms' namespace (excluding kube-root-ca.crt)..."

# Delete backend ConfigMap
echo "Deleting backend-config ConfigMap..."
kubectl delete configmap backend-config -n lms

# Delete frontend ConfigMap
echo "Deleting frontend-config ConfigMap..."
kubectl delete configmap frontend-config -n lms

# Skip kube-root-ca.crt
echo "Skipping kube-root-ca.crt ConfigMap (system-generated)..."

# Delete Secrets
echo "Deleting backend-secrets Secret..."
kubectl delete secret backend-secrets -n lms

# Delete Deployments
echo "Deleting backend Deployment..."
kubectl delete deployment backend -n lms

echo "Deleting frontend Deployment..."
kubectl delete deployment frontend -n lms

# Delete Services
echo "Deleting backend-service Service..."
kubectl delete service backend-service -n lms

echo "Deleting frontend-service Service..."
kubectl delete service frontend-service -n lms

# Delete any remaining Pods
echo "Deleting all remaining Pods in lms namespace..."
kubectl delete pods --all -n lms

echo "✅ All resources (except kube-root-ca.crt) deleted from 'lms' namespace."
