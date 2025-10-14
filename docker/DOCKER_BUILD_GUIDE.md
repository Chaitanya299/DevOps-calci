# Docker Build Guide - Multi-Stage Dockerfile

## 📦 Multi-Stage Dockerfile Benefits

- **Smaller image size** - Only runtime dependencies in final image
- **Better security** - Non-root user, minimal attack surface
- **Faster builds** - Layer caching for dependencies
- **Development support** - Separate dev stage with hot reload

---

## 🚀 Quick Build Commands

### Option 1: Using Docker Compose (Recommended)

```bash
cd /Users/parasana/Downloads/CascadeProjects/windsurf-project

# Build and run in one command
docker-compose up --build

# Or build first, then run
docker-compose build
docker-compose up -d

# View logs
docker-compose logs -f

# Stop containers
docker-compose down
```

### Option 2: Using Docker Commands

```bash
cd /Users/parasana/Downloads/CascadeProjects/windsurf-project

# Build the image
docker build -t simple-calculator:latest .

# Run the container
docker run -d -p 3000:3000 --name calculator-app simple-calculator:latest

# Check if running
docker ps

# View logs
docker logs -f calculator-app
```

---

## 🏗️ Build Stages Explained

### Stage 1: `builder` (Development)
- **Base:** node:20-alpine
- **Purpose:** Install all dependencies (including dev dependencies)
- **Output:** Complete development environment

### Stage 2: `runtime` (Production)
- **Base:** node:20-alpine (fresh)
- **Purpose:** Production-ready image with only runtime dependencies
- **Security:** Non-root user `calculator`
- **Size:** Much smaller (~50MB vs ~200MB)

---

## 📊 Image Size Comparison

```bash
# Build the image
docker build -t simple-calculator:latest .

# Check image size
docker images simple-calculator

# Should show around 50-60MB for the optimized image
```

---

## 🧪 Development Mode

For development with file watching:

```bash
# Run development version with volume mounting
docker-compose --profile dev up

# Or manually
docker run -d -p 3001:3000 -v $(pwd):/app --name calculator-dev simple-calculator:latest
```

---

## 🔧 Docker Commands Reference

### Build with different targets:
```bash
# Build only builder stage (for debugging)
docker build --target builder -t simple-calculator:builder .

# Build only runtime stage (default)
docker build --target runtime -t simple-calculator:runtime .
```

### Build with no cache:
```bash
docker build --no-cache -t simple-calculator:latest .
```

### List all images:
```bash
docker images
```

### Remove dangling images:
```bash
docker image prune
```

---

## 🏃‍♂️ Run Commands

### Basic run:
```bash
docker run -d -p 3000:3000 --name calc simple-calculator:latest
```

### With custom port:
```bash
docker run -d -p 8080:3000 --name calc-8080 simple-calculator:latest
```

### Interactive mode (for debugging):
```bash
docker run -it --rm simple-calculator:latest sh
```

### Execute command in running container:
```bash
docker exec -it calc sh
```

---

## 🛑 Stop and Cleanup

```bash
# Stop container
docker stop calc

# Remove container
docker rm calc

# Remove image
docker rmi simple-calculator:latest

# Clean everything (be careful!)
docker system prune -a
```

---

## 📋 Complete Workflow

```bash
# 1. Navigate to project
cd /Users/parasana/Downloads/CascadeProjects/windsurf-project

# 2. Build the multi-stage image
docker build -t simple-calculator:latest .

# 3. Run the optimized container
docker run -d -p 3000:3000 --name calculator-app simple-calculator:latest

# 4. Verify it's running
docker ps | grep calculator-app

# 5. Check logs
docker logs calculator-app

# 6. Test the app
open http://localhost:3000

# 7. Check health
docker inspect --format='{{json .State.Health}}' calculator-app | jq

# 8. Stop when done
docker stop calculator-app
docker rm calculator-app
```

---

## 🔍 Inspect the Image

```bash
# View image layers
docker history simple-calculator:latest

# Inspect image details
docker inspect simple-calculator:latest

# See image size breakdown
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

---

## 🚨 Troubleshooting

### Port already in use:
```bash
# Find what's using port 3000
lsof -i :3000

# Kill the process or use different port
docker run -d -p 3001:3000 --name calc-3001 simple-calculator:latest
```

### Build fails:
```bash
# Check Dockerfile syntax
docker build --dry-run .

# Build with verbose output
docker build -t simple-calculator:latest . --progress=plain

# Check for errors in logs
docker logs calculator-app
```

---

## 📁 Files Created

- ✅ **`Dockerfile`** - Multi-stage production Dockerfile
- ✅ **`docker-compose.yml`** - Production and development configs
- ✅ **`.dockerignore`** - Optimized file exclusion
- ✅ **This guide** - Complete build instructions

---

## 🎯 Next Steps

1. **Build the image:** `docker build -t simple-calculator:latest .`
2. **Run the container:** `docker run -d -p 3000:3000 --name calc simple-calculator:latest`
3. **Access the app:** http://localhost:3000
4. **Enjoy your optimized containerized calculator!** 🎉

The multi-stage build creates a **~50MB production image** compared to **~200MB single-stage**, with better security and performance! 🚀
