# 🚀 Deployment Guide - Start Here

Welcome! This guide will help you deploy the Cybersecurity Project to Hostinger VPS.

---

## 📚 Documentation Overview

We've created comprehensive documentation to make deployment easy:

### 🎯 Choose Your Path

#### **New to Deployment?** → Start Here!
1. **Read This File** (you are here)
2. **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Ensure you have everything ready
3. **[HOSTINGER_DEPLOYMENT.md](HOSTINGER_DEPLOYMENT.md)** - Follow step-by-step instructions

#### **Experienced User?** → Quick Start
1. **[HOSTINGER_QUICK_START.md](HOSTINGER_QUICK_START.md)** - Quick reference guide
2. **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)** - Overview and commands

---

## 🎯 What You'll Deploy

### Application Stack
- **Backend**: Flask API (Python 3.11) on port 5000
- **Frontend**: Next.js Dashboard (React 18) on port 3000
- **Database**: PostgreSQL (recommended) or SQLite
- **Web Server**: Nginx (reverse proxy with SSL)
- **Process Manager**: PM2 (keeps apps running)

### Features Included
✅ Real-time Dashboard  
✅ User Authentication & RBAC  
✅ Threat Detection  
✅ Data Visualization  
✅ API Documentation (Swagger)  
✅ WebSocket Support  
✅ Rate Limiting  
✅ Audit Logging  

---

## 📋 Prerequisites

### What You Need

1. **Hostinger VPS**
   - Minimum: VPS 1 (2GB RAM, 1 CPU)
   - Recommended: VPS 2 (4GB RAM, 2 CPUs)
   - OS: Ubuntu 20.04 or 22.04 LTS

2. **Domain Name** (Optional but Recommended)
   - For SSL/HTTPS support
   - Professional appearance

3. **Basic Knowledge**
   - SSH access
   - Linux command line basics
   - Text editor (nano/vim)

---

## ⚡ Quick Start (5 Steps)

### Step 1: Prepare Locally

```bash
# Generate secret keys
python3 -c "import secrets; print('SECRET_KEY:', secrets.token_hex(32))"
python3 -c "import secrets; print('JWT_SECRET_KEY:', secrets.token_hex(32))"

# Save these keys - you'll need them!
```

### Step 2: Upload to VPS

```bash
# Option A: Using Git (Recommended)
ssh cybersec@your-vps-ip
git clone https://github.com/yourusername/cybersecurity-project.git
cd cybersecurity-project

# Option B: Using SCP
scp -r * cybersec@your-vps-ip:~/cybersecurity-project/
```

### Step 3: Configure Environment

```bash
# Backend configuration
cd ~/cybersecurity-project/backend
cp .env.production .env
nano .env  # Update with your settings

# Frontend configuration
cd ~/cybersecurity-project/frontend
nano .env.production  # Update API URL
```

### Step 4: Deploy

```bash
# Make scripts executable
cd ~/cybersecurity-project
chmod +x deploy.sh update.sh backup.sh start_backend.sh

# Run deployment
./deploy.sh
```

### Step 5: Configure Nginx

```bash
# Copy and configure Nginx
sudo cp nginx.conf /etc/nginx/sites-available/cybersecurity
sudo nano /etc/nginx/sites-available/cybersecurity  # Update domain

# Enable and restart
sudo ln -s /etc/nginx/sites-available/cybersecurity /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

**Done!** Your application is now live! 🎉

---

## 📁 Deployment Files Explained

### Documentation
- **DEPLOYMENT_README.md** (this file) - Start here
- **HOSTINGER_DEPLOYMENT.md** - Complete step-by-step guide
- **HOSTINGER_QUICK_START.md** - Quick reference
- **DEPLOYMENT_CHECKLIST.md** - Pre-deployment checklist
- **DEPLOYMENT_SUMMARY.md** - Overview and summary

### Configuration Files
- **ecosystem.config.js** - PM2 process manager config
- **nginx.conf** - Nginx reverse proxy config
- **backend/.env.production** - Backend environment template
- **frontend/.env.production** - Frontend environment template

### Automation Scripts
- **deploy.sh** - Initial deployment automation
- **update.sh** - Update existing deployment
- **backup.sh** - Backup database and files
- **start_backend.sh** - Backend startup script

---

## 🔐 Security Configuration

### Required: Generate Secret Keys

**CRITICAL**: Never use default keys in production!

```bash
# Generate SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"

# Generate JWT_SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"

# Generate Database Password
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### Required: Configure Environment

**Backend** (`backend/.env`):
```env
DATABASE_URL=postgresql://cybersec_user:YOUR_PASSWORD@localhost:5432/cybersecurity_db
SECRET_KEY=your_generated_secret_key
JWT_SECRET_KEY=your_generated_jwt_secret
FRONTEND_URL=https://your-domain.com
```

**Frontend** (`frontend/.env.production`):
```env
NEXT_PUBLIC_API_URL=https://your-domain.com
```

---

## 🌐 After Deployment

### Access Your Application

- **Frontend**: http://your-domain.com
- **Backend API**: http://your-domain.com/api
- **API Docs**: http://your-domain.com/api/docs/swagger

