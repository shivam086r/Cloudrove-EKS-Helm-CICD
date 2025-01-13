# Stage 1: Build Stage
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Stage 2: Final Image (Alpine)
FROM node:18-alpine

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory in the container
WORKDIR /app

# Copy the app files from the build stage
COPY --from=build /app /app

# Change ownership of the application files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the port the app will run on
EXPOSE 5000

# Command to run the app
CMD ["npm", "start"]
