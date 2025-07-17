# دليل النشر - Professional Muslim App

## 📋 نظرة عامة

هذا الدليل يوضح كيفية تحضير وإطلاق تطبيق Professional Muslim في متاجر التطبيقات.

## 🔧 التحضير للنشر

### 1. تحديث معلومات التطبيق

#### في `pubspec.yaml`:
```yaml
name: professional_muslim
description: تطبيق شامل للأذكار والعبادات الإسلامية
version: 1.0.0+1

environment:
  sdk: '>=2.19.0 <4.0.0'
  flutter: ">=3.0.0"
```

#### في `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    applicationId = "com.professional.muslim"
    versionCode = 1
    versionName = "1.0.0"
}
```

### 2. إعداد الأيقونات

#### إنشاء أيقونة التطبيق:
```bash
# تثبيت flutter_launcher_icons
flutter pub add --dev flutter_launcher_icons

# إضافة الإعداد في pubspec.yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#2E7D32"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"

# إنشاء الأيقونات
flutter pub run flutter_launcher_icons:main
```

### 3. إعداد الصلاحيات

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>يحتاج التطبيق للموقع لحساب مواقيت الصلاة واتجاه القبلة</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>يحتاج التطبيق للموقع لحساب مواقيت الصلاة واتجاه القبلة</string>
```

## 🤖 النشر على Google Play Store

### 1. إنشاء مفتاح التوقيع

```bash
# إنشاء keystore
keytool -genkey -v -keystore ~/professional-muslim-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias professional-muslim

# إنشاء ملف key.properties
echo "storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=professional-muslim
storeFile=../professional-muslim-key.jks" > android/key.properties
```

### 2. تحديث build.gradle.kts

```kotlin
// إضافة في أعلى الملف
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ...
        }
    }
}
```

### 3. بناء APK/AAB للإنتاج

```bash
# بناء APK
flutter build apk --release

# بناء Android App Bundle (مفضل)
flutter build appbundle --release
```

### 4. اختبار البناء

```bash
# تثبيت APK على الجهاز
flutter install --release

# اختبار الأداء
flutter run --profile
```

### 5. رفع التطبيق

1. **إنشاء حساب Google Play Console**
2. **إنشاء تطبيق جديد**
3. **رفع AAB file**
4. **ملء معلومات التطبيق**
5. **إضافة لقطات الشاشة**
6. **كتابة الوصف**
7. **تحديد الفئة العمرية**
8. **مراجعة وإرسال للمراجعة**

## 🍎 النشر على App Store

### 1. إعداد iOS

```bash
# فتح مشروع iOS
open ios/Runner.xcworkspace

# في Xcode:
# 1. تحديد Bundle Identifier
# 2. إعداد Signing & Capabilities
# 3. تحديد Deployment Target (iOS 12.0+)
```

### 2. بناء للإنتاج

```bash
# بناء iOS
flutter build ios --release

# أو بناء IPA
flutter build ipa --release
```

### 3. رفع التطبيق

1. **استخدام Xcode**:
   - Product → Archive
   - Window → Organizer
   - Distribute App

2. **استخدام Transporter**:
   - رفع IPA file مباشرة

## 📊 قائمة مراجعة ما قبل النشر

### ✅ الكود والجودة
- [ ] تشغيل `flutter analyze` بدون أخطاء
- [ ] تشغيل جميع الاختبارات بنجاح
- [ ] مراجعة الكود للأمان
- [ ] إزالة جميع TODO والتعليقات التطويرية
- [ ] تحسين الأداء والذاكرة

### ✅ التطبيق والميزات
- [ ] اختبار جميع الميزات
- [ ] اختبار على أجهزة مختلفة
- [ ] اختبار الاتصال بالإنترنت وبدونه
- [ ] اختبار الصلاحيات
- [ ] اختبار الإشعارات

### ✅ المحتوى والترجمة
- [ ] مراجعة جميع النصوص
- [ ] التأكد من صحة الترجمات
- [ ] مراجعة الأذكار والمحتوى الديني
- [ ] التأكد من المراجع الصحيحة

### ✅ التصميم والواجهة
- [ ] اختبار الثيم الفاتح والداكن
- [ ] اختبار على أحجام شاشات مختلفة
- [ ] التأكد من وضوح الأيقونات
- [ ] مراجعة الألوان والخطوط

### ✅ الأمان والخصوصية
- [ ] مراجعة الصلاحيات المطلوبة
- [ ] التأكد من عدم جمع بيانات حساسة
- [ ] إضافة سياسة الخصوصية
- [ ] تشفير البيانات المحلية

## 📝 معلومات المتجر

### وصف التطبيق (العربية)
```
تطبيق أذكار المسلم المحترف - تطبيق شامل للعبادات الإسلامية

🌟 الميزات الرئيسية:
📿 أذكار الصباح والمساء والنوم والصلاة
🕌 مواقيت الصلاة الدقيقة
🧭 اتجاه القبلة بالبوصلة الذكية
📖 قراءة وحفظ القرآن الكريم
💰 حاسبة الزكاة والمواريث
🌙 تتبع الصيام
🎨 تصميم عصري مع الوضع الليلي

تطبيق مجاني بالكامل بدون إعلانات مزعجة
```

### وصف التطبيق (الإنجليزية)
```
Professional Muslim - Complete Islamic Worship App

🌟 Key Features:
📿 Morning, Evening, Sleep & Prayer Azkar
🕌 Accurate Prayer Times
🧭 Smart Qibla Compass
📖 Quran Reading & Memorization
💰 Zakat & Inheritance Calculators
🌙 Fasting Tracker
🎨 Modern Design with Dark Mode

Completely free with no annoying ads
```

### الكلمات المفتاحية
- أذكار، إسلام، مسلم، قرآن، صلاة، قبلة، زكاة، صيام
- Azkar, Islam, Muslim, Quran, Prayer, Qibla, Zakat, Fasting

### الفئة
- **Android**: Lifestyle > Religion & Spirituality
- **iOS**: Lifestyle > Religion & Spirituality

## 🚀 بعد النشر

### مراقبة الأداء
- مراقبة التقييمات والمراجعات
- تتبع التحميلات والاستخدام
- مراقبة الأخطاء والتعطل

### التحديثات
- إصلاح الأخطاء المكتشفة
- إضافة ميزات جديدة
- تحسين الأداء
- تحديث المحتوى

### التسويق
- مشاركة على وسائل التواصل
- طلب التقييمات من المستخدمين
- إنشاء موقع ويب للتطبيق
- التواصل مع المؤثرين

---

للمزيد من المساعدة، راجع [دليل المطور](DEVELOPER_GUIDE.md) أو تواصل مع فريق التطوير.
