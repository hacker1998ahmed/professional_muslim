# دليل المساهمة - Professional Muslim App

نرحب بمساهماتكم في تطوير تطبيق أذكار المسلم المحترف! 🎉

## 🌟 كيفية المساهمة

### أنواع المساهمات المرحب بها

1. **🐛 إبلاغ عن الأخطاء**
2. **💡 اقتراح ميزات جديدة**
3. **📝 تحسين التوثيق**
4. **🔧 إصلاح الأخطاء**
5. **✨ إضافة ميزات جديدة**
6. **🌍 الترجمة**
7. **🎨 تحسين التصميم**
8. **📖 مراجعة المحتوى الديني**

## 🚀 البدء السريع

### 1. إعداد البيئة التطويرية

```bash
# استنساخ المشروع
git clone https://github.com/your-username/professional_muslim.git
cd professional_muslim

# تثبيت الاعتمادات
flutter pub get

# تشغيل التطبيق
flutter run
```

### 2. هيكل المشروع

قبل المساهمة، تأكد من فهم [هيكل المشروع](docs/DEVELOPER_GUIDE.md#-هيكل-المجلدات-التفصيلي).

## 📋 عملية المساهمة

### 1. إنشاء Issue

قبل البدء في أي عمل، أنشئ Issue لمناقشة:
- وصف المشكلة أو الميزة المقترحة
- الحل المقترح
- أي تفاصيل تقنية مهمة

### 2. Fork والاستنساخ

```bash
# Fork المشروع على GitHub
# ثم استنسخ fork الخاص بك
git clone https://github.com/YOUR-USERNAME/professional_muslim.git
cd professional_muslim

# إضافة المشروع الأصلي كـ upstream
git remote add upstream https://github.com/original-username/professional_muslim.git
```

### 3. إنشاء Branch جديد

```bash
# إنشاء branch جديد للميزة أو الإصلاح
git checkout -b feature/amazing-feature
# أو
git checkout -b fix/bug-description
```

### 4. التطوير

#### قواعد الكود
- اتبع [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- استخدم أسماء متغيرات واضحة ومعبرة
- أضف تعليقات للكود المعقد
- اكتب كود قابل للقراءة والصيانة

#### مثال على كود جيد:
```dart
/// حساب الوقت المتبقي للصلاة التالية
Duration? calculateTimeUntilNextPrayer() {
  final nextPrayer = getNextPrayer();
  if (nextPrayer == null) return null;
  
  final now = DateTime.now();
  return nextPrayer.time.difference(now);
}
```

### 5. الاختبار

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/providers/azkar_provider_test.dart

# تحليل الكود
flutter analyze
```

### 6. Commit والـ Push

```bash
# إضافة التغييرات
git add .

# Commit مع رسالة واضحة
git commit -m "feat: إضافة ميزة حساب الوقت المتبقي للصلاة"

# Push للـ branch
git push origin feature/amazing-feature
```

### 7. إنشاء Pull Request

1. اذهب لصفحة GitHub الخاصة بك
2. اضغط "New Pull Request"
3. اختر الـ branch المناسب
4. اكتب وصف واضح للتغييرات
5. اربط الـ PR بالـ Issue المناسب

## 📝 معايير الكود

### التنسيق
```bash
# تنسيق الكود تلقائياً
dart format .

# أو في VS Code
Shift + Alt + F
```

### التسمية
- **Classes**: `PascalCase` (مثل `AzkarProvider`)
- **Variables/Functions**: `camelCase` (مثل `getCurrentPrayer`)
- **Constants**: `UPPER_SNAKE_CASE` (مثل `MAX_AZKAR_COUNT`)
- **Files**: `snake_case` (مثل `azkar_provider.dart`)

### التعليقات
```dart
/// وصف مختصر للدالة
/// 
/// [parameter] وصف المعامل
/// Returns وصف القيمة المرجعة
String formatPrayerTime(DateTime time) {
  // تعليق داخلي للكود المعقد
  return DateFormat('HH:mm').format(time);
}
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
testWidgets('should display prayer times', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(home: PrayerTimesScreen()),
  );
  
  expect(find.text('مواقيت الصلاة'), findsOneWidget);
});
```

## 🌍 الترجمة

### إضافة لغة جديدة

1. **أضف اللغة في `app_localizations.dart`**:
```dart
static const List<Locale> supportedLocales = [
  Locale('ar', ''),
  Locale('en', ''),
  Locale('fr', ''), // اللغة الجديدة
];
```

2. **أضف الترجمات**:
```dart
static const Map<String, Map<String, String>> _localizedValues = {
  'fr': {
    'app_title': 'Azkar Musulman',
    'home': 'Accueil',
    // ... باقي الترجمات
  },
};
```

## 📖 مراجعة المحتوى الديني

### معايير المحتوى الديني
- **المصادر الموثوقة**: استخدم مصادر معتمدة فقط
- **الدقة**: تأكد من صحة النقل
- **المراجع**: أضف المرجع لكل ذكر أو دعاء
- **التشكيل**: تأكد من صحة التشكيل

### مثال على إضافة ذكر جديد:
```json
{
  "text": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
  "description": "تسبيح وحمد",
  "count": 100,
  "reference": "صحيح مسلم (2692)",
  "benefit": "من قالها في يوم مائة مرة حُطَّت خطاياه وإن كانت مثل زبد البحر"
}
```

## 🎨 تحسين التصميم

### معايير التصميم
- **Material Design**: اتبع مبادئ Material Design 3
- **الألوان**: استخدم نظام الألوان الموحد
- **الخطوط**: استخدم خط Amiri للنصوص العربية
- **الاستجابة**: تأكد من التوافق مع جميع أحجام الشاشات

## 🐛 إبلاغ عن الأخطاء

### معلومات مطلوبة
- **وصف المشكلة**: وصف واضح ومفصل
- **خطوات الإعادة**: كيفية إعادة إنتاج المشكلة
- **السلوك المتوقع**: ما كان يجب أن يحدث
- **السلوك الفعلي**: ما حدث فعلاً
- **البيئة**: نظام التشغيل، إصدار Flutter، إلخ
- **لقطات الشاشة**: إذا كانت مفيدة

### قالب Issue للأخطاء
```markdown
## وصف المشكلة
وصف واضح ومختصر للمشكلة.

