@echo off
title Cybersecurity Project - Local Runner
color 0A

echo ========================================
echo   CYBERSECURITY PROJECT - LOCAL RUNNER
echo ========================================
echo.
echo This script will start the Cybersecurity Project locally
echo without Docker. It will run both Backend and Frontend.
echo.

REM Check if Python is installed
echo [CHECK] Verifying Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Python is not installed or not in PATH!
    echo.
    echo Please install Python 3.8 or higher from:
    echo https://www.python.org/downloads/
    echo.
    echo IMPORTANT: During installation, check "Add Python to PATH"
    echo.
    pause
    exit /b 1
)
python --version
echo [OK] Python is installed
echo.

REM Check if Node.js is installed
echo [CHECK] Verifying Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Node.js is not installed or not in PATH!
    echo.
    echo Please install Node.js 16 or higher from:
    echo https://nodejs.org/
    echo.
    pause
    exit /b 1
)
node --version
echo [OK] Node.js is installed
echo.

REM Create necessary directories
echo [SETUP] Creating necessary directories...
if not exist "data" mkdir data
if not exist "data\logs" mkdir data\logs
if not exist "data\models" mkdir data\models
if not exist "data\training" mkdir data\training
if not exist "data\decoys" mkdir data\decoys
if not exist "data\stix_data" mkdir data\stix_data
if not exist "data\results" mkdir data\results
if not exist "backend\logs" mkdir backend\logs
if not exist "backend\instance" mkdir backend\instance
echo [OK] Directories created
echo.

REM Setup Backend
echo ========================================
echo   SETTING UP BACKEND (Python/Flask)
echo ========================================
cd backend

REM Check if virtual environment exists
if not exist ".venv" (
    echo [SETUP] Creating Python virtual environment...
    echo This may take a minute...
    python -m venv .venv
    if %errorlevel% neq 0 (
        color 0C
        echo [ERROR] Failed to create virtual environment
        cd ..
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created
)

REM Activate virtual environment and install dependencies
echo [SETUP] Activating virtual environment...
call .venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Failed to activate virtual environment
    cd ..
    pause
    exit /b 1
)

echo [SETUP] Installing Python dependencies...
echo This may take a few minutes on first run...
pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Failed to install Python dependencies
    echo.
    echo Try running manually:
    echo   cd backend
    echo   .venv\Scripts\activate
    echo   pip install -r requirements.txt
    echo.
    cd ..
    pause
    exit /b 1
)
echo [OK] Backend dependencies installed
echo.

REM Create .env file if it doesn't exist
if not exist ".env" (
    echo [SETUP] Creating .env configuration file...
    if exist ".env.example" (
        copy .env.example .env >nul
        echo [OK] Copied from .env.example
    ) else (
        REM Create a basic .env file with defaults
        (
            echo # Cybersecurity Project - Local Configuration
            echo.
            echo # Database
            echo DATABASE_URL=sqlite:///instance/cybersecurity.db
            echo.
            echo # Security Keys
            echo SECRET_KEY=dev-secret-key-change-in-production
            echo JWT_SECRET_KEY=dev-jwt-secret-change-in-production
            echo.
            echo # Environment
            echo ENVIRONMENT=development
            echo LOG_LEVEL=INFO
            echo LOG_FILE=logs/backend.log
            echo.
            echo # Redis ^(Optional - comment out if not using^)
            echo # REDIS_URL=redis://localhost:6379
            echo # SOCKETIO_MESSAGE_QUEUE_URL=redis://localhost:6379
            echo.
            echo # External Services ^(Optional^)
            echo # DECOY_GENERATOR_URL=http://localhost:5002
            echo # THREAT_ATTRIBUTION_URL=http://localhost:5004
        ) > .env
        echo [OK] Created default .env file
    )
    echo.
    echo [INFO] You can edit backend\.env to customize configuration
    echo.
)

REM Initialize database
echo [SETUP] Initializing database...
python -c "from app import app, db; app.app_context().push(); db.create_all(); print('[OK] Database initialized')" 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Database initialization may happen on first request
)
echo.

REM Start Backend in a new window
echo [START] Starting Backend Server on http://localhost:5000
start "Backend - Flask API (Port 5000)" cmd /k "cd /d %CD% && .venv\Scripts\activate.bat && echo Starting Flask Backend... && python app.py"

cd ..
echo.

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Setup Frontend
echo ========================================
echo   SETTING UP FRONTEND (Next.js)
echo ========================================
cd frontend

REM Check if node_modules exists
if not exist "node_modules" (
    echo [SETUP] Installing Node.js dependencies...
    echo This may take a few minutes on first run...
    call npm install
    if %errorlevel% neq 0 (
        color 0C
        echo.
        echo [ERROR] Failed to install Node.js dependencies
        echo.
        echo Try running manually:
        echo   cd frontend
        echo   npm install
        echo.
        cd ..
        pause
        exit /b 1
    )
    echo [OK] Frontend dependencies installed
) else (
    echo [OK] Node modules already installed
)
echo.

REM Start Frontend in a new window
echo [START] Starting Frontend Server on http://localhost:3000
start "Frontend - Next.js (Port 3000)" cmd /k "cd /d %CD% && echo Starting Next.js Frontend... && npm run dev"

cd ..
echo.

REM Display access information
color 0A
echo ========================================
echo   CYBERSECURITY SYSTEM STARTED!
echo ========================================
echo.
echo [ACCESS POINTS]
echo   Frontend Dashboard:  http://localhost:3000
echo   Backend API:         http://localhost:5000
echo   API Documentation:   http://localhost:5000/api/docs/swagger
echo.
echo [STATUS]
echo   - Two new windows have opened:
echo     1. Backend - Flask API (Port 5000)
echo     2. Frontend - Next.js (Port 3000)
echo.
echo [INSTRUCTIONS]
echo   - Wait 15-30 seconds for services to fully start
echo   - Browser will open automatically to http://localhost:3000
echo   - Watch the Backend and Frontend windows for any errors
echo   - To stop: Close both Backend and Frontend windows
echo     OR run STOP_LOCAL.bat
echo.
echo [TIPS]
echo   - Backend logs: backend\logs\
echo   - Database: backend\instance\cybersecurity.db
echo   - Data storage: data\
echo   - Configuration: backend\.env
echo   - To restart: Run this file again
echo.
echo [TROUBLESHOOTING]
echo   - If ports are in use, close other applications
echo   - Check Backend/Frontend windows for error messages
echo   - See LOCAL_SETUP_GUIDE.md for detailed help
echo.
echo ========================================
echo.

REM Wait a bit and try to open the browser
echo [INFO] Waiting for services to start...
timeout /t 15 /nobreak >nul
echo [INFO] Opening browser to http://localhost:3000...
start http://localhost:3000

echo.
echo [SUCCESS] System is running!
echo.
echo Press any key to close this window.
echo (Backend and Frontend will continue running)
echo.
pause >nul
