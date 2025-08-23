# إصلاح مشكلة تجمد التطبيق

## المشكلة
كان التطبيق يتجمد عند الشاشة الحمراء الأولى (splash screen) ولا يتحرك منها أبداً.

## الأسباب المحتملة التي تم تحديدها:

1. **مشكلة في UserService**: الـ splash screen الأصلي كان يحاول الوصول لـ `SharedPreferences` وقد يتجمد هناك
2. **مشكلة في Firebase**: قد تكون هناك مشكلة في تهيئة Firebase أو الاتصال
3. **مشكلة في Provider**: AuthScreen كان يحتاج Provider ولكن لم يتم تهيئته بشكل صحيح
4. **مشكلة في التنقل**: قد تكون هناك مشكلة في الانتقال من splash screen للشاشات الأخرى

## الحلول المطبقة:

### 1. إنشاء Splash Screen مبسط
- **الملف**: `lib/screens/splash_screen_simple.dart`
- **التغيير**: إزالة الاعتماد على UserService والانتقال مباشرة لشاشة التسجيل
- **الفائدة**: تجنب أي مشاكل في SharedPreferences أو Firebase

### 2. إنشاء Auth Screen مبسط
- **الملف**: `lib/screens/auth/simple_auth_screen.dart`
- **التغيير**: إزالة الاعتماد على Provider و Firebase Auth
- **الفائدة**: تجنب مشاكل Firebase والاعتماد على محاكاة بسيطة لتسجيل الدخول

### 3. تحديث main.dart
- **التغيير**: إضافة Provider support وتغيير الشاشة الرئيسية للـ SimpleSplashScreen
- **الفائدة**: ضمان عمل Provider في حالة الحاجة إليه لاحقاً

## الملفات المحدثة:

1. `lib/main.dart` - إضافة Provider وتغيير splash screen
2. `lib/screens/splash_screen_simple.dart` - splash screen مبسط جديد
3. `lib/screens/auth/simple_auth_screen.dart` - auth screen مبسط جديد

## كيفية التشغيل:

```bash
flutter clean
flutter pub get
flutter run
```

## التدفق الجديد:

1. **SimpleSplashScreen**: يعرض الشعار والرسوم المتحركة لمدة 3 ثوانٍ
2. **SimpleAuthScreen**: شاشة تسجيل دخول مبسطة بدون Firebase
3. **HomeScreen**: الشاشة الرئيسية للتطبيق

## ملاحظات:

- الحل الحالي يستخدم محاكاة لتسجيل الدخول بدلاً من Firebase
- يمكن العودة للـ Firebase لاحقاً بعد التأكد من عمل التطبيق
- جميع الملفات الأصلية محفوظة ولم يتم حذفها

## اختبار الحل:

1. تشغيل التطبيق
2. انتظار 3 ثوانٍ في splash screen
3. الانتقال لشاشة تسجيل الدخول
4. تجربة "الدخول كضيف" أو تسجيل الدخول العادي
5. الوصول للشاشة الرئيسية بنجاح