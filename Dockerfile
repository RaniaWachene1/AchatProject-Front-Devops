# Use Node.js image for building the Angular app
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli@17.3.1

# Install project dependencies (with legacy-peer-deps to avoid conflicts)
RUN npm install --legacy-peer-deps

# Copy the entire project to the container
COPY . .

# Build the Angular application for production
RUN ng build --configuration production

# Use a lightweight Nginx image to serve the Angular app
FROM nginx:latest

# Copy the built Angular app from the previous stage to Nginx's web root directory
COPY --from=build /app/dist/gh-front-end /usr/share/nginx/html

# Custom Nginx configuration (optional: ensure the path exists and is valid)
COPY src/nginx/default.conf /etc/nginx/conf.d/default.conf


# Expose port 80
EXPOSE 80

# Command to start Nginx and serve the Angular app
CMD ["nginx", "-g", "daemon off;"]
