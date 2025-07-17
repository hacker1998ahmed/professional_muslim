# Professional Muslim - تطبيق أذكار المسلم المحترف

<div align="center">
  <img src="assets/images/app_icon.png" alt="Professional Muslim App" width="120" height="120">

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
</div>

تطبيق إسلامي شامل ومتكامل يخدم المسلمين في حياتهم اليومية، مبني باستخدام Flutter مع تصميم عصري وميزات متقدمة.

## 🌟 المميزات الرئيسية

### 📿 الأذكار والتسبيح
- **أذكار الصباح والمساء** مع العدد والمرجع والفائدة
- **أذكار النوم** للراحة النفسية
- **أذكار الصلاة** لما بعد كل صلاة
- **السبحة الإلكترونية** مع حفظ العدد تلقائياً
- **أذكار من القرآن الكريم**

### 🕌 العبادات والشعائر
- **مواقيت الصلاة** بدقة عالية مع تحديد الموقع
- **اتجاه القبلة** باستخدام البوصلة الذكية
- **تتبع الصيام** لرمضان والصيام التطوعي
- **حفظ القرآن الكريم** مع نظام المراجعة
- **قراءة القرآن** مع التفسير

### 💰 الحاسبات الشرعية
- **حاسبة الزكاة** الشاملة لجميع الأموال
- **حاسبة المواريث** وفقاً للشريعة الإسلامية

### 🎨 التصميم والتجربة
- **تصميم عصري** مع Material Design 3
- **الوضع الليلي** لراحة العينين
- **دعم اللغات المتعددة** (العربية والإنجليزية)
- **انيميشنز سلسة** لتجربة مستخدم ممتازة
- **نافيجيشن محسن** مع Bottom Navigation

## 🚀 التقنيات المستخدمة

- **Flutter 3.x** - إطار العمل الأساسي
- **Provider** - إدارة الحالة
- **SharedPreferences** - حفظ البيانات المحلية
- **Geolocator** - تحديد الموقع
- **Adhan** - حساب مواقيت الصلاة
- **AudioPlayers** - تشغيل الأصوات
- **Flutter Local Notifications** - الإشعارات

## 📱 لقطات الشاشة

<div align="center">
  <img src="screenshots/home.png" alt="الشاشة الرئيسية" width="200">
  <img src="screenshots/azkar.png" alt="الأذكار" width="200">
  <img src="screenshots/prayer.png" alt="مواقيت الصلاة" width="200">
  <img src="screenshots/qibla.png" alt="القبلة" width="200">
</div>

## 🛠️ التثبيت والتشغيل

### المتطلبات
- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.19.0)
- Android Studio / VS Code
- Android SDK (للأندرويد)
- Xcode (للـ iOS)

### خطوات التثبيت

1. **استنساخ المشروع**
   ```bash
   git clone https://github.com/your-username/professional_muslim.git
   cd professional_muslim
   ```

2. **تثبيت الاعتمادات**
   ```bash
   flutter pub get
   ```

3. **تشغيل التطبيق**
   ```bash
   flutter run
   ```

4. **بناء التطبيق للإنتاج**
   ```bash
   # للأندرويد
   flutter build apk --release

   # للـ iOS
   flutter build ios --release
   ```

## 🏗️ هيكل المشروع

```
lib/
├── core/                    # الأساسيات والأدوات المساعدة
│   ├── constants/          # الثوابت
│   ├── theme/             # إعدادات الثيم
│   ├── utils/             # أدوات مساعدة
│   └── state/             # إدارة الحالة المركزية
├── data/                   # طبقة البيانات
│   ├── models/            # نماذج البيانات
│   ├── providers/         # مزودي البيانات
│   ├── repositories/      # مستودعات البيانات
│   └── services/          # الخدمات
├── localization/          # الترجمة والتوطين
├── models/                # النماذج الأساسية
├── providers/             # مزودي الحالة
├── screens/               # شاشات التطبيق
├── ui/                    # مكونات واجهة المستخدم
│   ├── screens/          # شاشات مخصصة
│   ├── shared/           # مكونات مشتركة
│   └── widgets/          # ويجتس قابلة لإعادة الاستخدام
└── main.dart             # نقطة الدخول

assets/
├── audio/                 # ملفات الأصوات
├── data/                  # بيانات JSON
├── fonts/                 # الخطوط
└── images/                # الصور والأيقونات

test/                      # الاختبارات
├── providers/            # اختبارات المزودات
├── widgets/              # اختبارات الويجتس
└── integration_test/     # اختبارات التكامل
```

## 🧪 الاختبارات

يحتوي المشروع على مجموعة شاملة من الاختبارات:

### تشغيل الاختبارات
```bash
# اختبارات الوحدة
flutter test

# اختبارات الويجت
flutter test test/widgets/

# اختبارات التكامل
flutter test integration_test/
```

### أنواع الاختبارات
- **Unit Tests** - اختبار المزودات والنماذج
- **Widget Tests** - اختبار واجهة المستخدم
- **Integration Tests** - اختبار التطبيق بالكامل

## 📚 التوثيق

### للمطورين
- [دليل المساهمة](CONTRIBUTING.md)
- [دليل الأكواد](docs/CODE_GUIDE.md)
- [دليل API](docs/API_GUIDE.md)

### للمستخدمين
- [دليل الاستخدام](docs/USER_GUIDE.md)
- [الأسئلة الشائعة](docs/FAQ.md)

## 🤝 المساهمة

نرحب بمساهماتكم! يرجى قراءة [دليل المساهمة](CONTRIBUTING.md) قبل البدء.

### خطوات المساهمة
1. Fork المشروع
2. إنشاء branch جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push للـ branch (`git push origin feature/amazing-feature`)
5. فتح Pull Request

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## 👨‍💻 المطور

**أحمد مصطفى إبراهيم**
- 📧 البريد الإلكتروني: gogom8870@gmail.com
- 📱 الهاتف: 01225155329
- 🌐 GitHub: [@your-username](https://github.com/your-username)

## 🙏 شكر وتقدير

- شكر خاص لمجتمع Flutter
- شكر لجميع المساهمين في المشروع
- شكر لمستخدمي التطبيق على ملاحظاتهم القيمة

## 📈 الإحصائيات

- ✅ **+15 ميزة** مكتملة
- 🧪 **+50 اختبار** شامل
- 🌍 **2 لغة** مدعومة
- 📱 **Android & iOS** متوافق

## 🔄 التحديثات المستقبلية

### الإصدار القادم (v1.1.0)
- [ ] إضافة المزيد من الأذكار
- [ ] تحسين الأداء
- [ ] إضافة ميزة المشاركة
- [ ] دعم المزيد من اللغات

### الإصدار المستقبلي (v2.0.0)
- [ ] إعادة تصميم كاملة
- [ ] ميزات ذكية بالذكاء الاصطناعي
- [ ] مزامنة السحابة
- [ ] تطبيق ويب

---

<div align="center">
  <p>صُنع بـ ❤️ للمجتمع الإسلامي</p>
  <p>© 2024 Professional Muslim App. جميع الحقوق محفوظة.</p>
</div>
