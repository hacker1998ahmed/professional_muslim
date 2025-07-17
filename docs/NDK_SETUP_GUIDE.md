# دليل إعداد NDK - Professional Muslim App

## 🔧 حل مشكلة NDK not configured

### المشكلة:
```
NDK not configured. Download it with SDK manager. Preferred NDK version is '27.0.12077973'.
```

### الحلول:

#### الحل الأول: تثبيت NDK (إذا كنت تحتاجه)

1. **من Android Studio:**
   - افتح Android Studio
   - اذهب إلى `Tools` > `SDK Manager`
   - اختر تبويب `SDK Tools`
   - حدد `NDK (Side by side)`
   - اختر الإصدار `27.0.12077973` أو الأحدث
   - اضغط `Apply` و `OK`

2. **من سطر الأوامر:**
   ```bash
   # تثبيت NDK
   sdkmanager "ndk;27.0.12077973"
   
   # أو الإصدار الأحدث
   sdkmanager "ndk-bundle"
   ```

3. **تحديث local.properties:**
   ```properties
   # في android/local.properties
   flutter.sdk=C:\\flutter
   ndk.dir=C:\\Users\\%USERNAME%\\AppData\\Local\\Android\\Sdk\\ndk\\27.0.12077973
   ```

#### الحل الثاني: تعطيل NDK (الأسهل)

إذا كان تطبيقك لا يحتاج NDK (وهو الحال في معظم تطبيقات Flutter):

1. **في android/gradle.properties:**
   ```properties
   # تعطيل NDK
   android.useNDK=false
   android.ndkVersion=
   ```

2. **في android/app/build.gradle.kts:**
   ```kotlin
   android {
       // تأكد من عدم وجود هذا السطر
       // ndkVersion = "27.0.12077973"
   }
   ```

#### الحل الثالث: استخدام Flutter الافتراضي

```bash
# تنظيف المشروع
flutter clean

# إعادة تثبيت الاعتمادات
flutter pub get

# بناء التطبيق
flutter build apk --debug
```

### التحقق من الحل:

```bash
# التحقق من إعدادات Flutter
flutter doctor

# التحقق من Android toolchain
flutter doctor --android-licenses

# بناء تجريبي
flutter build apk --debug
```

### إعدادات إضافية:

#### في android/gradle.properties:
```properties
# تحسين الأداء
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true

# إعدادات Android
android.useAndroidX=true
android.enableJetifier=true
android.enableR8.fullMode=true
android.enableBuildCache=true

# تعطيل NDK إذا لم تكن تحتاجه
android.useNDK=false
android.ndkVersion=
```

#### في android/app/build.gradle.kts:
```kotlin
android {
    namespace = "com.professional.muslim"
    compileSdk = 34
    
    // لا تضع ndkVersion إذا لم تكن تحتاجه
    
    defaultConfig {
        applicationId = "com.professional.muslim"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

### مشاكل شائعة وحلولها:

#### 1. مشكلة مسار NDK:
```bash
# تحديد مسار NDK يدوياً
export ANDROID_NDK_HOME=/path/to/ndk
export NDK_HOME=/path/to/ndk
```

#### 2. مشكلة إصدار NDK:
```bash
# قائمة الإصدارات المتاحة
sdkmanager --list | grep ndk

# تثبيت إصدار محدد
sdkmanager "ndk;25.1.8937393"
```

#### 3. مشكلة Gradle:
```bash
# تنظيف Gradle cache
cd android
./gradlew clean

# إعادة بناء
./gradlew build
```

### نصائح مهمة:

1. **معظم تطبيقات Flutter لا تحتاج NDK**
2. **استخدم الحل الثاني (تعطيل NDK) إذا لم تكن تستخدم native code**
3. **تأكد من تحديث Android SDK Tools**
4. **استخدم أحدث إصدار من Flutter**

### للمطورين المتقدمين:

إذا كنت تحتاج NDK فعلاً (للمكتبات native):

```kotlin
// في android/app/build.gradle.kts
android {
    ndkVersion = "27.0.12077973"
    
    defaultConfig {
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }
}
```

### التحقق النهائي:

```bash
# بناء APK
flutter build apk --release

# بناء AAB
flutter build appbundle --release

# تشغيل على الجهاز
flutter run --release
```

---

**ملاحظة**: إذا استمرت المشكلة، تأكد من:
- تحديث Android Studio
- تحديث Flutter SDK
- تحديث Android SDK Tools
- إعادة تشغيل IDE
