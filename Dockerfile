# Stage 1: Build Angular Application
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli@17.3.1

# Install project dependencies
RUN npm install

# Copy the entire project to the container
COPY . .

# Build the Angular application for production
RUN ng build --configuration production

# Stage 2: Serve with Nginx
FROM nginx:latest

# Set environment variables for Nginx
ENV NGINX_PORT=80

# Copy the built Angular app from the previous stage to Nginx's web root directory
COPY --from=build /app/dist/crudtuto-Front /usr/share/nginx/html

# Copy custom Nginx configuration
COPY src/nginx/etc/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Command to start Nginx and serve the Angular app
CMD ["nginx", "-g", "daemon off;"]
