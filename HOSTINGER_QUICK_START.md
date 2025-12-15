# 🚀 Quick Deployment Guide for Hostinger

This is a condensed version of the full deployment guide. For detailed instructions, see `HOSTINGER_DEPLOYMENT.md`.

---

## ⚡ Prerequisites

- Hostinger VPS (minimum VPS 1 - 2GB RAM)
- Ubuntu 20.04 or 22.04 LTS
- Root/SSH access
- Domain name (optional but recommended)

---

## 📝 Quick Steps

### 1. Connect to VPS

```bash
ssh root@your-vps-ip
```

### 2. Run Initial Setup

```bash
# Update system
apt update && apt upgrade -y

# Install Python 3.11
add-apt-repository -y ppa:deadsnakes/ppa
apt update
apt install -y python3.11 python3.11-venv python3.11-dev

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install PostgreSQL
apt install -y postgresql postgresql-contrib

# Install Nginx
apt install -y nginx

# Install PM2
npm install -g pm2
```

### 3. Setup Database

```bash
sudo -u postgres psql
```

In PostgreSQL:
```sql
CREATE DATABASE cybersecurity_db;
CREATE USER cybersec_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE cybersecurity_db TO cybersec_user;
\q
```

### 4. Deploy Application

```bash
# Create user
adduser cybersec
usermod -aG sudo cybersec
su - cybersec

# Clone repository
cd ~
git clone https://github.com/yourusername/cybersecurity-project.git
cd cybersecurity-project

# Make scripts executable
chmod +x deploy.sh update.sh backup.sh start_backend.sh

# Configure environment files
cp backend/.env.production backend/.env
nano backend/.env  # Update with your settings

cp frontend/.env.production frontend/.env.production
nano frontend/.env.production  # Update API URL

# Run deployment script
./deploy.sh
```

### 5. Configure Nginx

```bash
# Copy nginx config
sudo cp nginx.conf /etc/nginx/sites-available/cybersecurity

# Update domain in config
sudo nano /etc/nginx/sites-available/cybersecurity
# Change 'your-domain.com' to your actual domain

# Enable site
sudo ln -s /etc/nginx/sites-available/cybersecurity /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test and restart
sudo nginx -t
sudo systemctl restart nginx
```

### 6. Setup SSL (Optional but Recommended)

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

### 7. Configure Firewall

```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

## ✅ Verify Deployment

```bash
# Check PM2 status
pm2 status

# Check logs
pm2 logs

# Test backend
curl http://localhost:5000/api/health

# Test frontend
curl http://localhost:3000
```

---

## 🔄 Common Commands

```bash
# View status
pm2 status

# View logs
pm2 logs

# Restart apps
pm2 restart all

# Update deployment
./update.sh

# Create backup
./backup.sh

# Monitor resources
pm2 monit
```

---

## 🌐 Access Your Application

- **Frontend**: http://your-domain.com (or http://your-vps-ip)
- **Backend API**: http://your-domain.com/api
- **API Docs**: http://your-domain.com/api/docs/swagger

---

## 🆘 Troubleshooting

### Backend not starting
```bash
pm2 logs cybersec-backend
cd ~/cybersecurity-project/backend
source .venv/bin/activate
python3 app.py
```

### Frontend not starting
```bash
pm2 logs cybersec-frontend
cd ~/cybersecurity-project/frontend
npm start
```

### Database connection issues
```bash
sudo systemctl status postgresql
psql -U cybersec_user -d cybersecurity_db -h localhost
```

### Nginx issues
```bash
sudo nginx -t
sudo systemctl status nginx
sudo tail -f /var/log/nginx/error.log
```

---

## 📚 Full Documentation

For detailed instructions, troubleshooting, and advanced configuration, see:
- `HOSTINGER_DEPLOYMENT.md` - Complete deployment guide
- `README.md` - Project overview
- `START_HERE.md` - Local development guide

---

## 🔐 Important Security Notes

1. **Change default passwords** in `.env` files
2. **Generate strong secret keys** using:
   ```bash
   python3 -c "import secrets; print(secrets.token_hex(32))"
   ```
3. **Setup SSL certificate** for production
4. **Enable firewall** (UFW)
5. **Regular backups** using `./backup.sh`
6. **Keep system updated**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

---

## 📞 Need Help?

- Check `HOSTINGER_DEPLOYMENT.md` for detailed instructions
- Review PM2 logs: `pm2 logs`
- Check Nginx logs: `sudo tail -f /var/log/nginx/error.log`
- Verify environment files are configured correctly

---

*Last Updated: 2025-12-15*
