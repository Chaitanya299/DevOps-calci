# Simple Calculator

A simple, interactive calculator web application with a modern UI.

## Features

- ✨ Basic arithmetic operations: Addition, Subtraction, Multiplication, Division
- 🎨 Modern gradient UI with smooth animations
- ⌨️ Keyboard support for quick calculations
- 🛡️ Error handling (e.g., division by zero)
- 📱 Responsive design

## Quick Start

### Prerequisites
- Node.js (v18 or higher)

### Installation & Running

1. Clone the repository
```bash
git clone <your-repo-url>
cd windsurf-project
```

2. Start the server
```bash
node server.js
```

3. Open your browser and visit
```
http://localhost:3000
```

## Usage

### Mouse Controls
Click the calculator buttons to perform operations.

### Keyboard Shortcuts
- **Numbers (0-9)**: Input numbers
- **Operators (+, -, *, /)**: Perform operations
- **Enter or =**: Calculate result
- **Escape**: Clear all (AC)
- **Backspace**: Delete last digit

## Project Structure

```
windsurf-project/
├── .github/
│   └── workflows/
│       └── ci.yml          # GitHub Actions CI pipeline
├── index.html              # Calculator UI
├── server.js               # Node.js server
├── package.json            # Project configuration
└── README.md               # This file
```

## CI/CD Pipeline

This project includes a GitHub Actions CI pipeline that:

### Build & Test Job
- ✅ Tests on Node.js 18.x and 20.x
- ✅ Verifies all required files exist
- ✅ Checks JavaScript syntax
- ✅ Starts the server and validates it's running
- ✅ Tests HTTP responses
- ✅ Verifies HTML content is served correctly

### Lint Job
- ✅ Validates HTML5 structure
- ✅ Checks for required HTML elements
- ✅ Validates package.json format

The pipeline runs automatically on:
- Push to `main`, `master`, or `develop` branches
- Pull requests to these branches

## Development

To run the project locally:
```bash
npm start
```

To stop the server:
```bash
# Press Ctrl+C in the terminal
# Or kill the process
pkill -f "node server.js"
```

## License

ISC
