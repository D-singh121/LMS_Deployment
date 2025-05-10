# Kubernetes Deployment for LMS Project with KIND
For installing the kind and creating cluster refer the **kind_readme.md** file within the same directory. 
Once your KIND cluster is up and running, you should be able to verify the nodes like this:

```bash
d_singh@d-singh:~/deployment_Projects/LMS_Deployment/k8s$ kubectl get nodes -o wide
NAME                         STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION     CONTAINER-RUNTIME
ingress-demo-control-plane   Ready    control-plane   16h   v1.31.2   172.18.0.2    <none>        Debian GNU/Linux 12 (bookworm)   6.8.0-59-generic   containerd://1.7.18
ingress-demo-worker          Ready    <none>          16h   v1.31.2   172.18.0.3    <none>        Debian GNU/Linux 12 (bookworm)   6.8.0-59-generic   containerd://1.7.18
```

---

After the cluster is live and manifests are written, we must:

- **Update the frontend and backend URLs** in the respective `ConfigMap` files to ensure correct CORS configuration and API call routing.
- **Pass the API URL as an environment variable at Docker build time** for the frontend. This is necessary because React applications are compiled into static files and served by NGINX. The environment variable needs to be embedded during the build phase.

### Dockerfile for Frontend (React + Nginx)

```Dockerfile
# Stage 1: Build the Vite React application for production
FROM node:alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Inject VITE_API_URL at build time
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

ARG PORT
ENV PORT=$PORT

RUN npm run build

# Stage 2: Set up Nginx to serve the built app
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Example Build Command and push to docker hub so it reflec on k8s menifests also with latest image

```bash
docker build -t lms-frontend:latest --build-arg VITE_API_URL=http://172.18.0.3:30080 .
docker push lms-frontend:latest
```

---

## Backend ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
data:
  # FRONTEND_URL: "http://frontend-service:3000"  # for ingress or load balancer
  # FRONTEND_URL=http://<node_IP>:<nodePort_port>    # for local nodeport port
  FRONTEND_URL: "http://172.18.0.3:30001"
  PORT: "8080"
```

## Backend Secret Note: Never Push these secrets on source code management like github, gitlab Insted use with secrets variable on cicd line. These are dummy only

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backend-secrets
  namespace: lms
type: Opaque
data:
  API_KEY: MzExMTgyNjQ3Mjkglmbkfd
  API_SECRET: NHV5SDBpS1VHaEpndzdghfkghfdg6OVVYRmpQck1QX2ZN
  CLOUD_NAME: ZHJnd3A0NWFrdgfg
  CLOUDINARY_URL: Y2xvdWRpbmFyeTovLzMxMTE4MjY0klvvgd2dsNzIxODQ3OTo0dXlIMGlLVUdoSmd3N3o5VVhGalByTVBfZk1AZHJnd3A0NWFr
  MONGO_URI: bW9uZ29kYitzcnY6Ly9kZXZlc2g6RGVlMTU0Njjyigfdgfd67Tk1JTQwQGxtcy5ob2E1dmdmLm1vbmdvZGIubmV0L2xtcz9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkK
  STRIPE_SECRET_KEY: c2tfdGVzdF81MVJFNGMwUHhmWXpoeWI0a3QyU1dTQ0I0ekRM6546dsRjhuWnZZbXlpbzFxZHJOd1VCWGx5NXhwR3hYdWdsgfgiMUJpU3F1S3A2enFrYTJrVm01NjBiQ1V3U050bXRIWjAwVnF1cllLd0U=
  STRIPE_PUBLISHABLE_KEY: cGtfdGVzdF81MVJFNGMwUHhmWXpoeWI0azROck0xcGpoQkN6ekNhY245Q1hjd113665serbdVSGFvcml4QUl2STNCclBHQmg2MjZhaTZxbVdEamxKNHpRQW80YUwzcThUeENvemoy876uudTAwdnhyd0tjbmI=
  SECRET_KEY: NHV5SDBpS1VHaEpndzd6OVVYRmpQck1dfjkjgs1QX2ZN
