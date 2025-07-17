# دليل حل مشاكل البناء - Professional Muslim App

## 🔧 المشاكل الشائعة وحلولها

### 1. مشكلة NDK غير مُعد

**الخطأ:**
```
NDK not configured. Download it with SDK manager. Preferred NDK version is '27.0.12077973'.
```

**الحل:**
```bash
# الطريقة الأولى: تثبيت NDK من Android Studio
# 1. افتح Android Studio
# 2. اذهب إلى Tools > SDK Manager
# 3. اختر SDK Tools tab
# 4. حدد NDK (Side by side) وثبته

# الطريقة الثانية: تثبيت من سطر الأوامر
sdkmanager "ndk;27.0.12077973"

# الطريقة الثالثة: تعطيل NDK (إذا لم تكن تحتاجه)
# في android/app/build.gradle.kts احذف أو علق على:
# ndkVersion = flutter.ndkVersion
```

### 2. مشكلة Gradle JVM Memory

**الخطأ:**
```
Expiring Daemon because JVM heap space is exhausted
```

**الحل:**
```properties
# في android/gradle.properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G
org.gradle.daemon=true
org.gradle.parallel=true
```

### 3. مشكلة Flutter SDK Version

**الخطأ:**
```
Flutter SDK version conflict
```

**الحل:**
```bash
# تحديث Flutter
flutter upgrade

# تنظيف المشروع
flutter clean
flutter pub get

# إعادة بناء
flutter build apk
```

### 4. مشكلة Android SDK

**الخطأ:**
```
Android SDK not found
```

**الحل:**
```bash
# تعيين متغير البيئة
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# أو في Windows
set ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
set PATH=%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\platform-tools
```

### 5. مشكلة Gradle Wrapper

**الخطأ:**
```
Gradle wrapper not found
```

**الحل:**
```bash
# في مجلد android/
./gradlew wrapper --gradle-version 8.0

# أو إعادة إنشاء المشروع
flutter create --project-name professional_muslim .
```

## 🚀 خطوات البناء الصحيحة

### 1. التحقق من البيئة

```bash
# التحقق من Flutter
flutter doctor

# التحقق من Android toolchain
flutter doctor --android-licenses
```

### 2. تنظيف المشروع

```bash
# تنظيف Flutter
flutter clean

# تنظيف Gradle
cd android
./gradlew clean
cd ..

# إعادة تثبيت الاعتمادات
flutter pub get
```

### 3. البناء التدريجي

```bash
# بناء debug أولاً
flutter build apk --debug

# إذا نجح، بناء release
flutter build apk --release
```

## 🔍 تشخيص المشاكل

### فحص ملفات البناء

```bash
# فحص gradle.properties
cat android/gradle.properties

# فحص build.gradle.kts
cat android/app/build.gradle.kts

# فحص pubspec.yaml
cat pubspec.yaml
```

### سجلات مفصلة

```bash
# بناء مع سجلات مفصلة
flutter build apk --verbose

# أو
flutter run --verbose
```

## 📱 اختبار البناء

### على المحاكي

```bash
# تشغيل المحاكي
flutter emulators --launch <emulator_id>

# تشغيل التطبيق
flutter run
```

### على الجهاز الفعلي

```bash
# التحقق من الأجهزة المتصلة
flutter devices

# تشغيل على جهاز محدد
flutter run -d <device_id>
```

## 🛠️ إعدادات متقدمة

### تحسين أداء البناء

```properties
# في android/gradle.properties
org.gradle.caching=true
org.gradle.configureondemand=true
org.gradle.parallel=true
android.enableBuildCache=true
```

### إعدادات ProGuard

```kotlin
// في android/app/build.gradle.kts
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

## 🆘 الحصول على المساعدة

### معلومات مفيدة للدعم

```bash
# معلومات النظام
flutter doctor -v

# معلومات المشروع
flutter analyze

# معلومات Gradle
cd android && ./gradlew --version
```

### مصادر المساعدة

- [Flutter Documentation](https://flutter.dev/docs)
- [Android Developer Guide](https://developer.android.com/guide)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

## 📞 التواصل للدعم

إذا واجهت مشكلة لم تُحل بهذا الدليل:

- **البريد الإلكتروني**: gogom8870@gmail.com
- **الهاتف**: 01225155329
- **GitHub Issues**: [رابط المشروع]/issues

---

**نصيحة**: احتفظ بنسخة احتياطية من المشروع قبل إجراء تغييرات كبيرة على إعدادات البناء.
