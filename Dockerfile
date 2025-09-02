# Stage 1: Build Environment
# Use a Node.js image with tools needed for installing dependencies.
FROM node:18-alpine AS builder

# Set the working directory inside the container.
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker caching.
COPY package*.json ./

# Install project dependencies.
RUN npm install

# Stage 2: Production Environment
# Use a lean Node.js image for production.
FROM node:18-alpine

# Set the working directory for the final image.
WORKDIR /app

# Copy only the necessary node_modules from the builder stage.
# This keeps the final image small.
COPY --from=builder /app/node_modules ./node_modules

# Copy the application source code.
COPY app.js .

# Expose the port the application runs on.
EXPOSE 3000

# Set the default command to run when the container starts.
CMD ["node","app.js"]