## خطوات الإعادة
1. اذهب إلى '...'
2. اضغط على '...'
3. انتقل إلى '...'
4. شاهد الخطأ

## السلوك المتوقع
وصف واضح لما كان متوقعاً أن يحدث.

## لقطات الشاشة
إذا كانت مناسبة، أضف لقطات شاشة لتوضيح المشكلة.

## معلومات البيئة:
- نظام التشغيل: [مثل iOS 15.0]
- إصدار التطبيق: [مثل 1.0.0]
- الجهاز: [مثل iPhone 12]
```

## 💡 اقتراح الميزات

### قالب Issue للميزات
```markdown
## ملخص الميزة
وصف مختصر للميزة المقترحة.

## المشكلة المحلولة
وصف المشكلة التي تحلها هذه الميزة.

## الحل المقترح
وصف تفصيلي للحل المقترح.

## البدائل المدروسة
وصف أي حلول بديلة تم النظر فيها.

## معلومات إضافية
أي معلومات أخرى مفيدة حول الميزة.
```

## 📞 التواصل

- **GitHub Issues**: للأخطاء والميزات
- **البريد الإلكتروني**: gogom8870@gmail.com
- **الهاتف**: 01225155329

## 🙏 شكر وتقدير

شكراً لكم على اهتمامكم بالمساهمة في هذا المشروع الخيري. مساهمتكم تساعد في خدمة المسلمين حول العالم.

جزاكم الله خيراً! 🤲

---

**ملاحظة**: هذا المشروع يهدف لخدمة الإسلام والمسلمين، لذا نرجو الالتزام بالآداب الإسلامية في التعامل والمحتوى.
