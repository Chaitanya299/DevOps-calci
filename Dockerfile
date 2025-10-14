# Multi-stage Dockerfile for Simple Calculator

# Stage 1: Build stage (for dependencies)
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files for better layer caching
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Stage 2: Production stage (runtime only)
FROM node:20-alpine AS runtime

WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S calculator -u 1001

# Copy package files for better layer caching
COPY package*.json ./
COPY package-lock.json ./

# Install only production dependencies
RUN npm ci --omit=dev

# Copy application files
COPY server.js .
COPY index.html .

# Change ownership to nodejs user
RUN chown -R calculator:nodejs /app
USER calculator

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["node", "server.js"]
