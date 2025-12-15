# 🚀 Deploy to Hostinger VPS - srv1200300.hstgr.cloud

## 📋 Your VPS Specifications

- **Hostname**: srv1200300.hstgr.cloud
- **IP Address**: 31.97.220.120
- **Location**: Indonesia - Jakarta
- **OS**: Ubuntu 24.04 LTS
- **Plan**: KVM 8
- **CPU Cores**: 8
- **Memory**: 32 GB
- **Disk Space**: 400 GB
- **SSH User**: root
- **Expiration**: 2026-01-15 (Auto-renewal: ON)

**🎉 This is a HIGH-PERFORMANCE server - perfect for running ALL features!**

---

## ⚡ One-Command Deployment

Copy and paste this entire block into your terminal after connecting via SSH:

```bash
ssh root@31.97.220.120
```

Then run this automated setup:

```bash
curl -fsSL https://raw.githubusercontent.com/JawadAliAI/Cybersecurity-System/main/deploy.sh | bash
```

Or follow the manual steps below for more control.

---

## 📝 Manual Deployment Steps

### Step 1: Connect to VPS

```bash
ssh root@31.97.220.120
```

### Step 2: System Setup (5 minutes)

```bash
# Update system
apt update && apt upgrade -y

# Install essential tools
apt install -y curl wget git build-essential software-properties-common

# Install Python 3.11
add-apt-repository -y ppa:deadsnakes/ppa
apt update
apt install -y python3.11 python3.11-venv python3.11-dev python3-pip

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install PostgreSQL
apt install -y postgresql postgresql-contrib

# Install Nginx
apt install -y nginx

# Install Redis (for caching - your server can handle it!)
apt install -y redis-server

# Install PM2
npm install -g pm2

# Verify installations
echo "=== Installed Versions ==="
python3.11 --version
node --version
npm --version
pm2 --version
psql --version
nginx -v
redis-server --version
```

### Step 3: Create Application User

```bash
# Create cybersec user
adduser cybersec
# Password: (choose a strong password)

# Add to sudo group
usermod -aG sudo cybersec
```

### Step 4: Setup PostgreSQL Database

```bash
# Configure PostgreSQL
sudo -u postgres psql << EOF
CREATE DATABASE cybersecurity_db;
CREATE USER cybersec_user WITH PASSWORD 'CyberSec2025!SecurePass';
GRANT ALL PRIVILEGES ON DATABASE cybersecurity_db TO cybersec_user;
ALTER DATABASE cybersecurity_db OWNER TO cybersec_user;
\q
EOF

echo "✅ Database created successfully"
```

### Step 5: Configure Redis

```bash
# Start and enable Redis
systemctl start redis-server
systemctl enable redis-server

# Test Redis
redis-cli ping
# Should return: PONG
```

### Step 6: Switch to Application User

```bash
su - cybersec
```

### Step 7: Clone Repository

```bash
# Clone from GitHub
cd ~
git clone https://github.com/JawadAliAI/Cybersecurity-System.git
cd Cybersecurity-System

# Make scripts executable
chmod +x deploy.sh update.sh backup.sh start_backend.sh

# Create logs directory
mkdir -p ~/logs
```

### Step 8: Generate Secret Keys

```bash
# Generate and save these keys
echo "=== SECRET KEYS - SAVE THESE! ==="
python3 -c "import secrets; print('SECRET_KEY=' + secrets.token_hex(32))"
python3 -c "import secrets; print('JWT_SECRET_KEY=' + secrets.token_hex(32))"
echo "================================"
```

### Step 9: Configure Backend Environment

```bash
cd ~/Cybersecurity-System/backend
cp .env.production .env
nano .env
```

**Add this configuration to `backend/.env`:**

