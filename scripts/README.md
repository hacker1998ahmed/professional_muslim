# Scripts - Professional Muslim App

## 🔧 NDK Fix Scripts

### المشكلة:
```
NDK not configured. Download it with SDK manager. Preferred NDK version is '27.0.12077973'.
```

### الحل السريع:

#### Windows:
```bash
# تشغيل السكريبت
scripts\fix_ndk_issue.bat
```

#### Linux/Mac:
```bash
# جعل السكريبت قابل للتنفيذ
chmod +x scripts/fix_ndk_issue.sh

# تشغيل السكريبت
./scripts/fix_ndk_issue.sh
```

### ما يفعله السكريبت:

1. **تنظيف المشروع** - `flutter clean`
2. **تحديث الاعتمادات** - `flutter pub get`
3. **تنظيف Gradle** - `gradlew clean`
4. **فحص Flutter** - `flutter doctor`
5. **بناء APK** - `flutter build apk --debug`
6. **التحقق من النجاح**

### إذا فشل السكريبت:

#### الحل اليدوي:
```bash
# 1. تنظيف شامل
flutter clean
rm -rf build/
rm -rf android/.gradle/
rm -rf android/app/build/

# 2. إعادة تثبيت
flutter pub get

# 3. بناء بدون تحسينات
flutter build apk --debug --no-shrink --no-obfuscate

# 4. إذا لم ينجح، جرب:
flutter build apk --debug --target-platform android-arm64
```

#### فحص البيئة:
```bash
# فحص Flutter
flutter doctor -v

# فحص Android SDK
echo $ANDROID_HOME
ls $ANDROID_HOME/platforms/

# فحص Java
java -version
javac -version
```

### الحلول البديلة:

#### 1. تثبيت NDK (إذا كنت تحتاجه):
```bash
# من Android Studio
# Tools > SDK Manager > SDK Tools > NDK (Side by side)

# أو من سطر الأوامر
sdkmanager "ndk;27.0.12077973"
```

#### 2. تعطيل NDK (الأسهل):
```properties
# في android/gradle.properties
android.useNDK=false
android.ndkVersion=
```

#### 3. استخدام Flutter الافتراضي:
```bash
# إعادة إنشاء ملفات Android
flutter create --project-name professional_muslim .
```

### نصائح مهمة:

1. **تأكد من تحديث Flutter:**
   ```bash
   flutter upgrade
   ```

2. **تأكد من إعدادات البيئة:**
   ```bash
   # Windows
   set ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
   set JAVA_HOME=C:\Program Files\Java\jdk-11.0.x

   # Linux/Mac
   export ANDROID_HOME=$HOME/Android/Sdk
   export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
   ```

3. **تأكد من إصدار Java:**
   - يجب أن يكون Java 11 أو أحدث
   - تجنب Java 8 مع Flutter الحديث

### استكشاف الأخطاء:

#### خطأ "SDK not found":
```bash
# تحديد مسار SDK يدوياً
echo "sdk.dir=C:\\Users\\%USERNAME%\\AppData\\Local\\Android\\Sdk" > android/local.properties
```

#### خطأ "Gradle version":
```bash
# تحديث Gradle wrapper
cd android
./gradlew wrapper --gradle-version 8.0
```

#### خطأ "Build tools":
```bash
# تثبيت build tools
sdkmanager "build-tools;34.0.0"
sdkmanager "platforms;android-34"
```

### للمطورين المتقدمين:

#### تخصيص البناء:
```kotlin
// في android/app/build.gradle.kts
android {
    // تعطيل NDK
    packagingOptions {
        pickFirst("**/libc++_shared.so")
    }
    
    // تحسين البناء
    buildTypes {
        debug {
            isMinifyEnabled = false
            isDebuggable = true
        }
    }
}
```

#### متغيرات البيئة:
```bash
# إضافة للـ PATH
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0
```

---

## 📞 الدعم:

إذا استمرت المشاكل:
1. راجع `docs/NDK_SETUP_GUIDE.md`
2. راجع `docs/BUILD_TROUBLESHOOTING.md`
3. تواصل مع المطور: gogom8870@gmail.com

**ملاحظة**: معظم تطبيقات Flutter لا تحتاج NDK، لذا تعطيله هو الحل الأمثل.
