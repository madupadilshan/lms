#!/bin/bash

# LMS Docker Deployment Script
# Run this script on your VPS

set -e

echo "======================================"
echo "  LMS Docker Deployment Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Step 1: Update system
echo ""
echo "Step 1: Updating system..."
apt update && apt upgrade -y
print_status "System updated"

# Step 2: Install Docker if not installed
echo ""
echo "Step 2: Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
    print_status "Docker installed"
else
    print_warning "Docker already installed"
fi

# Step 3: Install Docker Compose if not installed
echo ""
echo "Step 3: Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    apt install docker-compose-plugin -y
    print_status "Docker Compose installed"
else
    print_warning "Docker Compose already installed"
fi

# Verify installations
echo ""
echo "Verifying installations..."
docker --version
docker compose version
print_status "All dependencies verified"

# Step 4: Create project directory
echo ""
echo "Step 4: Setting up project directory..."
PROJECT_DIR="/opt/lms"
mkdir -p $PROJECT_DIR
print_status "Project directory created at $PROJECT_DIR"

# Step 5: Instructions for next steps
echo ""
echo "======================================"
echo "  Initial Setup Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Upload your project files to $PROJECT_DIR"
echo "   From your local machine, run:"
echo "   scp -r . root@YOUR_SERVER_IP:$PROJECT_DIR/"
echo ""
echo "2. Create .env file:"
echo "   cd $PROJECT_DIR"
echo "   cp .env.example .env"
echo "   nano .env  # Edit with your passwords"
echo ""
echo "3. Start the application:"
echo "   cd $PROJECT_DIR"
echo "   docker compose -f docker-compose.prod.yml up -d --build"
echo ""
echo "4. Check logs:"
echo "   docker compose -f docker-compose.prod.yml logs -f"
echo ""
echo "5. Access your application at:"
echo "   http://YOUR_SERVER_IP"
echo ""
