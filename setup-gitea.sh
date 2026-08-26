#!/bin/bash

echo "Gitea Local Setup Automation"

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "[1] Checking project directory..."

if [ ! -f "Makefile" ] || [ ! -f "go.mod" ]; then
    echo "ERROR: Not a Gitea project directory."
    exit 1
fi

echo "Project directory verified."

echo "[2] Checking required tools..."

command -v git >/dev/null || { echo "Git is not installed."; exit 1; }
command -v go >/dev/null || { echo "Go is not installed."; exit 1; }
command -v node >/dev/null || { echo "Node.js is not installed."; exit 1; }
command -v pnpm >/dev/null || { echo "pnpm is not installed."; exit 1; }
command -v make >/dev/null || { echo "Make is not installed."; exit 1; }

echo "All required tools are installed."

echo "[3] Checking versions..."

git --version
go version
node --version
pnpm --version
make --version | head -n 1

echo "[4] Building Gitea..."

make build

if [ ! -f "$PROJECT_DIR/gitea" ]; then
    echo "ERROR: Gitea binary was not created."
    exit 1
fi

echo "Gitea build successful."

echo "[5] Checking port 3000..."

if ss -ltn | grep -q ":3000 "; then
    echo "ERROR: Port 3000 is already in use."
    exit 1
fi

echo "Port 3000 is available."

echo "[6] Starting Gitea..."

echo "Gitea URL: http://localhost:3000"

./gitea web

