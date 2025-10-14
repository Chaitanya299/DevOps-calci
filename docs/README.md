# Simple Calculator

A modern, interactive calculator web application with Docker containerization and Kubernetes deployment capabilities.

## 🚀 Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd windsurf-project

# Start locally
node server.js

# Or with Docker
docker-compose -f docker/docker-compose.yml up

# Or deploy to Kubernetes
./deploy-to-k8s.sh

# Visit: http://localhost:3000
```

## 📚 Documentation

📖 **[Complete Documentation](docs/README.md)** - Project overview, setup, and usage guides

### Key Guides:
- 🐳 **[Docker Guide](docker/DOCKER_BUILD_GUIDE.md)** - Container build and deployment
- ☸️ **[Kubernetes Guide](docs/KUBERNETES_GUIDE.md)** - Local K8s cluster setup and testing
- 🔧 **[Git Deployment](docs/PUSH_TO_MASTER.md)** - GitHub integration and CI/CD
- 📁 **[Project Structure](docs/PROJECT_STRUCTURE.md)** - File organization overview

## 🏗️ Project Structure

```
/Users/parasana/Downloads/CascadeProjects/windsurf-project/
├── docs/              # 📚 Documentation and guides
├── docker/            # 🐳 Docker configuration and builds
├── k8s/              # ☸️ Kubernetes deployment manifests
├── .github/          # 🔧 CI/CD pipeline configuration
├── server.js         # 🚀 Node.js application server
├── index.html        # 🎨 Calculator user interface
└── package.json      # 📦 Project dependencies
```

## ✨ Features

- 🎨 Modern dark theme with smooth animations
- 🔢 Full calculator functionality (add, subtract, multiply, divide)
- ⌨️ Keyboard support for quick calculations
- 🐳 Docker containerization with multi-stage builds
- ☸️ Kubernetes deployment with health checks and load balancing
- 🔧 GitHub Actions CI/CD pipeline
- 📱 Responsive design for all screen sizes

## 🛠️ Technologies

- **Frontend:** HTML5, CSS3, Vanilla JavaScript
- **Backend:** Node.js HTTP server
- **Containerization:** Docker with multi-stage builds
- **Orchestration:** Kubernetes with kind for local development
- **CI/CD:** GitHub Actions with automated testing

---

*For complete documentation, see **[docs/README.md](docs/README.md)***
