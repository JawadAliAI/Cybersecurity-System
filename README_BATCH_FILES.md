# 🚀 Quick Start - Double-Click to Run

This folder contains **easy-to-use batch files** to run the Cybersecurity Project locally on Windows **without Docker**.

## 📁 Available Files

### 🟢 START_LOCAL.bat
**Double-click this file to start the entire project!**

What it does:
- ✅ Checks if Python and Node.js are installed
- ✅ Creates necessary folders
- ✅ Sets up Python virtual environment
- ✅ Installs all dependencies automatically
- ✅ Creates configuration files
- ✅ Starts Backend (Flask) on port 5000
- ✅ Starts Frontend (Next.js) on port 3000
- ✅ Opens your browser automatically

**This is the main file you need!**

---

### 🔴 STOP_LOCAL.bat
**Double-click this file to stop all services**

What it does:
- ⛔ Stops all Node.js processes (Frontend)
- ⛔ Stops all Python processes (Backend)
- ⛔ Cleans up running services

**Use this when you're done working**

---

### 🔵 TEST_SETUP.bat
**Double-click this file to test your setup**

What it does:
- 🔍 Checks if Python is installed
- 🔍 Checks if Node.js is installed
- 🔍 Checks if npm is installed
- 🔍 Checks if pip is installed
- 🔍 Verifies project structure

**Run this first if you're not sure everything is installed**

---

## 🎯 How to Use (3 Simple Steps)

### Step 1: Install Prerequisites
Make sure you have:
- **Python 3.8+** - Download from https://www.python.org/downloads/
  - ⚠️ **IMPORTANT:** Check "Add Python to PATH" during installation
- **Node.js 16+** - Download from https://nodejs.org/
  - This includes npm automatically

### Step 2: Test Your Setup (Optional but Recommended)
1. Double-click **TEST_SETUP.bat**
2. Check if all tests pass
3. If any fail, install the missing software

### Step 3: Start the Project
1. Double-click **START_LOCAL.bat**
2. Wait 15-30 seconds for everything to start
3. Browser will open automatically to http://localhost:3000
4. **Done!** 🎉

---

## 📊 What You'll See

When you run **START_LOCAL.bat**, three windows will open:

1. **Main Window** (this one)
   - Shows setup progress
   - Displays access URLs
   - Can be closed after startup

2. **Backend Window** (Flask API)
   - Shows backend server logs
   - Running on http://localhost:5000
   - Keep this window open!

3. **Frontend Window** (Next.js)
   - Shows frontend build logs
   - Running on http://localhost:3000
   - Keep this window open!

---

## 🌐 Access Points

After starting, you can access:

| Service | URL | Description |
|---------|-----|-------------|
| **Dashboard** | http://localhost:3000 | Main web interface |
| **Backend API** | http://localhost:5000 | REST API |
| **API Docs** | http://localhost:5000/api/docs/swagger | Interactive API documentation |

---

## 🛑 How to Stop

**Option 1: Use the Stop Script (Recommended)**
- Double-click **STOP_LOCAL.bat**

**Option 2: Close Windows Manually**
- Close the "Backend - Flask API" window
- Close the "Frontend - Next.js" window

---

## 🔧 Configuration

### Backend Configuration
Edit `backend\.env` to customize:
- Database settings
- Security keys
- API keys
- External services

### First Run
On first run, a default `.env` file is created automatically with safe defaults for local development.

---

## 📁 Project Structure

```
Cybersecurity-Project-main/
│
├── START_LOCAL.bat          ← Start everything (MAIN FILE)
├── STOP_LOCAL.bat           ← Stop everything
├── TEST_SETUP.bat           ← Test prerequisites
├── LOCAL_SETUP_GUIDE.md     ← Detailed documentation
│
├── backend/                 ← Python/Flask API
│   ├── app.py              ← Main backend file
│   ├── requirements.txt    ← Python dependencies
│   ├── .env                ← Configuration (auto-created)
│   └── logs/               ← Backend logs
│
├── frontend/               ← Next.js Dashboard
│   ├── package.json        ← Node dependencies
│   └── pages/              ← Web pages
│
└── data/                   ← Application data
    ├── logs/
    ├── models/
    └── ...
```

---

## ❓ Troubleshooting

### "Python is not recognized"
**Solution:** 
1. Install Python from https://www.python.org/downloads/
2. During installation, **check "Add Python to PATH"**
3. Restart your computer
4. Try again

### "Node is not recognized"
**Solution:**
1. Install Node.js from https://nodejs.org/
2. Restart your computer
3. Try again

### Port Already in Use
**Solution:**
```batch
# Find what's using port 5000
netstat -ano | findstr :5000

# Find what's using port 3000
netstat -ano | findstr :3000

# Kill the process (replace <PID> with the number from above)
taskkill /PID <PID> /F
```

### Dependencies Won't Install
**Solution:**
1. Open Command Prompt as Administrator
2. Run:
   ```batch
   cd backend
   python -m venv .venv
   .venv\Scripts\activate
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

### Frontend Won't Start
**Solution:**
1. Open Command Prompt
2. Run:
   ```batch
   cd frontend
   npm cache clean --force
   npm install
   npm run dev
   ```

---

## 💡 Tips

- **First Run:** Takes 2-5 minutes to install dependencies
- **Subsequent Runs:** Starts in 10-15 seconds
- **Auto-Reload:** Both servers restart automatically when you edit code
- **Logs:** Check `backend\logs\` for detailed backend logs
- **Database:** Located at `backend\instance\cybersecurity.db`

---

## 🔄 Updating the Project

If you pull new changes from Git:

1. Stop the project (STOP_LOCAL.bat)
2. Delete `backend\.venv` folder (optional, only if dependencies changed)
3. Delete `frontend\node_modules` folder (optional, only if dependencies changed)
4. Run START_LOCAL.bat again

---

## 📚 More Information

- **Detailed Setup Guide:** See `LOCAL_SETUP_GUIDE.md`
- **Project Overview:** See `PROJECT_OVERVIEW.md`
- **Docker Setup:** See `DOCKER_COMMANDS.md`
- **Video Demo:** See `VIDEO_DOCKER_DEMO.md`

---

## 🎓 For Developers

### Manual Backend Start
```batch
cd backend
.venv\Scripts\activate
python app.py
```

### Manual Frontend Start
```batch
cd frontend
npm run dev
```

### Run Tests
```batch
python demo_module_tests.py <MODULE_ID>
```

---

## ✅ Checklist

Before running for the first time:

- [ ] Python 3.8+ installed with "Add to PATH" checked
- [ ] Node.js 16+ installed
- [ ] Downloaded/cloned the project
- [ ] Ran TEST_SETUP.bat to verify (optional)
- [ ] Ready to run START_LOCAL.bat!

---

## 🆘 Need Help?

1. **Run TEST_SETUP.bat** to diagnose issues
2. **Check the Troubleshooting section** above
3. **Read LOCAL_SETUP_GUIDE.md** for detailed instructions
4. **Check Backend/Frontend windows** for error messages

---

**Made with ❤️ for easy local development**

*Last updated: 2025-12-15*
