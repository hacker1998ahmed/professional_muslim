@echo off
chcp 65001 >nul
title أذكار المسلم المحترف - النسخة الويب

echo.
echo 🕌 أذكار المسلم المحترف - النسخة الويب
echo ==================================
echo.

REM Colors for Windows (limited support)
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

REM Check if Node.js is installed
echo %GREEN%[INFO]%NC% Checking for Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%NC% Node.js is not installed. Please install Node.js first.
    echo %BLUE%[INFO]%NC% Visit: https://nodejs.org/
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo %GREEN%[INFO]%NC% Node.js found: %NODE_VERSION%
)

REM Check if npm is installed
echo %GREEN%[INFO]%NC% Checking for npm...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%NC% npm is not installed. Please install npm first.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
    echo %GREEN%[INFO]%NC% npm found: %NPM_VERSION%
)

REM Install dependencies if package.json exists
if exist package.json (
    echo %GREEN%[INFO]%NC% Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo %RED%[ERROR]%NC% Failed to install dependencies.
        pause
        exit /b 1
    ) else (
        echo %GREEN%[INFO]%NC% Dependencies installed successfully!
    )
) else (
    echo %YELLOW%[WARNING]%NC% package.json not found. Skipping dependency installation.
)

echo.
echo %GREEN%[INFO]%NC% Ready to start the application!
echo %BLUE%[INFO]%NC% The app will be available at: http://localhost:8080
echo %BLUE%[INFO]%NC% Press Ctrl+C to stop the server
echo.

REM Wait a moment then open browser
timeout /t 2 /nobreak >nul
start http://localhost:8080

REM Start the server
echo %GREEN%[INFO]%NC% Starting development server...

REM Try different server options
npx serve . -p 8080 2>nul
if %errorlevel% neq 0 (
    echo %YELLOW%[WARNING]%NC% npx serve failed, trying Python...
    python -m http.server 8080 2>nul
    if %errorlevel% neq 0 (
        echo %YELLOW%[WARNING]%NC% Python 3 failed, trying Python 2...
        python -m SimpleHTTPServer 8080 2>nul
        if %errorlevel% neq 0 (
            echo %YELLOW%[WARNING]%NC% Python failed, trying PHP...
            php -S localhost:8080 2>nul
            if %errorlevel% neq 0 (
                echo %RED%[ERROR]%NC% No suitable server found. Please install Node.js, Python, or PHP.
                pause
                exit /b 1
            )
        )
    )
)

REM This should not be reached if server starts successfully
echo.
echo %GREEN%[INFO]%NC% Server stopped.
echo %GREEN%[INFO]%NC% Thank you for using Professional Muslim Web App!
echo %BLUE%[INFO]%NC% جزاكم الله خيراً
pause