### Verify Everything Works

```bash
# Check PM2 status
pm2 status

# View logs
pm2 logs

# Test backend
curl http://localhost:5000/api/health

# Test frontend
curl http://localhost:3000
```

---

## 🔄 Common Operations

### Daily Management

```bash
# Check status
pm2 status

# View logs
pm2 logs

# Restart apps
pm2 restart all

# Monitor resources
pm2 monit
```

### Updates

```bash
# Pull latest code and redeploy
cd ~/cybersecurity-project
git pull origin main
./update.sh
```

### Backups

```bash
# Create backup
./backup.sh

# Backups stored in ~/backups/
ls -lh ~/backups/
```

---

## 🆘 Troubleshooting

### Backend Issues

```bash
# Check logs
pm2 logs cybersec-backend

# Manual test
cd ~/cybersecurity-project/backend
source .venv/bin/activate
python3 app.py
```

### Frontend Issues

```bash
# Check logs
pm2 logs cybersec-frontend

# Manual test
cd ~/cybersecurity-project/frontend
npm start
```

### Database Issues

```bash
# Check PostgreSQL
sudo systemctl status postgresql

# Test connection
psql -U cybersec_user -d cybersecurity_db -h localhost
```

### Nginx Issues

```bash
# Test configuration
sudo nginx -t

# Check logs
sudo tail -f /var/log/nginx/error.log

# Restart
sudo systemctl restart nginx
```

---

## 📊 Deployment Timeline

| Phase | Duration | Description |
|-------|----------|-------------|
| **Preparation** | 15 min | Generate keys, configure files |
| **Server Setup** | 20 min | Install software, create users |
| **Database Setup** | 5 min | Create database and user |
| **App Deployment** | 15 min | Deploy and configure apps |
| **Nginx Setup** | 10 min | Configure reverse proxy |
| **SSL Setup** | 5 min | Install certificate (optional) |
| **Testing** | 10 min | Verify everything works |
| **Total** | **~80 min** | First-time deployment |

Subsequent deployments: **~5 minutes** using `update.sh`

---

## ✅ Deployment Checklist

Before you start:

- [ ] VPS provisioned and accessible
- [ ] Domain configured (if using)
- [ ] Secret keys generated
- [ ] Environment files prepared
- [ ] Code in Git repository
- [ ] Read deployment documentation

---

## 📞 Getting Help

### Documentation
1. **HOSTINGER_DEPLOYMENT.md** - Detailed instructions
2. **HOSTINGER_QUICK_START.md** - Quick reference
3. **DEPLOYMENT_CHECKLIST.md** - Requirements checklist

### Support Resources
- **Hostinger Support**: https://www.hostinger.com/support
- **Let's Encrypt**: https://letsencrypt.org/docs/
- **PM2 Documentation**: https://pm2.keymetrics.io/docs/
- **Nginx Documentation**: https://nginx.org/en/docs/

### Common Issues
Check the troubleshooting section in **HOSTINGER_DEPLOYMENT.md**

---

## 🎯 Next Steps

### For First-Time Deployment

1. **Review Checklist**
   ```bash
   # Open and review
   cat DEPLOYMENT_CHECKLIST.md
   ```

2. **Follow Detailed Guide**
   ```bash
   # Open and follow
   cat HOSTINGER_DEPLOYMENT.md
   ```

3. **Deploy**
   ```bash
   # Run deployment script
   ./deploy.sh
   ```

### For Experienced Users

1. **Quick Start**
   ```bash
   # Open quick reference
   cat HOSTINGER_QUICK_START.md
   ```

2. **Deploy**
   ```bash
   # Configure and deploy
   ./deploy.sh
   ```

---

## 🔒 Security Best Practices

✅ **Always**:
- Use strong, unique secret keys
- Enable SSL/HTTPS
- Configure firewall (UFW)
- Regular system updates
- Regular backups
- Monitor logs

❌ **Never**:
- Commit `.env` files to Git
- Use default passwords
- Disable firewall
- Skip SSL in production
- Ignore security updates

---

## 🎉 Ready to Deploy?

Choose your path:

### 🆕 First Time Deploying?
→ **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Start here  
→ **[HOSTINGER_DEPLOYMENT.md](HOSTINGER_DEPLOYMENT.md)** - Follow this

### ⚡ Experienced User?
→ **[HOSTINGER_QUICK_START.md](HOSTINGER_QUICK_START.md)** - Quick deploy

### 📊 Want Overview?
→ **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)** - Read this

---

## 📝 Notes

- All scripts are tested on Ubuntu 20.04/22.04 LTS
- Deployment time: ~1 hour first time, ~5 minutes for updates
- Minimum VPS: 2GB RAM (4GB recommended)
- SSL certificate is free with Let's Encrypt
- PM2 keeps your apps running 24/7

---

## 🚀 Let's Deploy!

Everything is ready. Follow the documentation and you'll have your application running in about an hour.

**Good luck!** 🎊

---

*Last Updated: 2025-12-15*  
*Deployment Package Version: 1.0.0*
