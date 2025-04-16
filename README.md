
# 📚 E-Learning Platform – DevOps Practice

This project is a fully functional **E-Learning Web Application** showcasing various tech courses such as Docker and MERN stack development.

> ⚠️ **Note:** This project is originally written by [Surendrakumarpatel](https://github.com/Surendrakumarpatel). I’m using it solely for practicing **DevOps principles** like Dockerization, container orchestration, and deployment using `docker-compose`.

---

## 🚀 Tech Stack Used

### 🔧 Frontend:
- React.js
- TailwindCSS
- Axios
- React Router
- Redux Toolkit

### 🛠 Backend:
- Node.js
- Express.js
- MongoDB
- Mongoose
- JWT Authentication
- Cloudinary (for image upload)

### 📦 DevOps Tools:
- Git/Github
- Docker
- Docker Compose
- Nginx server 

---
## Some Configuration for Nginx with Vite
Add the 'nginx.conf' file in client folder with below content.
```bash
server {
    listen 80;
    server_name localhost;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    
    # Handle Vite's asset serving
    location /assets/ {
        root /usr/share/nginx/html;
        try_files $uri =404;
    }
    
    # Error handling
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

Modify the `vite.config.js` file 
```bash
import path from "path";
import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  server: {
    host: "0.0.0.0", // 👈 important: allow access from Docker network
    port: 5173, // 👈 your app port inside container
    strictPort: true, // optional: fail if port is taken
    watch: {
      usePolling: true, // 👈 useful for file changes in Docker
    },
  },
});

```


## 🐳 Dockerized Setup

To run the entire application using Docker and Docker Compose:

### 🔨 Build and Start

```bash
docker-compose up --build
```

### 🏁 Start in Detached Mode (Optional)

```bash
docker-compose up -d --build
```

### ⛔ Stop and Remove Containers

```bash
docker-compose down
```

---

## 🌐 Application Preview

After starting the containers, visit:

- **Frontend:** [http://localhost:3000](http://localhost:3000)
- **Backend API (if exposed):** [http://localhost:8080/api/v1](http://localhost:8080/api/v1) *(example)*

---

## 📂 Folder Structure (Basic Overview)

```
├── LMS-Project
    ├── client/              # React frontend
          ├── .env                 # Environment variables
    ├── server/              # Node.js backend
          ├── .env                 # Environment variables
├── docker-compose.yml   # Compose setup
└── README.md
```

---

## 📌 Reason for Using Public Repo

This is a **public repository** by [Surendrakumarpatel](https://github.com/Surendrakumarpatel), and I am using it:
- As a **learning resource** to sharpen my DevOps skills
- To **dockerize and deploy** a fullstack application using `docker-compose`
- For practicing **CI/CD**, container builds, and production-grade setup in a safe, open-source environment

---

## 📸 Screenshot
![image](https://github.com/user-attachments/assets/32c604b6-36d9-4d77-962f-75e744837c97)
---

## 🙌 Credits

Thanks to [Surendrakumarpatel](https://github.com/Surendrakumarpatel) for building such an amazing public project. This hands-on experience is helping me master containerization and modern DevOps workflows.

---

## 📧 Contact Me

If you'd like to collaborate or discuss more DevOps projects:

- GitHub: [[https://github.com/D-singh121](https://github.com/D-singh121)]
- Email: [choudharydevesh121@gmail.com]
