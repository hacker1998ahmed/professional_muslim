@echo off
echo ========================================
echo   Professional Muslim - NDK Fix Script
echo ========================================
echo.

echo [1/6] Cleaning Flutter project...
flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed
    pause
    exit /b 1
)

echo [2/6] Getting Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed
    pause
    exit /b 1
)

echo [3/6] Cleaning Android Gradle...
cd android
call gradlew clean
if %errorlevel% neq 0 (
    echo ERROR: Gradle clean failed
    cd ..
    pause
    exit /b 1
)
cd ..

echo [4/6] Checking Flutter doctor...
flutter doctor

echo [5/6] Building debug APK (without NDK)...
flutter build apk --debug --no-shrink
if %errorlevel% neq 0 (
    echo ERROR: Debug build failed
    echo.
    echo Trying alternative build method...
    flutter build apk --debug --no-obfuscate --no-shrink
    if %errorlevel% neq 0 (
        echo ERROR: Alternative build also failed
        echo.
        echo Please check the following:
        echo 1. Android SDK is properly installed
        echo 2. ANDROID_HOME environment variable is set
        echo 3. Java JDK 11 or higher is installed
        echo.
        pause
        exit /b 1
    )
)

echo [6/6] Build completed successfully!
echo.
echo APK location: build\app\outputs\flutter-apk\app-debug.apk
echo.
echo ========================================
echo   NDK Issue Fixed Successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Test the APK on a device
echo 2. If working, build release version:
echo    flutter build apk --release
echo.
pause
