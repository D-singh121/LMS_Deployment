# Stage 1: Build the backend
FROM node:alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Stage 2: Run the backend in production
FROM node:alpine

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# Expose the port your Node.js application listens on
EXPOSE 8080

# Command to run your application
CMD ["node", "index.js"]