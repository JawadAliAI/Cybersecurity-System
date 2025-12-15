# 🚀 Running Cybersecurity Project Locally (Windows)

This guide will help you run the cybersecurity project on your local Windows machine **without Docker**.

## 📋 Prerequisites

Before running the project, make sure you have:

1. **Python 3.8+** installed
   - Download from: https://www.python.org/downloads/
   - ✅ Make sure to check "Add Python to PATH" during installation

2. **Node.js 16+** installed
   - Download from: https://nodejs.org/
   - ✅ This includes npm (Node Package Manager)

3. **Git** (optional, for cloning)
   - Download from: https://git-scm.com/

## 🎯 Quick Start (Double-Click Method)

### Method 1: Automatic Startup (Recommended)

1. **Navigate to the project folder**
   ```
   c:\Users\JAY\Downloads\Cybersecurity-Project-main\Cybersecurity-Project-main
   ```

2. **Double-click on `START_LOCAL.bat`**
   - This will automatically:
     - ✅ Check if Python and Node.js are installed
     - ✅ Create necessary directories
     - ✅ Set up Python virtual environment
     - ✅ Install all dependencies
     - ✅ Start Backend (Flask) on http://localhost:5000
     - ✅ Start Frontend (Next.js) on http://localhost:3000
     - ✅ Open your browser automatically

3. **Wait 15-30 seconds** for services to fully start

4. **Access the application**
   - Frontend Dashboard: http://localhost:3000
   - Backend API: http://localhost:5000
   - API Documentation: http://localhost:5000/api/docs/swagger

### To Stop the Application

**Double-click on `STOP_LOCAL.bat`**
- This will stop all running Backend and Frontend services

## 🛠️ Manual Setup (Alternative)

If you prefer to run services manually:

### Step 1: Setup Backend

```powershell
# Navigate to backend folder
cd backend

# Create virtual environment (first time only)
python -m venv .venv

# Activate virtual environment
.venv\Scripts\activate

# Install dependencies (first time only)
pip install -r requirements.txt

# Copy environment file (first time only)
copy .env.example .env

# Start backend server
python app.py
```

Backend will run on: http://localhost:5000

### Step 2: Setup Frontend (In a new terminal)

```powershell
# Navigate to frontend folder
cd frontend

# Install dependencies (first time only)
npm install

# Start development server
npm run dev
```

Frontend will run on: http://localhost:3000

## 📁 Project Structure

```
Cybersecurity-Project-main/
├── START_LOCAL.bat          ← Double-click to start everything
├── STOP_LOCAL.bat           ← Double-click to stop everything
├── backend/                 ← Flask API (Python)
│   ├── app.py              ← Main backend application
│   ├── requirements.txt    ← Python dependencies
│   └── .env                ← Configuration (auto-created)
├── frontend/               ← Next.js Dashboard (React)
│   ├── package.json        ← Node.js dependencies
│   └── pages/              ← Frontend pages
└── data/                   ← Application data (auto-created)
```

## 🔧 Configuration

### Backend Configuration (.env)

The `.env` file in the `backend/` folder contains configuration:

```env
# Database
DATABASE_URL=sqlite:///instance/cybersecurity.db

# Security
SECRET_KEY=your-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-here

# Redis (optional for full features)
REDIS_URL=redis://localhost:6379

# API Keys (optional)
GEMINI_API_KEY=your-gemini-key
```

### Frontend Configuration

The frontend automatically connects to `http://localhost:5000` for the backend API.

## 🎨 Features Available Locally

When running locally, you'll have access to:

✅ **Real-time Dashboard** - View threats and alerts
✅ **Authentication System** - Login/signup functionality
✅ **API Documentation** - Swagger UI at `/api/docs/swagger`
✅ **Threat Detection** - Basic ML-based detection
✅ **Data Visualization** - Charts and graphs

### Limited Features (Require Full Docker Setup)

Some advanced features require additional services:

⚠️ **ELK Stack** (Elasticsearch, Logstash, Kibana) - For advanced logging
⚠️ **Redis** - For WebSocket support and caching
⚠️ **Multiple Microservices** - For full honeypot and threat intelligence

To use these features, you'll need to run with Docker:
```powershell
docker-compose up -d
```

## 🐛 Troubleshooting

### Issue: "Python is not recognized"
**Solution:** Install Python and make sure "Add to PATH" is checked during installation

### Issue: "Node is not recognized"
**Solution:** Install Node.js from https://nodejs.org/

### Issue: Port 3000 or 5000 already in use
**Solution:** 
```powershell
# Find and kill process on port 5000
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Find and kill process on port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Issue: Dependencies installation fails
**Solution:**
```powershell
# For Python dependencies
cd backend
.venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt

# For Node.js dependencies
cd frontend
npm cache clean --force
npm install
```

### Issue: Frontend can't connect to Backend
**Solution:** Make sure Backend is running on http://localhost:5000 before starting Frontend

## 📊 Testing the Application

### Quick Test Script

You can test individual modules using:

```powershell
python demo_module_tests.py <MODULE_ID>
```

Examples:
- `python demo_module_tests.py 1` - Test WebSockets
- `python demo_module_tests.py 10` - Test Authentication
- `python demo_module_tests.py 12` - Test Rate Limiting

## 🔐 Default Credentials

For testing purposes, you can use:

- **Username:** admin
- **Password:** admin123

(These can be changed in the backend configuration)

## 📝 Logs and Data

- **Backend Logs:** `backend/logs/`
- **Application Data:** `data/`
- **Database:** `backend/instance/cybersecurity.db`

## 🚀 Next Steps

1. **Explore the Dashboard** - Visit http://localhost:3000
2. **Check API Docs** - Visit http://localhost:5000/api/docs/swagger
3. **Review Logs** - Check `backend/logs/` for application logs
4. **Customize** - Edit `.env` file for your configuration

## 📚 Additional Resources

- **Full Documentation:** See `PROJECT_OVERVIEW.md`
- **Docker Setup:** See `DOCKER_COMMANDS.md`
- **Video Demo Guide:** See `VIDEO_DOCKER_DEMO.md`
- **Deployment Guide:** See `DEPLOYMENT.md`

## 💡 Tips

- **First Run:** May take 2-3 minutes to install all dependencies
- **Subsequent Runs:** Will start in 10-15 seconds
- **Development Mode:** Both servers auto-reload on code changes
- **Browser:** Works best with Chrome, Firefox, or Edge

---

**Need Help?** Check the troubleshooting section or review the full documentation files.

**Want Full Features?** Use Docker Compose for the complete system with all microservices.
