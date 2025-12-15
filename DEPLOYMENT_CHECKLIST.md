# 🔧 Pre-Deployment Checklist

Use this checklist before deploying to Hostinger to ensure everything is ready.

---

## 📋 Before You Start

### ✅ Hostinger Account Setup
- [ ] VPS plan purchased (minimum VPS 1 - 2GB RAM)
- [ ] VPS is provisioned and running
- [ ] You have received VPS IP address
- [ ] You have root SSH credentials
- [ ] You can connect via SSH: `ssh root@your-vps-ip`

### ✅ Domain Configuration (Optional)
- [ ] Domain name purchased
- [ ] Domain DNS A record points to VPS IP
- [ ] DNS propagation completed (check with `nslookup your-domain.com`)
- [ ] www subdomain configured (CNAME or A record)

### ✅ Local Preparation
- [ ] Code is committed to Git repository
- [ ] Repository is accessible (GitHub, GitLab, etc.)
- [ ] All sensitive data removed from code
- [ ] `.gitignore` includes `.env`, `.venv`, `node_modules`

---

## 🔐 Security Preparation

### ✅ Generate Secret Keys
Generate these before deployment:

```bash
# SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"

# JWT_SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"

# Database password (strong random password)
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

Save these securely - you'll need them for `.env` configuration!

### ✅ Environment Files Ready
- [ ] `backend/.env.production` template reviewed
- [ ] `frontend/.env.production` template reviewed
- [ ] Secret keys generated and saved securely
- [ ] Database password generated and saved
- [ ] Domain/IP address ready for configuration

---

## 📦 Application Preparation

### ✅ Backend Checklist
- [ ] `requirements.txt` is up to date
- [ ] All Python dependencies are listed
- [ ] Database models are finalized
- [ ] API endpoints are tested locally
- [ ] No hardcoded credentials in code
- [ ] Logging is configured properly

### ✅ Frontend Checklist
- [ ] `package.json` is up to date
- [ ] All npm dependencies are listed
- [ ] API URL is configurable via environment variable
- [ ] Build process works locally: `npm run build`
- [ ] No hardcoded API URLs in code
- [ ] Production build tested locally

---

## 🗄️ Database Preparation

### ✅ Database Planning
- [ ] Decided on PostgreSQL (recommended) or SQLite
- [ ] Database name chosen: `cybersecurity_db`
- [ ] Database user chosen: `cybersec_user`
- [ ] Strong database password generated
- [ ] Database connection string prepared

Example connection string:
```
postgresql://cybersec_user:YOUR_PASSWORD@localhost:5432/cybersecurity_db
```

---

## 📁 Files to Upload/Configure

### ✅ Required Files
- [ ] All application code
- [ ] `ecosystem.config.js` (PM2 configuration)
- [ ] `start_backend.sh` (backend startup script)
- [ ] `nginx.conf` (Nginx configuration)
- [ ] `deploy.sh` (deployment automation)
- [ ] `update.sh` (update automation)
- [ ] `backup.sh` (backup automation)

### ✅ Configuration Files to Create on Server
- [ ] `backend/.env` (from `.env.production` template)
- [ ] `frontend/.env.production` (with your domain/IP)

---

## 🔧 Server Requirements Check

### ✅ Software to Install
- [ ] Python 3.11
- [ ] Node.js 18
- [ ] PostgreSQL (if using)
- [ ] Nginx
- [ ] PM2
- [ ] Git
- [ ] Certbot (for SSL)

### ✅ System Configuration
- [ ] Firewall rules planned (ports 22, 80, 443)
- [ ] SSL certificate plan (Let's Encrypt recommended)
- [ ] Backup strategy planned
- [ ] Monitoring plan considered

---

## 📝 Information to Gather

### ✅ Collect This Information
```
VPS IP Address: ___________________________
Domain Name: _______________________________
Database Name: cybersecurity_db
Database User: cybersec_user
Database Password: _________________________
SECRET_KEY: ________________________________
JWT_SECRET_KEY: ____________________________
```

---

## 🚀 Deployment Order

Follow this order for smooth deployment:

1. **Server Setup**
   - [ ] Connect to VPS
   - [ ] Update system packages
   - [ ] Create application user

2. **Install Software**
   - [ ] Python 3.11
   - [ ] Node.js 18
   - [ ] PostgreSQL
   - [ ] Nginx
   - [ ] PM2

3. **Database Setup**
   - [ ] Create database
   - [ ] Create database user
   - [ ] Grant permissions

4. **Application Deployment**
   - [ ] Clone repository
   - [ ] Configure environment files
   - [ ] Run deployment script
   - [ ] Verify applications are running

5. **Web Server Configuration**
   - [ ] Configure Nginx
   - [ ] Test Nginx configuration
   - [ ] Restart Nginx

6. **SSL Setup** (if using domain)
   - [ ] Install Certbot
   - [ ] Obtain SSL certificate
   - [ ] Verify auto-renewal

7. **Security Configuration**
   - [ ] Configure firewall
   - [ ] Test firewall rules
   - [ ] Verify security headers

8. **Final Verification**
   - [ ] Test frontend access
   - [ ] Test backend API
   - [ ] Test WebSocket connections
   - [ ] Check logs for errors
   - [ ] Create initial backup

---

## 🧪 Testing Plan

### ✅ After Deployment, Test:
- [ ] Frontend loads correctly
- [ ] Backend API responds
- [ ] User registration works
- [ ] User login works
- [ ] Dashboard displays data
- [ ] WebSocket connections work
- [ ] API documentation accessible
- [ ] SSL certificate valid (if configured)
- [ ] All pages load without errors
- [ ] Mobile responsiveness

---

## 📊 Monitoring Setup

### ✅ Post-Deployment Monitoring
- [ ] PM2 monitoring: `pm2 monit`
- [ ] Log rotation configured
- [ ] Backup cron job scheduled
- [ ] Health check endpoint tested
- [ ] Error tracking considered (Sentry, etc.)

---

## 🔄 Backup Strategy

### ✅ Backup Plan
- [ ] Backup script tested: `./backup.sh`
- [ ] Backup location decided: `~/backups`
- [ ] Backup retention policy: 30 days
- [ ] Automated backup schedule planned
- [ ] Backup restoration tested

---

## 📞 Emergency Contacts

### ✅ Keep Handy
- [ ] Hostinger support contact
- [ ] Domain registrar support
- [ ] Team member contacts
- [ ] Backup access credentials (secure location)

---

## ✅ Final Pre-Deployment Check

Before running `./deploy.sh`:

- [ ] All items in this checklist completed
- [ ] Environment files configured with correct values
- [ ] Secret keys generated and saved
- [ ] Database credentials ready
- [ ] Domain/IP address confirmed
- [ ] Backup of local development environment
- [ ] Team notified of deployment
- [ ] Maintenance window scheduled (if needed)

---

## 🎉 Ready to Deploy!

If all items are checked, you're ready to deploy!

Follow the deployment guide:
1. **Quick Start**: `HOSTINGER_QUICK_START.md`
2. **Detailed Guide**: `HOSTINGER_DEPLOYMENT.md`

---

*Last Updated: 2025-12-15*
