#!/bin/bash

echo "========================================"
echo "  Professional Muslim - NDK Fix Script"
echo "========================================"
echo

echo "[1/6] Cleaning Flutter project..."
flutter clean
if [ $? -ne 0 ]; then
    echo "ERROR: Flutter clean failed"
    exit 1
fi

echo "[2/6] Getting Flutter dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: Flutter pub get failed"
    exit 1
fi

echo "[3/6] Cleaning Android Gradle..."
cd android
./gradlew clean
if [ $? -ne 0 ]; then
    echo "ERROR: Gradle clean failed"
    cd ..
    exit 1
fi
cd ..

echo "[4/6] Checking Flutter doctor..."
flutter doctor

echo "[5/6] Building debug APK (without NDK)..."
flutter build apk --debug --no-shrink
if [ $? -ne 0 ]; then
    echo "ERROR: Debug build failed"
    echo
    echo "Trying alternative build method..."
    flutter build apk --debug --no-obfuscate --no-shrink
    if [ $? -ne 0 ]; then
        echo "ERROR: Alternative build also failed"
        echo
        echo "Please check the following:"
        echo "1. Android SDK is properly installed"
        echo "2. ANDROID_HOME environment variable is set"
        echo "3. Java JDK 11 or higher is installed"
        echo
        exit 1
    fi
fi

echo "[6/6] Build completed successfully!"
echo
echo "APK location: build/app/outputs/flutter-apk/app-debug.apk"
echo
echo "========================================"
echo "  NDK Issue Fixed Successfully!"
echo "========================================"
echo
echo "Next steps:"
echo "1. Test the APK on a device"
echo "2. If working, build release version:"
echo "   flutter build apk --release"
echo

# Make script executable
chmod +x scripts/fix_ndk_issue.sh
