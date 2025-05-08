
# 📡 Kubernetes Port Forwarding Guide Majorly for KIND Clusters  (`kubectl port-forward`)

This guide explains how to use `kubectl port-forward` to access Kubernetes services or pods from your local machine.

---

## 🔧 1. Basic Syntax

```bash
kubectl port-forward [resource-type]/[name] [LOCAL_PORT]:[REMOTE_PORT]
```

- `resource-type`: `pod`, `service`, `deployment` (usually `pod` or `service`)
- `LOCAL_PORT`: your local machine's port
- `REMOTE_PORT`: port inside the cluster (container or service)

---

## 🚀 2. Port Forward a Service

```bash
kubectl port-forward service/frontend-service 3000:3000
```

- Forwards local port `3000` to service port `3000`
- Assumes the service is exposing port 3000

---

## 🧱 3. Port Forward a Pod

First, get pod name:

```bash
kubectl get pods
```

Then forward:

```bash
kubectl port-forward pod/frontend-abc123 3000:80
```

- Forwards local port `3000` to **container port 80** in the pod

---

## 🕹️ 4. Run in Background (Detach Mode)

```bash
nohup kubectl port-forward service/frontend-service 3000:3000 > port-forward.log 2>&1 &
```

- `nohup`: Keeps running after terminal closes
- `&`: Runs in background
- Logs output to `port-forward.log`

---

## ✅ 5. Check If Port Is Forwarded

Check if port is being used:

```bash
lsof -i :3000
```

Or list running processes:

```bash
ps aux | grep port-forward
```

---

## ❌ 6. Stop Port Forwarding

Kill process using the port:

```bash
kill $(lsof -ti :3000)
```

Or find and kill by process name:

```bash
pkill -f "kubectl port-forward"
```

---

## 🧪 7. Test the Connection

Once port-forwarding is active, test using:

```bash
curl http://localhost:3000
```

Or open in browser:

```
http://localhost:3000
```

---

## 💡 Tips

- `kubectl port-forward` only works while the terminal is open unless run in the background
- Use `screen` or `tmux` for persistent sessions
- NodePort (`30095`) is **not used** in port-forwarding

---

## 📖 Example: Full Flow

```bash
# Get services
kubectl get svc

# Start port forwarding service
kubectl port-forward service/frontend-service 3000:3000

# Or forward a pod directly
kubectl port-forward pod/frontend-76fffb6b59-686wk 3000:80

# Run in background
nohup kubectl port-forward service/frontend-service 3000:3000 > pf.log 2>&1 &
```

---