```env
# =====================================================
# DATABASE CONFIGURATION
# =====================================================
DATABASE_URL=postgresql://cybersec_user:CyberSec2025!SecurePass@localhost:5432/cybersecurity_db

# =====================================================
# SECURITY KEYS (REPLACE WITH YOUR GENERATED KEYS!)
# =====================================================
SECRET_KEY=YOUR_GENERATED_SECRET_KEY_HERE
JWT_SECRET_KEY=YOUR_GENERATED_JWT_SECRET_KEY_HERE
JWT_ALGORITHM=HS256

# =====================================================
# ENVIRONMENT
# =====================================================
ENVIRONMENT=production
FLASK_ENV=production
LOG_LEVEL=INFO

# =====================================================
# SERVER CONFIGURATION
# =====================================================
HOST=0.0.0.0
PORT=5000

# =====================================================
# FRONTEND CONFIGURATION
# =====================================================
FRONTEND_URL=http://31.97.220.120
CORS_ORIGINS=http://31.97.220.120,http://srv1200300.hstgr.cloud

# =====================================================
# REDIS CONFIGURATION (ENABLED - You have the resources!)
# =====================================================
REDIS_URL=redis://localhost:6379
SOCKETIO_MESSAGE_QUEUE_URL=redis://localhost:6379

# =====================================================
# PERFORMANCE TUNING (Optimized for 32GB RAM, 8 CPU)
# =====================================================
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=40
WORKERS=4
WORKER_CLASS=eventlet
WORKER_TIMEOUT=120

# =====================================================
# FEATURE FLAGS
# =====================================================
ENABLE_WEBSOCKETS=true
ENABLE_RATE_LIMITING=true
ENABLE_AUDIT_LOGGING=true
ENABLE_METRICS=true
```

### Step 10: Configure Frontend Environment

```bash
cd ~/Cybersecurity-System/frontend
nano .env.production
```

**Add this to `frontend/.env.production`:**

```env
# Backend API URL
NEXT_PUBLIC_API_URL=http://31.97.220.120:5000

# Alternative hostname
# NEXT_PUBLIC_API_URL=http://srv1200300.hstgr.cloud:5000

# WebSocket URL
NEXT_PUBLIC_WS_URL=http://31.97.220.120:5000

# Environment
NODE_ENV=production

# Application
NEXT_PUBLIC_APP_NAME=Cybersecurity Dashboard
NEXT_PUBLIC_APP_VERSION=1.0.0

# Features
NEXT_PUBLIC_ENABLE_WEBSOCKETS=true
NEXT_PUBLIC_ENABLE_NOTIFICATIONS=true
```

### Step 11: Update PM2 Ecosystem Config

```bash
cd ~/Cybersecurity-System
nano ecosystem.config.js
```

**Update paths in ecosystem.config.js:**

```javascript
module.exports = {
  apps: [
    {
      name: 'cybersec-backend',
      script: './start_backend.sh',
      cwd: '/home/cybersec/Cybersecurity-System/backend',
      interpreter: '/bin/bash',
      env: {
        NODE_ENV: 'production',
        PYTHONUNBUFFERED: '1'
      },
      error_file: '/home/cybersec/logs/backend-error.log',
      out_file: '/home/cybersec/logs/backend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      restart_delay: 4000,
      watch: false,
      instances: 1,
      exec_mode: 'fork'
    },
    {
      name: 'cybersec-frontend',
      script: 'npm',
      args: 'start',
      cwd: '/home/cybersec/Cybersecurity-System/frontend',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: '/home/cybersec/logs/frontend-error.log',
      out_file: '/home/cybersec/logs/frontend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      restart_delay: 4000,
      watch: false,
      instances: 1,
      exec_mode: 'fork'
    }
  ]
};
```

### Step 12: Run Deployment Script

```bash
cd ~/Cybersecurity-System
./deploy.sh
```

**This will:**
- ✅ Check prerequisites
- ✅ Create Python virtual environment
- ✅ Install backend dependencies
- ✅ Install frontend dependencies
- ✅ Build frontend for production
- ✅ Initialize database
- ✅ Start applications with PM2

### Step 13: Configure Nginx (Exit to root user)

```bash
# Exit cybersec user
exit

# Copy nginx config
cp /home/cybersec/Cybersecurity-System/nginx.conf /etc/nginx/sites-available/cybersecurity

# Edit nginx config
nano /etc/nginx/sites-available/cybersecurity
```

**Update nginx.conf - change `your-domain.com` to:**

```nginx
server_name 31.97.220.120 srv1200300.hstgr.cloud;
```

**Or for IP-only access:**

```nginx
server_name _;
```

**Enable the site:**

```bash
# Enable site
ln -s /etc/nginx/sites-available/cybersecurity /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Test configuration
nginx -t

# Restart Nginx
systemctl restart nginx
systemctl enable nginx
```

