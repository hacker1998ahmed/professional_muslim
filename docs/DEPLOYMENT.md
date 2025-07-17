# دليل النشر - أذكار المسلم المحترف

## نظرة عامة

هذا الدليل يشرح كيفية نشر تطبيق "أذكار المسلم المحترف" على منصات مختلفة باستخدام Codemagic CI/CD.

## 🚀 منصات النشر المدعومة

### 📱 **التطبيقات المحمولة:**
- **Google Play Store** (Android)
- **Apple App Store** (iOS)
- **APK مباشر** للتوزيع

### 🌐 **النسخة الويب:**
- **Firebase Hosting**
- **Netlify**
- **GitHub Pages**
- **Vercel**

## ⚙️ إعداد Codemagic

### 1. إنشاء حساب Codemagic
1. اذهب إلى [codemagic.io](https://codemagic.io)
2. سجل دخول باستخدام GitHub
3. اربط مستودع المشروع

### 2. إعداد متغيرات البيئة

#### **Android (Google Play):**
```yaml
# في Codemagic Dashboard > App Settings > Environment Variables
CM_KEYSTORE: [Base64 encoded keystore file]
CM_KEYSTORE_PASSWORD: [Your keystore password]
CM_KEY_ALIAS_PASSWORD: [Your key alias password]
CM_KEY_ALIAS_USERNAME: [Your key alias]
GCLOUD_SERVICE_ACCOUNT_CREDENTIALS: [Google Play service account JSON]
```

#### **iOS (App Store):**
```yaml
APP_STORE_CONNECT_ISSUER_ID: [Your issuer ID]
APP_STORE_CONNECT_KEY_IDENTIFIER: [Your key identifier]
APP_STORE_CONNECT_PRIVATE_KEY: [Your private key]
CERTIFICATE_PRIVATE_KEY: [Your certificate private key]
```

#### **Web Deployment:**
```yaml
FIREBASE_TOKEN: [Firebase CLI token]
NETLIFY_AUTH_TOKEN: [Netlify personal access token]
NETLIFY_SITE_ID: [Your Netlify site ID]
```

#### **Notifications:**
```yaml
SLACK_WEBHOOK_URL: [Slack webhook for notifications]
DISCORD_WEBHOOK_URL: [Discord webhook for notifications]
```

## 🔐 إعداد التوقيع الرقمي

### Android Keystore
```bash
# إنشاء keystore جديد
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# تحويل إلى Base64 للرفع على Codemagic
base64 upload-keystore.jks > keystore_base64.txt
```

### iOS Certificates
1. اذهب إلى Apple Developer Console
2. أنشئ Distribution Certificate
3. أنشئ Provisioning Profile
4. ارفع الملفات على Codemagic

## 📋 سير العمل (Workflows)

### 1. **android-workflow**
- **الهدف:** بناء ونشر تطبيق Android
- **المخرجات:** APK + AAB
- **النشر:** Google Play Store

### 2. **ios-workflow**
- **الهدف:** بناء ونشر تطبيق iOS
- **المخرجات:** IPA
- **النشر:** App Store Connect

### 3. **web-workflow**
- **الهدف:** بناء ونشر النسخة الويب
- **المخرجات:** ملفات HTML/CSS/JS
- **النشر:** Firebase + Netlify

### 4. **testing-workflow**
- **الهدف:** اختبار الكود تلقائياً
- **التشغيل:** عند Pull Requests

### 5. **release-workflow**
- **الهدف:** نشر إصدار إنتاج
- **التشغيل:** عند إنشاء Tag

## 🏗️ خطوات البناء

### Android Build
```yaml
scripts:
  - flutter packages pub get
  - flutter analyze
  - flutter test
  - flutter build appbundle --release
```

### iOS Build
```yaml
scripts:
  - keychain initialize
  - app-store-connect fetch-signing-files
  - flutter packages pub get
  - pod install
  - flutter build ipa --release
```

### Web Build
```yaml
scripts:
  - flutter config --enable-web
  - flutter build web --release
  - npm install (for standalone web version)
  - npm run build
```

## 🚀 عملية النشر

### 1. **تطوير محلي**
```bash
# تشغيل الاختبارات
flutter test

# بناء محلي للتأكد
flutter build apk --debug
flutter build web
```

### 2. **Push إلى GitHub**
```bash
git add .
git commit -m "feat: إضافة ميزة جديدة"
git push origin main
```

### 3. **النشر التلقائي**
- Codemagic يبدأ البناء تلقائياً
- يرسل إشعارات على Slack/Discord
- ينشر على المنصات المحددة

### 4. **إصدار جديد**
```bash
# إنشاء tag للإصدار
git tag v1.0.0
git push origin v1.0.0

# سيتم تشغيل release-workflow تلقائياً
```

## 📊 مراقبة البناء

### Codemagic Dashboard
- عرض حالة البناء المباشر
- سجلات مفصلة لكل خطوة
- تحميل المخرجات (APK/IPA)

### الإشعارات
- **Slack:** إشعارات فورية للفريق
- **Email:** تقارير مفصلة
- **Discord:** تحديثات للمجتمع

## 🔧 استكشاف الأخطاء

### مشاكل شائعة:

#### **Android Build Fails**
```bash
# تحقق من:
- صحة keystore
- إعدادات Gradle
- إصدار Flutter المدعوم
```

#### **iOS Build Fails**
```bash
# تحقق من:
- صحة Certificates
- Provisioning Profiles
- Bundle ID مطابق
```

#### **Web Build Fails**
```bash
# تحقق من:
- إعدادات Flutter web
- dependencies في package.json
- متغيرات البيئة
```

## 📈 تحسين الأداء

### تسريع البناء:
```yaml
cache:
  cache_paths:
    - $FLUTTER_ROOT/.pub-cache
    - $HOME/.gradle/caches
    - node_modules
```

### تحسين الحجم:
```bash
# Android
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# iOS
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info
```

## 🔒 الأمان

### حماية المتغيرات الحساسة:
- استخدم Encrypted variables في Codemagic
- لا تضع أسرار في الكود
- راجع الصلاحيات بانتظام

### مراجعة الكود:
- فعل Branch Protection
- اطلب Code Review
- شغل Security Scans

## 📞 الدعم

### في حالة المشاكل:
1. **تحقق من السجلات** في Codemagic
2. **راجع الوثائق** الرسمية
3. **تواصل مع الفريق** عبر Slack
4. **أنشئ Issue** في GitHub

---

**جعله الله في ميزان حسناتنا** 🤲

*تم إعداد هذا الدليل بـ ❤️ لخدمة المسلمين*
