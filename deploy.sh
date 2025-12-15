#!/bin/bash

# =====================================================
# Cybersecurity Project - Hostinger Deployment Script
# =====================================================
# This script automates the deployment process on Hostinger VPS
# Run this script on your VPS after initial setup

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$HOME/cybersecurity-project"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"
LOGS_DIR="$HOME/logs"

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed"
        return 1
    fi
    print_success "$1 is installed"
    return 0
}

# =====================================================
# Step 1: Check Prerequisites
# =====================================================
print_info "Checking prerequisites..."

check_command python3.11 || exit 1
check_command node || exit 1
check_command npm || exit 1
check_command pm2 || exit 1
check_command psql || print_info "PostgreSQL not found, will use SQLite"
check_command nginx || print_info "Nginx not found, skipping reverse proxy setup"

# =====================================================
# Step 2: Create Logs Directory
# =====================================================
print_info "Creating logs directory..."
mkdir -p "$LOGS_DIR"
print_success "Logs directory created at $LOGS_DIR"

# =====================================================
# Step 3: Backend Setup
# =====================================================
print_info "Setting up backend..."

cd "$BACKEND_DIR"

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    print_info "Creating Python virtual environment..."
    python3.11 -m venv .venv
    print_success "Virtual environment created"
else
    print_info "Virtual environment already exists"
fi

# Activate virtual environment
source .venv/bin/activate

# Upgrade pip
print_info "Upgrading pip..."
pip install --upgrade pip --quiet

# Install dependencies
print_info "Installing backend dependencies..."
pip install -r requirements.txt --quiet
pip install gunicorn psycopg2-binary --quiet
print_success "Backend dependencies installed"

# Check if .env exists
if [ ! -f ".env" ]; then
    print_error ".env file not found in backend directory"
    print_info "Please create .env file from .env.production template"
    print_info "cp .env.production .env"
    print_info "Then edit .env with your configuration"
    exit 1
fi

# Initialize database
print_info "Initializing database..."
python3 -c "from app import app, db; app.app_context().push(); db.create_all(); print('Database initialized!')" || print_error "Database initialization failed"
print_success "Database initialized"

deactivate

# =====================================================
# Step 4: Frontend Setup
# =====================================================
print_info "Setting up frontend..."

cd "$FRONTEND_DIR"

# Check if .env.production exists
if [ ! -f ".env.production" ]; then
    print_error ".env.production file not found in frontend directory"
    print_info "Please create .env.production file with your API URL"
    exit 1
fi

# Install dependencies
print_info "Installing frontend dependencies..."
npm install --quiet
print_success "Frontend dependencies installed"

# Build frontend
print_info "Building frontend for production..."
npm run build
print_success "Frontend built successfully"

# =====================================================
# Step 5: PM2 Setup
# =====================================================
print_info "Setting up PM2..."

cd "$PROJECT_DIR"

# Stop existing PM2 processes
print_info "Stopping existing PM2 processes..."
pm2 delete all 2>/dev/null || true

# Start applications
print_info "Starting applications with PM2..."
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 startup script
print_info "Setting up PM2 startup script..."
pm2 startup | grep -v "PM2" | bash || true

print_success "PM2 configured and applications started"

# =====================================================
# Step 6: Display Status
# =====================================================
print_info "Deployment Status:"
pm2 status

# =====================================================
# Step 7: Final Instructions
# =====================================================
echo ""
print_success "Deployment completed successfully!"
echo ""
print_info "Next steps:"
echo "1. Configure Nginx reverse proxy (see HOSTINGER_DEPLOYMENT.md)"
echo "2. Setup SSL certificate with Let's Encrypt"
echo "3. Configure firewall (UFW)"
echo "4. Test your application"
echo ""
print_info "Useful commands:"
echo "  pm2 status          - Check application status"
echo "  pm2 logs            - View application logs"
echo "  pm2 restart all     - Restart all applications"
echo "  pm2 monit           - Monitor resources"
echo ""
print_info "Access your application:"
echo "  Frontend: http://localhost:3000"
echo "  Backend:  http://localhost:5000"
echo "  API Docs: http://localhost:5000/api/docs/swagger"
echo ""
