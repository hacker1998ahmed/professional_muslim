# دليل المطور - Professional Muslim App

## 📋 نظرة عامة

هذا الدليل مخصص للمطورين الذين يريدون فهم بنية التطبيق والمساهمة في تطويره.

## 🏗️ معمارية التطبيق

### نمط المعمارية
يستخدم التطبيق نمط **Provider Pattern** مع **Clean Architecture** لضمان:
- فصل الاهتمامات (Separation of Concerns)
- سهولة الاختبار (Testability)
- قابلية الصيانة (Maintainability)
- قابلية التوسع (Scalability)

### طبقات التطبيق

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│         (Screens & Widgets)         │
├─────────────────────────────────────┤
│            Business Layer           │
│            (Providers)              │
├─────────────────────────────────────┤
│             Data Layer              │
│        (Models & Services)          │
└─────────────────────────────────────┘
```

## 📁 هيكل المجلدات التفصيلي

### `/lib/core/`
يحتوي على الأساسيات المشتركة:

```dart
core/
├── constants/
│   ├── app_constants.dart      // ثوابت التطبيق
│   ├── colors.dart            // ألوان التطبيق
│   └── strings.dart           // النصوص الثابتة
├── theme/
│   ├── app_theme.dart         // إعدادات الثيم
│   └── text_styles.dart       // أنماط النصوص
├── utils/
│   ├── date_utils.dart        // أدوات التاريخ
│   ├── math_utils.dart        // أدوات الرياضيات
│   └── performance_utils.dart  // أدوات الأداء
└── state/
    └── app_state_manager.dart  // إدارة الحالة المركزية
```

### `/lib/providers/`
مزودي الحالة للتطبيق:

```dart
providers/
├── azkar_provider.dart         // إدارة الأذكار
├── prayer_times_provider.dart  // إدارة مواقيت الصلاة
├── theme_provider.dart         // إدارة الثيم
├── language_provider.dart      // إدارة اللغة
├── fasting_provider.dart       // إدارة الصيام
├── quran_provider.dart         // إدارة القرآن
└── inheritance_provider.dart   // إدارة المواريث
```

### `/lib/models/`
نماذج البيانات:

```dart
models/
├── azkar.dart                  // نموذج الأذكار
├── prayer_times.dart          // نموذج مواقيت الصلاة
├── fasting_tracker.dart       // نموذج تتبع الصيام
├── quran_memorization.dart     // نموذج حفظ القرآن
├── quran_page.dart            // نموذج صفحة القرآن
├── zakat_calculator.dart       // نموذج حاسبة الزكاة
└── inheritance_calculator.dart // نموذج حاسبة المواريث
```

## 🔧 إدارة الحالة

### استخدام Provider

```dart
// في main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AzkarProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    // ... المزيد من المزودات
  ],
  child: MyApp(),
)

// في الويجت
Consumer<AzkarProvider>(
  builder: (context, provider, child) {
    return Text(provider.someData);
  },
)

// أو
final provider = context.watch<AzkarProvider>();
```

### أفضل الممارسات

1. **استخدم `context.watch()` للاستماع للتغييرات**
2. **استخدم `context.read()` لاستدعاء الطرق**
3. **تجنب استخدام Provider في `initState()`**
4. **استخدم `Consumer` للأجزاء التي تحتاج إعادة بناء**

## 🎨 إدارة الثيمات

### إنشاء ثيم جديد

```dart
// في theme_provider.dart
ThemeData get customTheme {
  return ThemeData(
    primaryColor: Colors.green,
    colorScheme: ColorScheme.light(
      primary: Colors.green,
      secondary: Colors.green[300]!,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Amiri',
      ),
    ),
  );
}
```

### استخدام الألوان

```dart
// الحصول على اللون الأساسي
final primaryColor = Theme.of(context).primaryColor;

// الحصول على لون من ColorScheme
final surfaceColor = Theme.of(context).colorScheme.surface;
```

## 🌍 إدارة الترجمة

### إضافة نص جديد

1. **أضف النص في `app_localizations.dart`:**

```dart
String get newText => _localizedValues[locale.languageCode]!['new_text']!;
```

2. **أضف الترجمات:**

```dart
static const Map<String, Map<String, String>> _localizedValues = {
  'ar': {
    'new_text': 'النص الجديد',
  },
  'en': {
    'new_text': 'New Text',
  },
};
```

3. **استخدم النص في الويجت:**

```dart
Text(AppLocalizations.of(context)!.newText)
```

## 📊 إدارة البيانات

### حفظ البيانات محلياً

```dart
// حفظ بيانات بسيطة
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', 'value');

// حفظ كائن JSON
final jsonString = jsonEncode(object.toJson());
await prefs.setString('object_key', jsonString);
```

### تحميل البيانات من Assets

```dart
// تحميل ملف JSON
final String response = await rootBundle.loadString('assets/data/file.json');
final data = json.decode(response);
```

## 🧪 كتابة الاختبارات

### اختبار Provider

```dart
testWidgets('should increment tasbih count', (WidgetTester tester) async {
  final provider = AzkarProvider();
  
  await provider.incrementTasbih();
  
  expect(provider.tasbihCount, 1);
});
```

### اختبار Widget

```dart
testWidgets('should display correct title', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MyWidget(),
    ),
  );
  
  expect(find.text('Expected Title'), findsOneWidget);
});
```

## 🚀 تحسين الأداء

### نصائح الأداء

1. **استخدم `const` للويجتس الثابتة**
2. **تجنب بناء ويجتس معقدة في `build()`**
3. **استخدم `ListView.builder()` للقوائم الطويلة**
4. **استخدم `RepaintBoundary` للويجتس المعقدة**

### مثال على التحسين

```dart
// بدلاً من
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// استخدم
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

## 🔍 تتبع الأخطاء

### معالجة الأخطاء

```dart
try {
  await someAsyncOperation();
} catch (e) {
  debugPrint('Error: $e');
  // معالجة الخطأ
  setError('حدث خطأ: ${e.toString()}');
}
```

### تسجيل الأحداث

```dart
// في وضع التطوير فقط
if (kDebugMode) {
  debugPrint('Debug info: $info');
}
```

## 📱 بناء التطبيق

### للتطوير

```bash
flutter run --debug
```

### للاختبار

```bash
flutter run --profile
```

### للإنتاج

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔧 أدوات التطوير

### أدوات مفيدة

1. **Flutter Inspector** - لفحص الويجت تري
2. **Dart DevTools** - لتتبع الأداء
3. **Flutter Outline** - لرؤية هيكل الكود

### إعدادات VS Code المفيدة

```json
{
  "dart.flutterHotReloadOnSave": "always",
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
```

## 📋 قائمة المراجعة قبل الكوميت

- [ ] تشغيل `flutter analyze`
- [ ] تشغيل جميع الاختبارات
- [ ] التأكد من عدم وجود TODO في الكود
- [ ] مراجعة الكود للتأكد من الجودة
- [ ] تحديث التوثيق إذا لزم الأمر

## 🤝 إرشادات المساهمة

1. **اتبع نمط الكود الموجود**
2. **اكتب اختبارات للكود الجديد**
3. **أضف توثيق للطرق العامة**
4. **استخدم أسماء متغيرات واضحة**
5. **تجنب الكود المكرر**

---

للمزيد من المعلومات، راجع [README.md](../README.md) أو تواصل مع فريق التطوير.
