#!/bin/bash

# =====================================================
# Cybersecurity Project - Update Deployment Script
# =====================================================
# This script updates an existing deployment with new code
# Run this after pulling new changes from git

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

# =====================================================
# Step 1: Pull Latest Changes
# =====================================================
print_info "Pulling latest changes from git..."
cd "$PROJECT_DIR"
git pull origin main || print_error "Git pull failed"
print_success "Code updated"

# =====================================================
# Step 2: Update Backend
# =====================================================
print_info "Updating backend..."

cd "$BACKEND_DIR"

# Activate virtual environment
source .venv/bin/activate

# Update dependencies
print_info "Updating backend dependencies..."
pip install -r requirements.txt --quiet
print_success "Backend dependencies updated"

# Run database migrations if needed
print_info "Updating database schema..."
python3 -c "from app import app, db; app.app_context().push(); db.create_all(); print('Database updated!')" || print_error "Database update failed"
print_success "Database updated"

deactivate

# =====================================================
# Step 3: Update Frontend
# =====================================================
print_info "Updating frontend..."

cd "$FRONTEND_DIR"

# Update dependencies
print_info "Updating frontend dependencies..."
npm install --quiet
print_success "Frontend dependencies updated"

# Rebuild frontend
print_info "Rebuilding frontend..."
npm run build
print_success "Frontend rebuilt"

# =====================================================
# Step 4: Restart Applications
# =====================================================
print_info "Restarting applications..."

cd "$PROJECT_DIR"
pm2 restart all

print_success "Applications restarted"

# =====================================================
# Step 5: Display Status
# =====================================================
print_info "Application Status:"
pm2 status

echo ""
print_success "Update completed successfully!"
echo ""
print_info "Check logs for any errors:"
echo "  pm2 logs"
echo ""
