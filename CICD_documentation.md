# 🚀 GitLab CI/CD Pipeline for MERN Stack App with Kubernetes Deployment

This repository uses GitLab CI/CD to automate the building, testing, security scanning, Dockerization, and deployment of a **MERN stack** app into a local **Kubernetes (Kind)** cluster.

---

## 📋 Pipeline Stages

```yaml
stages:
  - Install_tools
  - test
  - security
  - build
  - docker
  - deploy
```

---

## 🔧 1. Install Tools (`Install_tools`)

**Job:** `Install_nodejs_docker_trivy_kubectl`

Installs the following:

- 🐳 Docker
- 🛡️ Trivy (for vulnerability scanning)
- ☸️ kubectl (for K8s control)
- 🧰 Node.js and npm

> ⚠️ Ensure the GitLab Runner has `sudo` privileges.

---

## 🧪 2. Testing (`test`)

**Job:** `unit_tests`

Runs:

- Backend tests (`server/`)
- Frontend tests (`client/`)

> Uses Node.js v20 image for testing.

---

## 🔐 3. Security Scans (`security`)

**Jobs:**

- `trivy_fs_scan`: Scans source code directory.
- `sonarqube-check`: Static analysis using SonarQube.

📄 **Artifacts:**

- `trivy-fs-report.html`
- `.sonar/cache`

---

## 🏗️ 4. Build (`build`)

**Job:** `build_frontend_and_backend_apps`

- Builds the frontend (React) with environment injection.
- Prepares the backend (Node.js) for deployment.

---

## 🐳 5. Docker (`docker`)

**Job:** `docker_login_build_and_tag_image`

Steps:

- Logs in to DockerHub.
- Builds frontend & backend images.
- Scans them with Trivy.
- Pushes images to DockerHub.

📦 **Artifacts:**

- `trivy-frontend-image-report.txt`
- `trivy-backend-image-report.txt`

> Artifacts are kept for 1 week.

---

## 🚢 6. Deploy (`deploy`)

**Job:** `deploy_to_kind_kubernetes_cluster`

- Uses base64-encoded `KUBECONFIG_CONTENT` to configure kubectl.
- Creates:
  - 🔐 Secrets for backend
  - ⚙️ ConfigMaps for frontend/backend
- Applies Kubernetes manifests from `k8s/` directory.

> All deployed under the `lms` namespace.

---

## 🔑 Required Environment Variables

| Variable                                      | Description                    |
| --------------------------------------------- | ------------------------------ |
| `DOCKER_USERNAME`                             | DockerHub username             |
| `DOCKER_PASSWORD`                             | DockerHub password/token       |
| `VITE_API_URL`                                | API URL for frontend injection |
| `FRONTEND_URL`                                | Public URL of the frontend     |
| `PORT`                                        | Backend port                   |
| `KUBECONFIG_CONTENT`                          | Base64-encoded kubeconfig file |
| `MONGO_URI`                                   | MongoDB connection string      |
| `SECRET_KEY`                                  | Express session/JWT secret     |
| `API_KEY`, `API_SECRET`                       | API credentials for services   |
| `CLOUD_NAME`, `CLOUDINARY_URL`                | Cloudinary config values       |
| `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY` | Stripe credentials             |

---

## 📁 Artifacts & Reports

| Job                     | Artifact File(s)                                                      |
| ----------------------- | --------------------------------------------------------------------- |
| `trivy_fs_scan`         | `trivy-fs-report.html`                                                |
| `docker_login_build...` | `trivy-frontend-image-report.txt`<br>`trivy-backend-image-report.txt` |

---

## 🧰 Tools Used

- **Docker** – Containerization
- **Trivy** – Vulnerability Scanning
- **SonarQube** – Static Code Analysis
- **Node.js** – Application Runtime
- **kubectl** – Kubernetes CLI
- **GitLab CI/CD** – CI/CD Platform
- **Kind** – Local Kubernetes Cluster

---

## ✅ Prerequisites

- GitLab Runner (self-hosted and kind-local-runner with Docker & `sudo`)
- Local Kubernetes cluster (Kind)
- Secrets and variables set in GitLab

---

## 🧪 Example Pipeline Flow

1. 🛠️ Install dependencies and tools
2. ✅ Run unit tests
3. 🔐 Perform code and image scans
4. 🏗️ Build frontend & backend
5. 🐳 Build and push Docker images
6. ☸️ Deploy to Kubernetes

---

## 📦 Directory Structure

```
├── client/                   # React frontend
├── server/                   # Node.js backend
├── k8s/                      # Kubernetes YAML manifests
├── .gitlab-ci.yml            # CI/CD pipeline definition
└── README.md                 # You are here
```

---
