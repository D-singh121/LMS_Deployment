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
