#!/bin/bash

# Script for automatic installation of Docker, Docker Compose, Python 3.9+, and Django
# Compatible with Ubuntu / Debian systems

set -e  # stop execution if any command fails

echo "🚀 Starting development environment setup..."

# === Install Docker ===
if ! command -v docker &> /dev/null
then
    echo "🐋 Docker not found. Installing..."
    sudo apt update -y
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "✅ Docker installed successfully."
else
    echo "✅ Docker is already installed. Skipping..."
fi

# === Install Docker Compose ===
if ! command -v docker-compose &> /dev/null
then
    echo "🐳 Docker Compose not found. Installing..."
    sudo apt install -y docker-compose
    echo "✅ Docker Compose installed successfully."
else
    echo "✅ Docker Compose is already installed. Skipping..."
fi

# === Install Python 3.9+ ===
if ! command -v python3 &> /dev/null
then
    echo "🐍 Python not found. Installing..."
    sudo apt update -y
    sudo apt install -y python3 python3-pip python3-venv
    echo "✅ Python installed successfully."
else
    PY_VERSION=$(python3 -V | awk '{print $2}')
    echo "🔍 Current Python version: $PY_VERSION"
    if [[ "$PY_VERSION" < "3.9" ]]; then
        echo "⚙️ Python version is lower than 3.9. Updating..."
        sudo apt install -y python3.9 python3.9-venv python3.9-distutils
        echo "✅ Python 3.9 installed successfully."
    else
        echo "✅ Python 3.9+ is already installed. Skipping..."
    fi
fi

# === Install Django ===
if ! python3 -m django --version &> /dev/null
then
    echo "🌐 Django not found. Installing..."
    pip3 install --upgrade pip
    pip3 install django
    echo "✅ Django installed successfully."
else
    DJANGO_VERSION=$(python3 -m django --version)
    echo "✅ Django is already installed (version $DJANGO_VERSION). Skipping..."
fi

echo "🎉 All development tools have been installed successfully!"
