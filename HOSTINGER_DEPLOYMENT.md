# 🚀 Hostinger Deployment Guide

## Overview

This guide will help you deploy the Cybersecurity Project to Hostinger's VPS hosting. The application consists of:
- **Backend**: Flask/Python API (Port 5000)
- **Frontend**: Next.js React application (Port 3000)
- **Database**: PostgreSQL (recommended) or SQLite

---

## 📋 Prerequisites

### Hostinger Requirements
- **VPS Plan**: Minimum VPS 1 (2 GB RAM, 1 CPU Core)
- **Recommended**: VPS 2 or higher (4 GB RAM, 2 CPU Cores)
- **OS**: Ubuntu 20.04 or 22.04 LTS
- **Root/SSH Access**: Required

### Domain Setup (Optional but Recommended)
- Domain name pointed to your VPS IP
- SSL certificate (can use Let's Encrypt - free)

---

## 🔧 Step 1: Initial Server Setup

### 1.1 Connect to Your Hostinger VPS

```bash
# SSH into your VPS
ssh root@your-vps-ip-address
```

### 1.2 Update System Packages

```bash
# Update package list
apt update && apt upgrade -y

# Install essential tools
apt install -y curl wget git build-essential
```

### 1.3 Create Application User

```bash
# Create a non-root user for the application
adduser cybersec
usermod -aG sudo cybersec

# Switch to the new user
su - cybersec
```

---

## 🐍 Step 2: Install Python and Node.js

### 2.1 Install Python 3.11

```bash
# Add deadsnakes PPA for latest Python
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update

# Install Python 3.11 and pip
sudo apt install -y python3.11 python3.11-venv python3.11-dev python3-pip

# Verify installation
python3.11 --version
```

### 2.2 Install Node.js 18

```bash
# Install Node.js using NodeSource
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version
```

---

## 🗄️ Step 3: Install and Configure PostgreSQL

### 3.1 Install PostgreSQL

```bash
# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Start and enable PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 3.2 Create Database and User

```bash
# Switch to postgres user
sudo -u postgres psql

# In PostgreSQL prompt, run:
CREATE DATABASE cybersecurity_db;
CREATE USER cybersec_user WITH PASSWORD 'your_secure_password_here';
GRANT ALL PRIVILEGES ON DATABASE cybersecurity_db TO cybersec_user;
\q
```

---

## 📦 Step 4: Deploy the Application

### 4.1 Clone Your Repository

```bash
# Navigate to home directory
cd ~

# Clone the repository (replace with your repo URL)
git clone https://github.com/yourusername/cybersecurity-project.git
cd cybersecurity-project

# Or upload your files via SFTP to ~/cybersecurity-project
```

### 4.2 Configure Backend

```bash
# Navigate to backend directory
cd ~/cybersecurity-project/backend

# Create virtual environment
python3.11 -m venv .venv

# Activate virtual environment
source .venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn psycopg2-binary
```

### 4.3 Create Production Environment File

```bash
# Create .env file
nano ~/cybersecurity-project/backend/.env
```

**Add the following configuration:**

```env
# Database Configuration
DATABASE_URL=postgresql://cybersec_user:your_secure_password_here@localhost:5432/cybersecurity_db

# Security Keys (IMPORTANT: Generate strong random keys!)
SECRET_KEY=your_secret_key_here_generate_random_string
JWT_SECRET_KEY=your_jwt_secret_here_generate_random_string

# Environment
ENVIRONMENT=production
LOG_LEVEL=INFO
FLASK_ENV=production

# Server Configuration
HOST=0.0.0.0
PORT=5000

# Frontend URL (update with your domain)
FRONTEND_URL=http://your-domain.com
CORS_ORIGINS=http://your-domain.com,https://your-domain.com

# Optional: Redis (if you install it)
# REDIS_URL=redis://localhost:6379
# SOCKETIO_MESSAGE_QUEUE_URL=redis://localhost:6379
```

**Generate secure keys:**
```bash
# Generate SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"

# Generate JWT_SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"
```

### 4.4 Initialize Database

```bash
# Make sure you're in backend directory with venv activated
cd ~/cybersecurity-project/backend
source .venv/bin/activate

# Initialize database
python3 -c "from app import app, db; app.app_context().push(); db.create_all(); print('Database initialized!')"
```

### 4.5 Configure Frontend

```bash
# Navigate to frontend directory
cd ~/cybersecurity-project/frontend

# Install dependencies
npm install

# Create production environment file
nano .env.production
```

**Add the following:**

```env
# Backend API URL (update with your domain)
NEXT_PUBLIC_API_URL=http://your-domain.com:5000
```

### 4.6 Build Frontend

```bash
# Build the production version
npm run build

# Test the build
npm start
# Press Ctrl+C to stop after verifying it works
```

---

## 🔄 Step 5: Setup Process Managers

### 5.1 Install PM2 for Node.js

```bash
# Install PM2 globally
sudo npm install -g pm2
```

### 5.2 Create Backend Service Script

```bash
# Create a start script for backend
nano ~/cybersecurity-project/start_backend.sh
```

**Add the following:**

```bash
#!/bin/bash
cd /home/cybersec/cybersecurity-project/backend
source .venv/bin/activate
gunicorn --worker-class eventlet -w 1 --bind 0.0.0.0:5000 app:app
```

**Make it executable:**

```bash
chmod +x ~/cybersecurity-project/start_backend.sh
```

### 5.3 Create PM2 Ecosystem File

```bash
nano ~/cybersecurity-project/ecosystem.config.js
```

**Add the following:**

```javascript
module.exports = {
  apps: [
    {
      name: 'cybersec-backend',
      script: '/home/cybersec/cybersecurity-project/start_backend.sh',
      cwd: '/home/cybersec/cybersecurity-project/backend',
      interpreter: '/bin/bash',
      env: {
        NODE_ENV: 'production'
      },
      error_file: '/home/cybersec/logs/backend-error.log',
      out_file: '/home/cybersec/logs/backend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s'
    },
    {
      name: 'cybersec-frontend',
      script: 'npm',
      args: 'start',
      cwd: '/home/cybersec/cybersecurity-project/frontend',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: '/home/cybersec/logs/frontend-error.log',
      out_file: '/home/cybersec/logs/frontend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s'
    }
  ]
};
```

### 5.4 Create Logs Directory

```bash
mkdir -p ~/logs
```

### 5.5 Start Applications with PM2

```bash
# Start both applications
cd ~/cybersecurity-project
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 to start on system boot
pm2 startup
# Follow the instructions shown by the command above
```

### 5.6 Verify Applications are Running

```bash
# Check PM2 status
pm2 status

# View logs
pm2 logs

# Check specific app logs
pm2 logs cybersec-backend
pm2 logs cybersec-frontend
```

---

## 🌐 Step 6: Configure Nginx Reverse Proxy

### 6.1 Install Nginx

```bash
sudo apt install -y nginx
```

### 6.2 Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/cybersecurity
```

**Add the following configuration:**

```nginx
# Backend API Server
upstream backend_server {
    server 127.0.0.1:5000;
}

# Frontend Server
upstream frontend_server {
    server 127.0.0.1:3000;
}

# Redirect HTTP to HTTPS (uncomment after SSL setup)
# server {
#     listen 80;
#     server_name your-domain.com www.your-domain.com;
#     return 301 https://$server_name$request_uri;
# }

server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # Increase upload size for file uploads
    client_max_body_size 100M;

    # Frontend
    location / {
        proxy_pass http://frontend_server;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API
    location /api {
        proxy_pass http://backend_server;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_read_timeout 86400;
    }

    # Socket.IO WebSocket endpoint
    location /socket.io {
        proxy_pass http://backend_server;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket timeout
        proxy_read_timeout 86400;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

### 6.3 Enable the Site

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/cybersecurity /etc/nginx/sites-enabled/

# Remove default site
sudo rm /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

---

## 🔒 Step 7: Setup SSL with Let's Encrypt (Recommended)

### 7.1 Install Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### 7.2 Obtain SSL Certificate

```bash
# Make sure your domain points to your VPS IP first!
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

Follow the prompts:
- Enter your email address
- Agree to terms of service
- Choose whether to redirect HTTP to HTTPS (recommended: Yes)

### 7.3 Auto-Renewal Setup

```bash
# Test auto-renewal
sudo certbot renew --dry-run

# Certbot automatically sets up a cron job for renewal
```

---

## 🔥 Step 8: Configure Firewall

### 8.1 Setup UFW Firewall

```bash
# Install UFW if not already installed
sudo apt install -y ufw

# Allow SSH (IMPORTANT: Do this first!)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

---

## 📊 Step 9: Monitoring and Maintenance

### 9.1 PM2 Commands

```bash
# View status
pm2 status

# View logs
pm2 logs

# Restart applications
pm2 restart all
pm2 restart cybersec-backend
pm2 restart cybersec-frontend

# Stop applications
pm2 stop all

# Monitor resources
pm2 monit
```

### 9.2 Check Application Health

```bash
# Test backend
curl http://localhost:5000/api/health

# Test frontend
curl http://localhost:3000

# Check Nginx status
sudo systemctl status nginx

# Check PostgreSQL status
sudo systemctl status postgresql
```

### 9.3 View Logs

```bash
# PM2 logs
pm2 logs

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Application logs
tail -f ~/logs/backend-out.log
tail -f ~/logs/frontend-out.log
```

---

## 🔄 Step 10: Deployment Updates

### 10.1 Update Application Code

```bash
# Navigate to project directory
cd ~/cybersecurity-project

# Pull latest changes
git pull origin main

# Update backend
cd backend
source .venv/bin/activate
pip install -r requirements.txt

# Update frontend
cd ../frontend
npm install
npm run build

# Restart applications
pm2 restart all
```

### 10.2 Database Migrations

```bash
# If you need to update database schema
cd ~/cybersecurity-project/backend
source .venv/bin/activate
python3 -c "from app import app, db; app.app_context().push(); db.create_all()"
```

---

## 🆘 Troubleshooting

### Backend Not Starting

```bash
# Check logs
pm2 logs cybersec-backend

# Check if port is in use
sudo lsof -i :5000

# Manually test backend
cd ~/cybersecurity-project/backend
source .venv/bin/activate
python3 app.py
```

### Frontend Not Starting

```bash
# Check logs
pm2 logs cybersec-frontend

# Check if port is in use
sudo lsof -i :3000

# Manually test frontend
cd ~/cybersecurity-project/frontend
npm start
```

### Database Connection Issues

```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Test database connection
psql -U cybersec_user -d cybersecurity_db -h localhost

# Check .env file has correct credentials
cat ~/cybersecurity-project/backend/.env
```

### Nginx Issues

```bash
# Test configuration
sudo nginx -t

# Check Nginx status
sudo systemctl status nginx

# Restart Nginx
sudo systemctl restart nginx

# Check error logs
sudo tail -f /var/log/nginx/error.log
```

### SSL Certificate Issues

```bash
# Renew certificate manually
sudo certbot renew

# Check certificate status
sudo certbot certificates
```

---

## 📈 Performance Optimization

### Enable Redis (Optional)

```bash
# Install Redis
sudo apt install -y redis-server

# Start and enable Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Update backend .env file
nano ~/cybersecurity-project/backend/.env
# Add:
# REDIS_URL=redis://localhost:6379
# SOCKETIO_MESSAGE_QUEUE_URL=redis://localhost:6379

# Restart backend
pm2 restart cybersec-backend
```

### Increase System Resources

If experiencing performance issues, consider:
- Upgrading to a higher VPS plan
- Optimizing database queries
- Implementing caching strategies
- Using a CDN for static assets

---

## 🔐 Security Best Practices

1. **Keep System Updated**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Use Strong Passwords**
   - Database passwords
   - SSH keys instead of passwords
   - JWT secret keys

3. **Regular Backups**
   ```bash
   # Backup database
   pg_dump -U cybersec_user cybersecurity_db > backup_$(date +%Y%m%d).sql
   
   # Backup application files
   tar -czf app_backup_$(date +%Y%m%d).tar.gz ~/cybersecurity-project
   ```

4. **Monitor Logs Regularly**
   - Check for suspicious activity
   - Monitor error rates
   - Track performance metrics

---

## ✅ Deployment Checklist

- [ ] VPS provisioned and accessible via SSH
- [ ] System packages updated
- [ ] Python 3.11 installed
- [ ] Node.js 18 installed
- [ ] PostgreSQL installed and configured
- [ ] Application code deployed
- [ ] Backend dependencies installed
- [ ] Frontend built for production
- [ ] Environment variables configured
- [ ] Database initialized
- [ ] PM2 configured and running
- [ ] Nginx installed and configured
- [ ] SSL certificate obtained (if using domain)
- [ ] Firewall configured
- [ ] Application accessible via domain/IP
- [ ] Monitoring setup
- [ ] Backup strategy in place

---

## 📞 Support

For issues specific to:
- **Hostinger VPS**: Contact Hostinger support
- **Application**: Check application logs and documentation
- **SSL**: Refer to Let's Encrypt documentation

---

## 🎉 Success!

Your Cybersecurity Project should now be live on Hostinger!

**Access your application:**
- **Frontend**: http://your-domain.com (or http://your-vps-ip)
- **Backend API**: http://your-domain.com/api (or http://your-vps-ip:5000)
- **API Docs**: http://your-domain.com/api/docs/swagger

---

*Last Updated: 2025-12-15*
