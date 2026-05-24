@echo off
setlocal

set "APP_DIR=%~dp0"
set "APP_FILE=%APP_DIR%construction_manager_app.py"

cd /d "%APP_DIR%"

if not exist "%APP_FILE%" (
    echo The application file was not found:
    echo   "%APP_FILE%"
    pause
    exit /b 1
)

echo Starting Construction Manager...
echo.

where py >nul 2>nul
if %errorlevel% equ 0 (
    py "%APP_FILE%"
    set "APP_EXIT_CODE=%errorlevel%"
    goto done
)

where python >nul 2>nul
if %errorlevel% equ 0 (
    python "%APP_FILE%"
    set "APP_EXIT_CODE=%errorlevel%"
    goto done
)

echo Python was not found. Install Python 3, then run:
echo   pip install oracledb
echo   python "%APP_FILE%"
pause
exit /b 1

:done
echo.
if not "%APP_EXIT_CODE%"=="0" (
    echo The application closed with error code %APP_EXIT_CODE%.
    echo Check that Oracle Database is running and that the oracledb package is installed:
    echo   pip install oracledb
    echo.
)
pause
exit /b %APP_EXIT_CODE%
