@echo off
title Test Cybersecurity Project Setup
color 0B

echo ========================================
echo   TESTING PROJECT SETUP
echo ========================================
echo.

set failures=0

REM Test Python
echo [TEST 1/4] Checking Python...
python --version 2>nul
if %errorlevel% equ 0 (
    echo [PASS] Python is installed
) else (
    echo [FAIL] Python is NOT installed
    set /a failures+=1
)
echo.

REM Test Node.js
echo [TEST 2/4] Checking Node.js...
node --version 2>nul
if %errorlevel% equ 0 (
    echo [PASS] Node.js is installed
) else (
    echo [FAIL] Node.js is NOT installed
    set /a failures+=1
)
echo.

REM Test npm
echo [TEST 3/4] Checking npm...
npm --version 2>nul
if %errorlevel% equ 0 (
    echo [PASS] npm is installed
) else (
    echo [FAIL] npm is NOT installed
    set /a failures+=1
)
echo.

REM Test pip
echo [TEST 4/4] Checking pip...
pip --version 2>nul
if %errorlevel% equ 0 (
    echo [PASS] pip is installed
) else (
    echo [FAIL] pip is NOT installed
    set /a failures+=1
)
echo.

echo ========================================
echo   TEST RESULTS
echo ========================================
echo.

if %failures% equ 0 (
    color 0A
    echo [SUCCESS] All prerequisites are installed!
    echo.
    echo You can now run START_LOCAL.bat to start the project.
) else (
    color 0C
    echo [WARNING] Some prerequisites are missing.
    echo.
    echo Please install the missing components:
    echo   - Python 3.8+: https://www.python.org/downloads/
    echo   - Node.js 16+: https://nodejs.org/
    echo.
    echo Make sure to check "Add to PATH" during installation.
)
echo.

REM Check if backend and frontend directories exist
echo ========================================
echo   PROJECT STRUCTURE
echo ========================================
echo.

if exist "backend" (
    echo [OK] backend/ directory found
) else (
    echo [MISSING] backend/ directory not found
)

if exist "frontend" (
    echo [OK] frontend/ directory found
) else (
    echo [MISSING] frontend/ directory not found
)

if exist "backend\requirements.txt" (
    echo [OK] backend/requirements.txt found
) else (
    echo [MISSING] backend/requirements.txt not found
)

if exist "frontend\package.json" (
    echo [OK] frontend/package.json found
) else (
    echo [MISSING] frontend/package.json not found
)

echo.
echo ========================================
echo.
pause
