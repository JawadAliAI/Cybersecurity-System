#!/bin/bash

# =====================================================
# Cybersecurity Project - Backup Script
# =====================================================
# This script creates backups of database and application files

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$HOME/cybersecurity-project"
BACKUP_DIR="$HOME/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Database configuration (update these)
DB_NAME="cybersecurity_db"
DB_USER="cybersec_user"
DB_HOST="localhost"

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
# Step 1: Create Backup Directory
# =====================================================
print_info "Creating backup directory..."
mkdir -p "$BACKUP_DIR"
print_success "Backup directory: $BACKUP_DIR"

# =====================================================
# Step 2: Backup Database
# =====================================================
print_info "Backing up database..."

# Check if PostgreSQL is available
if command -v pg_dump &> /dev/null; then
    BACKUP_FILE="$BACKUP_DIR/db_backup_$DATE.sql"
    pg_dump -U "$DB_USER" -h "$DB_HOST" "$DB_NAME" > "$BACKUP_FILE" 2>/dev/null || print_error "PostgreSQL backup failed"
    
    if [ -f "$BACKUP_FILE" ]; then
        # Compress backup
        gzip "$BACKUP_FILE"
        print_success "Database backup created: ${BACKUP_FILE}.gz"
    fi
else
    # Backup SQLite database if exists
    SQLITE_DB="$PROJECT_DIR/backend/instance/cybersecurity.db"
    if [ -f "$SQLITE_DB" ]; then
        cp "$SQLITE_DB" "$BACKUP_DIR/db_backup_$DATE.db"
        gzip "$BACKUP_DIR/db_backup_$DATE.db"
        print_success "SQLite database backup created: $BACKUP_DIR/db_backup_$DATE.db.gz"
    else
        print_info "No database found to backup"
    fi
fi

# =====================================================
# Step 3: Backup Application Files
# =====================================================
print_info "Backing up application files..."

BACKUP_ARCHIVE="$BACKUP_DIR/app_backup_$DATE.tar.gz"

# Exclude large directories and files
tar -czf "$BACKUP_ARCHIVE" \
    --exclude="$PROJECT_DIR/backend/.venv" \
    --exclude="$PROJECT_DIR/backend/__pycache__" \
    --exclude="$PROJECT_DIR/frontend/node_modules" \
    --exclude="$PROJECT_DIR/frontend/.next" \
    --exclude="$PROJECT_DIR/.git" \
    -C "$HOME" \
    "cybersecurity-project"

print_success "Application backup created: $BACKUP_ARCHIVE"

# =====================================================
# Step 4: Backup Environment Files
# =====================================================
print_info "Backing up environment files..."

ENV_BACKUP="$BACKUP_DIR/env_backup_$DATE.tar.gz"

tar -czf "$ENV_BACKUP" \
    -C "$PROJECT_DIR/backend" .env \
    -C "$PROJECT_DIR/frontend" .env.production 2>/dev/null || print_info "Some env files not found"

if [ -f "$ENV_BACKUP" ]; then
    print_success "Environment files backup created: $ENV_BACKUP"
fi

# =====================================================
# Step 5: Cleanup Old Backups
# =====================================================
print_info "Cleaning up old backups (keeping last 30 days)..."

find "$BACKUP_DIR" -name "*.gz" -type f -mtime +30 -delete 2>/dev/null || true
find "$BACKUP_DIR" -name "*.sql" -type f -mtime +30 -delete 2>/dev/null || true

print_success "Old backups cleaned up"

# =====================================================
# Step 6: Display Backup Summary
# =====================================================
echo ""
print_success "Backup completed successfully!"
echo ""
print_info "Backup location: $BACKUP_DIR"
print_info "Backup files:"
ls -lh "$BACKUP_DIR" | grep "$DATE"
echo ""
print_info "Total backup size:"
du -sh "$BACKUP_DIR"
echo ""
