# 🐳 KIND (Kubernetes IN Docker) - Complete Guide

`kind` is a tool for running local Kubernetes clusters using Docker container “nodes”. It’s ideal for development, testing, and CI workflows.

---

## 📘 Official References

- 🔗 [kind.sigs.k8s.io](https://kind.sigs.k8s.io/)
- 🔗 [GitHub - kind](https://github.com/kubernetes-sigs/kind)
- 🔗 [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)

---

# KIND Cluster Setup Guide

## 1. 🧰 Installing KIND and kubectl

Use this script to install KIND and `kubectl`:

```bash
#!/bin/bash

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

VERSION="v1.30.0"
URL="https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
INSTALL_DIR="/usr/local/bin"

curl -LO "$URL"
chmod +x kubectl
sudo mv kubectl $INSTALL_DIR/
kubectl version --client

rm -f kubectl
rm -rf kind

echo "kind & kubectl installation complete."
```

---

## 2. ⚙️ Setting Up the KIND Cluster

Create a cluster configuration file `kind-cluster-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4

nodes:
  - role: control-plane
    image: kindest/node:v1.31.2
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 80
        hostPort: 3000   // default port is 80 but on my local another service was using it 
        protocol: TCP
      - containerPort: 443
        hostPort: 8443   // default port is 443 but on my local another service was using it 
        protocol: TCP

  - role: worker
    image: kindest/node:v1.31.2
```

Create the cluster:

```bash
kind create cluster --config kind-cluster-config.yaml --name my-kind-cluster
```

Verify the cluster:

```bash
kubectl get nodes
kubectl cluster-info
```

---

## 3. 🧭 Accessing the Cluster

Interact with your cluster using `kubectl`:

```bash
kubectl cluster-info
```

---

## 4. 📊 Setting Up the Kubernetes Dashboard

### 🚀 Deploy the Dashboard

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### 👤 Create an Admin User

Save this as `dashboard-admin-user.yml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
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
```

Apply the config:

```bash
kubectl apply -f dashboard-admin-user.yml
```

### 🔑 Get the Access Token

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

Copy the token for logging into the dashboard.

### 🌐 Access the Dashboard

Start the proxy:

```bash
kubectl proxy
kubectl proxy --port:8002   # if Default port 8001 is busy we can change according to us.

```


Open the Dashboard in your browser:

```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

Use the token to log in.

---

## 5. 🗑️ Deleting the Cluster

```bash
kind delete cluster --name my-kind-cluster
```

---

## 6. 📝 Notes

- **Multiple Clusters**: Use the `--name` flag to manage multiple clusters.
- **Custom Node Images**: Use different Kubernetes versions by setting node `image` fields.
- **Ephemeral Clusters**: KIND clusters are lost if Docker is restarted or purged.
- **Load Balancer Support**: Use tools like MetalLB for `LoadBalancer` services.
- **Ingress**: Install ingress controllers like NGINX for HTTP routing.

---

## 📚 Additional Tools

- `kubectl` — Kubernetes CLI
- `Helm` — Package manager for Kubernetes
- `k9s` — Terminal UI for managing Kubernetes