### Step 14: Configure Firewall

```bash
# Allow SSH (CRITICAL - Don't lock yourself out!)
ufw allow 22/tcp

# Allow HTTP and HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Allow backend port (optional, Nginx will proxy)
# ufw allow 5000/tcp

# Enable firewall
ufw --force enable

# Check status
ufw status verbose
```

### Step 15: Verify Deployment

```bash
# Switch back to cybersec user
su - cybersec

# Check PM2 status
pm2 status

# View logs
pm2 logs --lines 50

# Test backend
curl http://localhost:5000/api/health

# Test frontend
curl http://localhost:3000

# Exit and test from outside
exit
curl http://31.97.220.120/api/health
```

---

## 🌐 Access Your Application

### Primary Access
- **Frontend**: http://31.97.220.120
- **Backend API**: http://31.97.220.120/api
- **API Docs**: http://31.97.220.120/api/docs/swagger

### Alternative Hostname
- **Frontend**: http://srv1200300.hstgr.cloud
- **Backend API**: http://srv1200300.hstgr.cloud/api

---

## � Performance Optimization (32GB RAM, 8 CPU)

Your server can handle advanced features:

### Enable Full Docker Stack (Optional)

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Run full stack with ELK
cd /home/cybersec/Cybersecurity-System
docker-compose up -d
```

### Monitor Resources

```bash
# Install htop
apt install -y htop

# Monitor in real-time
htop

# Check memory
free -h

# Check disk
df -h

# Check CPU
lscpu
```

---

## 🔄 Common Operations

```bash
# Check status
pm2 status

# View logs
pm2 logs

# Restart all
pm2 restart all

# Update deployment
cd ~/Cybersecurity-System
git pull origin main
./update.sh

# Create backup
./backup.sh

# Monitor resources
pm2 monit
```

---

## 🆘 Troubleshooting

### Check All Services

```bash
# PM2 apps
pm2 status

# Nginx
systemctl status nginx

# PostgreSQL
systemctl status postgresql

# Redis
systemctl status redis-server

# Check ports
ss -tulpn | grep -E ':(3000|5000|5432|6379|80)'
```

### View Logs

```bash
# PM2 logs
pm2 logs

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# Application logs
tail -f ~/logs/backend-out.log
tail -f ~/logs/frontend-out.log
```

### Restart Services

```bash
# Restart applications
pm2 restart all

# Restart Nginx
sudo systemctl restart nginx

# Restart PostgreSQL
sudo systemctl restart postgresql

# Restart Redis
sudo systemctl restart redis-server
```

---

## 📊 Server Specifications Summary

```
Hostname:     srv1200300.hstgr.cloud
IP:           31.97.220.120
Location:     Jakarta, Indonesia
OS:           Ubuntu 24.04 LTS
CPU:          8 cores
RAM:          32 GB
Disk:         400 GB
Plan:         KVM 8
Expires:      2026-01-15
Auto-renew:   ON
```

**This server can easily handle:**
- ✅ Full application stack
- ✅ Redis caching
- ✅ Multiple concurrent users
- ✅ Docker containers
- ✅ ELK stack
- ✅ Advanced monitoring
- ✅ Load testing

---

## ✅ Deployment Checklist

- [ ] Connected to VPS (ssh root@31.97.220.120)
- [ ] System updated
- [ ] Python 3.11 installed
- [ ] Node.js 18 installed
- [ ] PostgreSQL installed
- [ ] Redis installed
- [ ] Nginx installed
- [ ] PM2 installed
- [ ] User 'cybersec' created
- [ ] Database created
- [ ] Repository cloned
- [ ] Secret keys generated
- [ ] Backend .env configured
- [ ] Frontend .env.production configured
- [ ] Deployment script executed
- [ ] PM2 apps running
- [ ] Nginx configured
- [ ] Firewall configured
- [ ] Application accessible at http://31.97.220.120

---

## 🎉 Success!

Your cybersecurity application is now live!

**Access it at**: http://31.97.220.120

---

*VPS Deployment Guide*  
*Server: srv1200300.hstgr.cloud (31.97.220.120)*  
*Location: Jakarta, Indonesia*  
*Created: 2025-12-15*
