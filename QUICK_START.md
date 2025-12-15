# 🎯 QUICK START - READ THIS FIRST!

## ⚡ Super Quick Start (TL;DR)

1. **Double-click `START_LOCAL.bat`**
2. **Wait 30 seconds**
3. **Browser opens automatically**
4. **Done!** 🎉

---

## 📋 Prerequisites Checklist

Before you start, make sure you have:

✅ **Python 3.8+** installed
   - Download: https://www.python.org/downloads/
   - ⚠️ **CRITICAL:** Check "Add Python to PATH" during installation!

✅ **Node.js 16+** installed
   - Download: https://nodejs.org/
   - npm comes with Node.js automatically

---

## 🚀 Step-by-Step First Time Setup

### Step 1: Verify Prerequisites
```
Double-click: TEST_SETUP.bat
```
This will check if Python and Node.js are installed correctly.

### Step 2: Start the Project
```
Double-click: START_LOCAL.bat
```
This will:
- Create virtual environment
- Install all dependencies (takes 2-5 minutes first time)
- Start Backend on port 5000
- Start Frontend on port 3000
- Open browser automatically

### Step 3: Access the Application
Your browser will open automatically to:
```
http://localhost:3000
```

If it doesn't open, manually visit:
- **Frontend Dashboard:** http://localhost:3000
- **Backend API:** http://localhost:5000
- **API Documentation:** http://localhost:5000/api/docs/swagger

---

## 🛑 How to Stop

When you're done:
```
Double-click: STOP_LOCAL.bat
```

Or manually close the two terminal windows:
- Backend - Flask API (Port 5000)
- Frontend - Next.js (Port 3000)

---

## 🔄 Running Again (After First Time)

After the first setup, starting is much faster:

1. **Double-click `START_LOCAL.bat`**
2. **Wait 10-15 seconds**
3. **Browser opens automatically**

Dependencies are already installed, so it's quick!

---

## 📊 What You'll See

### Three Windows Will Open:

1. **Setup Window** (Green text)
   - Shows installation progress
   - Can be closed after "System Started" message

2. **Backend Window** (Black background)
   - Title: "Backend - Flask API (Port 5000)"
   - Shows server logs
   - **Keep this open while using the app**

3. **Frontend Window** (Black background)
   - Title: "Frontend - Next.js (Port 3000)"
   - Shows build logs
   - **Keep this open while using the app**

---

## ❌ Common Issues & Quick Fixes

### Issue: "Python is not recognized"
**Fix:**
1. Install Python from https://www.python.org/downloads/
2. **IMPORTANT:** Check "Add Python to PATH" during installation
3. Restart computer
4. Try again

### Issue: "Node is not recognized"
**Fix:**
1. Install Node.js from https://nodejs.org/
2. Restart computer
3. Try again

### Issue: "Port already in use"
**Fix:**
1. Run `STOP_LOCAL.bat`
2. Or restart your computer
3. Try again

### Issue: "Dependencies failed to install"
**Fix:**
1. Make sure you have internet connection
2. Run as Administrator (right-click → Run as administrator)
3. Try again

---

## 📁 Important Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `START_LOCAL.bat` | **Start everything** | Every time you want to run the project |
| `STOP_LOCAL.bat` | **Stop everything** | When you're done working |
| `TEST_SETUP.bat` | **Test prerequisites** | First time, or if having issues |
| `README_BATCH_FILES.md` | **Detailed guide** | For more information |
| `LOCAL_SETUP_GUIDE.md` | **Full documentation** | For advanced setup |

---

## 💾 Where is Data Stored?

- **Database:** `backend\instance\cybersecurity.db`
- **Logs:** `backend\logs\`
- **Application Data:** `data\`
- **Configuration:** `backend\.env`

---

## 🔧 Configuration (Optional)

After first run, you can edit `backend\.env` to customize:
- Database settings
- Security keys
- API endpoints
- Feature flags

Default values work fine for local development!

---

## 📱 Accessing from Other Devices

By default, the app only runs on your computer (localhost).

To access from phone/tablet on same network:
1. Find your computer's IP address: `ipconfig`
2. Edit `backend\.env`: Add `HOST=0.0.0.0`
3. Restart the app
4. Access from other device: `http://YOUR_IP:3000`

---

## 🎓 For Developers

### View Logs
- Backend logs: `backend\logs\backend.log`
- Frontend logs: Check the "Frontend - Next.js" window

### Database
- SQLite database: `backend\instance\cybersecurity.db`
- View with: DB Browser for SQLite

### API Testing
- Swagger UI: http://localhost:5000/api/docs/swagger
- Postman collection: Import from API docs

---

## 🆘 Still Having Issues?

1. **Run `TEST_SETUP.bat`** - Diagnose what's missing
2. **Check the terminal windows** - Look for error messages
3. **Read `README_BATCH_FILES.md`** - Detailed troubleshooting
4. **Read `LOCAL_SETUP_GUIDE.md`** - Full documentation

---

## ✅ Success Checklist

You know it's working when:
- ✅ Two terminal windows are open (Backend & Frontend)
- ✅ Browser opened to http://localhost:3000
- ✅ You see the dashboard interface
- ✅ No error messages in terminal windows

---

## 🎯 Next Steps

After starting successfully:

1. **Explore the Dashboard** - Click around the interface
2. **Check API Docs** - Visit http://localhost:5000/api/docs/swagger
3. **View Logs** - Check `backend\logs\` for activity
4. **Customize** - Edit `backend\.env` if needed

---

## 📚 Additional Resources

- **Project Overview:** `PROJECT_OVERVIEW.md`
- **Docker Setup:** `DOCKER_COMMANDS.md` (for advanced users)
- **Video Demo Guide:** `VIDEO_DOCKER_DEMO.md`
- **Testing Guide:** `MODULE_9_TESTING_GUIDE.md`

---

## 💡 Pro Tips

- **First run takes longer** - Dependencies need to download
- **Subsequent runs are fast** - Everything is already installed
- **Auto-reload enabled** - Edit code and see changes instantly
- **Safe to close setup window** - After "System Started" message
- **Keep Backend/Frontend windows open** - They're the actual servers

---

**🎉 You're all set! Double-click START_LOCAL.bat to begin!**

---

*Need help? Read README_BATCH_FILES.md for detailed instructions*

*Last updated: 2025-12-15*
