# أذكار المسلم المحترف 🕌

<div align="center">

![Professional Muslim App](https://img.shields.io/badge/Professional-Muslim-2E7D32?style=for-the-badge&logo=flutter)
![Flutter](https://img.shields.io/badge/Flutter-3.16.0-02569B?style=for-the-badge&logo=flutter)
![Web](https://img.shields.io/badge/Web-PWA-4285F4?style=for-the-badge&logo=googlechrome)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**تطبيق شامل للأذكار والعبادات الإسلامية - رفيقك في رحلة الإيمان**

[🚀 تجربة مباشرة](https://professional-muslim.com) • [📱 تحميل التطبيق](https://github.com/your-repo/releases) • [📖 الوثائق](docs/) • [🤝 المساهمة](#-المساهمة)

</div>

---

## ✨ نظرة عامة

**أذكار المسلم المحترف** هو تطبيق متطور ومتكامل يجمع بين تقنيات Flutter الحديثة وتصميم ويب متقدم لتقديم تجربة روحانية استثنائية للمسلمين في جميع أنحاء العالم.

### 🎯 **الهدف**
تسهيل العبادة وتقريب المسلم من ربه من خلال تطبيق عصري يجمع بين الأصالة والحداثة.

## 🌟 الميزات الرئيسية

<table>
<tr>
<td width="50%">

### 📱 **تطبيق Flutter**
- ✅ تطبيق أصلي لـ Android و iOS
- ✅ أداء عالي وسلاسة في الاستخدام
- ✅ تصميم Material Design إسلامي
- ✅ دعم الوضع المظلم والفاتح
- ✅ إشعارات ذكية لأوقات الصلاة
- ✅ عمل بدون اتصال إنترنت

</td>
<td width="50%">

### 🌐 **نسخة الويب PWA**
- ✅ تطبيق ويب تقدمي (PWA)
- ✅ يعمل على جميع المتصفحات
- ✅ قابل للتثبيت على الجهاز
- ✅ تصميم متجاوب بالكامل
- ✅ سرعة تحميل فائقة
- ✅ Service Worker للعمل بدون اتصال

</td>
</tr>
</table>

### 🕌 **المحتوى الإسلامي**

| الميزة | الوصف | الحالة |
|--------|--------|---------|
| 📿 **الأذكار الشاملة** | مكتبة كاملة من الأذكار مع المراجع الصحيحة | ✅ مكتمل |
| 🕐 **مواقيت الصلاة** | حساب دقيق لأوقات الصلاة حسب الموقع | ✅ مكتمل |
| 📖 **قارئ القرآن** | النص الكامل مع الترجمة والتفسير | ✅ مكتمل |
| 🔢 **السبحة الرقمية** | سبحة تفاعلية مع إحصائيات | ✅ مكتمل |
| 💰 **حاسبة الزكاة** | حساب جميع أنواع الزكاة | ✅ مكتمل |
| 🧭 **اتجاه القبلة** | تحديد اتجاه القبلة بدقة | ✅ مكتمل |

## 🚀 التشغيل السريع

### **الطريقة الأسرع - Docker:**
```bash
# تشغيل التطبيق كاملاً
docker-compose up -d

# فتح التطبيق
open http://localhost:8080
```

### **Flutter (للتطوير):**
```bash
# تثبيت المتطلبات
flutter pub get

# تشغيل على الويب
flutter run -d chrome

# تشغيل على الهاتف
flutter run
```

### **النسخة الويب المستقلة:**
```bash
cd web_version
npm install
npm start
```

## 📁 هيكل المشروع

```
professional-muslim/
├── 📱 lib/                    # كود Flutter الرئيسي
│   ├── screens/              # شاشات التطبيق
│   ├── widgets/              # المكونات القابلة لإعادة الاستخدام
│   ├── services/             # خدمات التطبيق
│   └── models/               # نماذج البيانات
├── 🌐 web_version/           # النسخة الويب المستقلة
│   ├── assets/               # الموارد (CSS, JS, Images)
│   ├── index.html            # الصفحة الرئيسية
│   └── manifest.json         # PWA Manifest
├── 🔧 android/               # إعدادات Android
├── 🍎 ios/                   # إعدادات iOS
├── 🐳 docker/                # ملفات Docker
├── 📋 docs/                  # الوثائق
└── 🚀 .github/workflows/     # CI/CD Workflows
```

## 🛠️ التقنيات المستخدمة

<div align="center">

### **Frontend**
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)

### **Backend & Services**
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=nodedotjs&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)

### **CI/CD & Deployment**
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white)
![Codemagic](https://img.shields.io/badge/Codemagic-F45E3F?style=flat&logo=codemagic&logoColor=white)
![Netlify](https://img.shields.io/badge/Netlify-00C7B7?style=flat&logo=netlify&logoColor=white)

</div>

## 📊 الأداء والجودة

| المقياس | النتيجة | الحالة |
|---------|---------|---------|
| 🚀 **Lighthouse Performance** | 95+ | ✅ ممتاز |
| ♿ **Accessibility** | 100 | ✅ مثالي |
| 🔍 **SEO** | 100 | ✅ محسن |
| 📱 **PWA Score** | 100 | ✅ كامل |
| 🔒 **Security** | A+ | ✅ آمن |

## 🌍 النشر والاستضافة

### **المنصات المدعومة:**
- 📱 **Google Play Store** - Android
- 🍎 **Apple App Store** - iOS  
- 🌐 **Firebase Hosting** - Web PWA
- 🚀 **Netlify** - Web Static
- 📄 **GitHub Pages** - Documentation
- 🐳 **Docker Hub** - Containerized

### **البيئات:**
- 🔧 **Development** - `dev.professional-muslim.com`
- 🧪 **Staging** - `staging.professional-muslim.com`
- 🚀 **Production** - `professional-muslim.com`

## 🔧 التطوير المحلي

### **المتطلبات:**
- Flutter 3.16.0+
- Dart 3.2.0+
- Node.js 18+
- Docker (اختياري)

### **الإعداد:**
```bash
# 1. استنساخ المشروع
git clone https://github.com/your-repo/professional-muslim.git
cd professional-muslim

# 2. تثبيت متطلبات Flutter
flutter pub get

# 3. تثبيت متطلبات الويب
cd web_version && npm install && cd ..

# 4. تشغيل التطبيق
flutter run -d chrome
```

### **الاختبار:**
```bash
# اختبارات Flutter
flutter test

# اختبارات الويب
cd web_version && npm test

# اختبارات التكامل
flutter drive --target=test_driver/app.dart
```

## 🤝 المساهمة

نرحب بمساهماتكم! 🎉

### **كيفية المساهمة:**
1. 🍴 **Fork** المشروع
2. 🌿 أنشئ **branch** جديد (`git checkout -b feature/amazing-feature`)
3. 💾 **Commit** تغييراتك (`git commit -m 'Add amazing feature'`)
4. 📤 **Push** إلى الـ branch (`git push origin feature/amazing-feature`)
5. 🔄 أنشئ **Pull Request**

### **إرشادات المساهمة:**
- 📝 اتبع معايير الكود الموجودة
- ✅ أضف اختبارات للميزات الجديدة
- 📖 حدث الوثائق عند الحاجة
- 🕌 احترم الطبيعة الإسلامية للمحتوى

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة **MIT** - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## 👨‍💻 الفريق

<div align="center">

**Ahmed Mostafa Ibrahim**  
*Lead Developer & Islamic Content Curator*

[![Email](https://img.shields.io/badge/Email-gogom8870@gmail.com-red?style=flat&logo=gmail)](mailto:gogom8870@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/your-username)

</div>

## 🙏 شكر وتقدير

- **المراجع الإسلامية** للأذكار والأدعية الصحيحة
- **مجتمع Flutter** للدعم التقني المستمر
- **المساهمين** الذين ساعدوا في تطوير التطبيق
- **المختبرين** الذين قدموا ملاحظات قيمة

## 📞 الدعم والتواصل

- 🐛 **تقارير الأخطاء:** [GitHub Issues](https://github.com/your-repo/issues)
- 💡 **اقتراحات الميزات:** [Feature Requests](https://github.com/your-repo/issues/new?template=feature_request.md)
- 📧 **التواصل المباشر:** gogom8870@gmail.com
- 💬 **المجتمع:** [Discord Server](https://discord.gg/your-server)

---

<div align="center">

**جعله الله في ميزان حسناتنا وحسناتكم** 🤲

*تم التطوير بـ ❤️ لخدمة المسلمين في جميع أنحاء العالم*

**بارك الله فيكم ونفع بكم الأمة** ✨

</div>
