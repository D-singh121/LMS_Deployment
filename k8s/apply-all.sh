#!/bin/bash

# Create namespace if not exists
kubectl get namespace lms >/dev/null 2>&1 || kubectl create namespace lms

echo "Applying ConfigMaps..."
kubectl apply -f backend-config.yml -n lms
kubectl apply -f frontend-config.yml -n lms

echo "Applying Secrets..."
kubectl apply -f backend-secrets.yml -n lms

echo "Applying Deployments..."
kubectl apply -f backend-deployment.yml -n lms
kubectl apply -f frontend-deployment.yml -n lms

echo "Applying Services..."
kubectl apply -f backend-service.yml -n lms
kubectl apply -f frontend-service.yml -n lms

echo "✅ All manifests applied successfully in the 'lms' namespace."
