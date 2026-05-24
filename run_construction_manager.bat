@echo off
setlocal

set "APP_DIR=%~dp0"
set "APP_FILE=%APP_DIR%construction_manager_app.py"

where py >nul 2>nul
if %errorlevel% equ 0 (
    py "%APP_FILE%"
    exit /b %errorlevel%
)

where python >nul 2>nul
if %errorlevel% equ 0 (
    python "%APP_FILE%"
    exit /b %errorlevel%
)

echo Python was not found. Install Python 3, then run:
echo   pip install oracledb
echo   python "%APP_FILE%"
pause
