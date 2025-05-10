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

RUN VITE_API_URL=$VITE_API_URL npm run build

# Stage 2: Set up Nginx to serve the built app
FROM nginx:alpine


COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf


EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]




