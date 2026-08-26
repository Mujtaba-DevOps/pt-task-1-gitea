#!/bin/bash

set -e

echo "======================================"
echo "   Gitea Local Setup Automation"
echo "======================================"

# Get the directory where this script is located
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "[1/7] Checking project directory..."

if [ ! -f "$PROJECT_DIR/Makefile" ] || [ ! -f "$PROJECT_DIR/go.mod" ]; then
    echo "ERROR: This does not appear to be the Gitea project directory."
    exit 1
fi

cd "$PROJECT_DIR"

echo "Project directory: $PROJECT_DIR"
echo "Project directory verified."

echo ""
echo "[2/7] Checking required tools..."

REQUIRED_TOOLS=("git" "go" "node" "pnpm" "make")

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "ERROR: Required tool '$tool' is not installed."
        exit 1
    fi
    echo "OK: $tool"
done

echo ""
echo "[3/7] Checking dependency versions..."

echo "Git:    $(git --version)"
echo "Go:     $(go version)"
echo "Node:   $(node --version)"
echo "pnpm:   $(pnpm --version)"
echo "Make:   $(make --version | head -n 1)"

echo ""
echo "[4/7] Building Gitea from source..."

if ! make build; then
    echo "ERROR: Gitea build failed."
    exit 1
fi

echo "Gitea build completed successfully."

echo ""
echo "[5/7] Verifying Gitea binary..."

if [ ! -f "$PROJECT_DIR/gitea" ]; then
    echo "ERROR: Gitea binary was not created."
    exit 1
fi

if [ ! -x "$PROJECT_DIR/gitea" ]; then
    echo "ERROR: Gitea binary is not executable."
    exit 1
fi

echo "Gitea binary verified:"
ls -lh "$PROJECT_DIR/gitea"

echo ""
echo "[6/7] Checking port 3000..."

if ss -ltn 2>/dev/null | grep -q ':3000 '; then
    echo "ERROR: Port 3000 is already in use."
    echo "Please stop the process using port 3000 and run the script again."
    exit 1
fi

echo "Port 3000 is available."

echo ""
echo "[7/7] Starting Gitea..."

echo ""
echo "======================================"
echo "Gitea is starting..."
echo "Local URL: http://localhost:3000"
echo "======================================"
echo ""

exec "$PROJECT_DIR/gitea" web