```

## Backend Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: lms-backend
          image: devesh121/lms-backend:latest
          ports:
            - containerPort: 8080
          envFrom:
            - configMapRef:
                name: backend-config
            - secretRef:
                name: backend-secrets
          resources:
            requests:
              cpu: "200m"
              memory: "256Mi"
            limits:
              cpu: "500m"
              memory: "500Mi"
```

## Backend Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30080
  type: NodePort
```

## Frontend ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-config
data:
  # VITE_API_URL: "http://backend-service:8080"  # for ingress or load balancer
  VITE_API_URL: "http://172.18.0.3:30080"
```

## Frontend Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: lms-frontend
          image: devesh121/lms-frontend:latest
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: frontend-config
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "250m"
              memory: "256Mi"
```

## Frontend Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 80
      nodePort: 30001
  type: NodePort
```

## Now our cluster, docker images and menefests are ready let Create Namespace for Isolation on cluster

```bash
kubectl create namespace lms
```

we can verify it was created:

```bash
kubectl get namespaces
```

## Apply Manifests in Order

To avoid dependency issues and ensure a smooth deployment, apply your manifests in the following order:

1. **ConfigMaps** (both backend and frontend)
2. **Secrets**
3. **Deployments**
4. **Services**

Here’s how to apply them:

```bash
kubectl apply -f backend-config.yml -n lms
kubectl apply -f frontend-config.yml -n lms

kubectl apply -f backend-secrets.yaml -n lms

kubectl apply -f backend-deployment.yml -n lms
kubectl apply -f frontend-deployment.yml -n lms

kubectl apply -f backend-service.yaml -n lms
kubectl apply -f frontend-service.yaml -n lms
```

## Confirm All resources crated on lms namespace

```bash
d_singh@d-singh:~/deployment_Projects/LMS_Deployment/k8s$ kubectl get all -n lms
NAME                            READY   STATUS    RESTARTS   AGE
pod/backend-5c5f45d684-7qzrx    1/1     Running   0          74s
pod/backend-5c5f45d684-rvksz    1/1     Running   0          74s
pod/frontend-76fffb6b59-5bx5x   1/1     Running   0          33s
pod/frontend-76fffb6b59-ns96f   1/1     Running   0          33s

NAME                       TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/backend-service    NodePort   10.96.198.88   <none>        8080:30080/TCP   67s
service/frontend-service   NodePort   10.96.42.60    <none>        3000:30001/TCP   25s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend    2/2     2            2           74s
deployment.apps/frontend   2/2     2            2           33s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-5c5f45d684    2         2         2       74s
replicaset.apps/frontend-76fffb6b59   2         2         2       33s
d_singh@d-singh:~/deployment_Projects/LMS_Deployment/k8s$

```

## Final URLs After Build and Deployment

After building and deploying both frontend and backend, the URLs are:

Backend URL (NodePort):http://<worker-node-IP>:30080
Example (from your cluster):http://172.18.0.3:30080

Frontend URL (NodePort):http://<worker-node-IP>:30001
Example:http://172.18.0.3:30001

These URLs should match what's configured in the following places:

VITE_API_URL in the frontend ConfigMap and passed during frontend build.

FRONTEND_URL in the backend ConfigMap for proper CORS handling.

## Now we can check the deployment live or not:

![frontend-page](landingpage.png)

---

# 🧹 Never forgot to cleanup these resources we created after project testing done:

Once we're done with testing or deploying our application and want to remove all resources related to the LMS project, follow this cleanup procedure:

## 1. Delete All Resources in the Namespace

```bash
kubectl delete all --all -n lms

```

## 2. Delete the Namespace

```bash
kubectl delete namespace lms
```
## 3. Optionally Remove Docker Images (if built locally)
   If you built any images locally, you can free up space:

```bash
docker image rm lms-frontend:latest
```

## 4. Delete KIND Cluster (if used)
To remove the KIND cluster:

```bash
kind delete cluster --name <your-cluster-name>
```
--- 
Replace <your-cluster-name> with the name you used when creating the KIND cluster (default is kind).