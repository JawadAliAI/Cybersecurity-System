@echo off
title Stop Cybersecurity Project
color 0C

echo ========================================
echo   STOPPING CYBERSECURITY PROJECT
echo ========================================
echo.

echo [WARNING] This will stop ALL Node.js and Python processes!
echo Press Ctrl+C to cancel, or
pause

echo.
echo [INFO] Stopping all Node.js processes (Frontend)...
taskkill /F /IM node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Frontend stopped
) else (
    echo [INFO] No Frontend processes found
)

echo [INFO] Stopping all Python processes (Backend)...
taskkill /F /IM python.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Backend stopped
) else (
    echo [INFO] No Backend processes found
)

echo.
echo ========================================
echo   ALL SERVICES STOPPED
echo ========================================
echo.
echo Press any key to exit...
pause >nul
