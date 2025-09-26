# 📚 التوثيق الشامل لمشروع Gizmo Store

## 📋 جدول المحتويات

1. [نظرة عامة على المشروع](#نظرة-عامة-على-المشروع)
2. [هيكل المشروع](#هيكل-المشروع)
3. [الواجهات والنظم الفرعية](#الواجهات-والنظم-الفرعية)
4. [التعليمات التشغيلية](#التعليمات-التشغيلية)
5. [دليل المطور](#دليل-المطور)

---

# 5. دليل المطور

## 👨‍💻 إرشادات المساهمة في المشروع

### 🔧 إعداد بيئة التطوير

#### الخطوات الأساسية:

1. **استنساخ المشروع**
   ```bash
   git clone https://github.com/your-username/gizmo_store.git
   cd gizmo_store
   ```

2. **تثبيت التبعيات**
   ```bash
   flutter pub get
   ```

3. **إعداد Firebase**
   - إنشاء مشروع Firebase جديد
   - تحميل ملفات التكوين (`google-services.json` للأندرويد، `GoogleService-Info.plist` للـ iOS)
   - تفعيل خدمات Authentication و Firestore

4. **تشغيل المشروع**
   ```bash
   flutter run
   ```

### 📋 معايير كتابة الأكواد

#### 1. **تسمية الملفات والمجلدات**

```dart
// ✅ صحيح - استخدام snake_case للملفات
home_screen.dart
product_service.dart
user_model.dart

// ❌ خطأ - تجنب camelCase أو PascalCase للملفات
HomeScreen.dart
productService.dart
```

#### 2. **تسمية الفئات والمتغيرات**

```dart
// ✅ صحيح - PascalCase للفئات
class ProductService {
  // ✅ صحيح - camelCase للمتغيرات والدوال
  String productName;
  int productPrice;
  
  void addProduct() {
    // Implementation
  }
}

// ✅ صحيح - SCREAMING_SNAKE_CASE للثوابت
class AppConstants {
  static const String API_BASE_URL = 'https://api.example.com';
  static const int MAX_RETRY_COUNT = 3;
}
```

#### 3. **هيكلة الكود**

```dart
// ✅ مثال على هيكلة فئة صحيحة
class ProductScreen extends StatefulWidget {
  // 1. الثوابت أولاً
  static const String routeName = '/products';
  
  // 2. المتغيرات النهائية
  final String categoryId;
  
  // 3. البناء
  const ProductScreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // 1. المتغيرات الخاصة
  List<Product> _products = [];
  bool _isLoading = false;
  
  // 2. دورة حياة الويدجت
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  // 3. الدوال الخاصة
  Future<void> _loadProducts() async {
    // Implementation
  }
  
  // 4. دالة البناء
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI Implementation
    );
  }
}
```

#### 4. **التعليقات والتوثيق**

```dart
/// خدمة إدارة المنتجات
/// 
/// تتولى هذه الفئة جميع العمليات المتعلقة بالمنتجات
/// مثل الجلب، الإضافة، التحديث، والحذف
class ProductService {
  
  /// جلب جميع المنتجات من قاعدة البيانات
  /// 
  /// [limit] عدد المنتجات المطلوب جلبها (افتراضي: 10)
  /// [category] فئة المنتجات (اختياري)
  /// 
  /// Returns: قائمة بالمنتجات أو قائمة فارغة في حالة الخطأ
  Future<List<Product>> getProducts({
    int limit = 10,
    String? category,
  }) async {
    try {
      // TODO: تنفيذ جلب المنتجات من Firestore
      return [];
    } catch (e) {
      // FIXME: إضافة معالجة أفضل للأخطاء
      print('Error fetching products: $e');
      return [];
    }
  }
}
```

#### 5. **معالجة الأخطاء**

```dart
// ✅ معالجة صحيحة للأخطاء
Future<List<Product>> fetchProducts() async {
  try {
    final response = await _firestore
        .collection('products')
        .limit(10)
        .get();
    
    return response.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList();
        
  } on FirebaseException catch (e) {
    // معالجة أخطاء Firebase المحددة
    _logger.error('Firebase error: ${e.message}');
    throw ProductServiceException('فشل في جلب المنتجات: ${e.message}');
    
  } catch (e) {
    // معالجة الأخطاء العامة
    _logger.error('Unexpected error: $e');
    throw ProductServiceException('حدث خطأ غير متوقع');
  }
}
```

### 🏗️ إضافة ميزات جديدة

#### 1. **إضافة شاشة جديدة**

```dart
// 1. إنشاء ملف الشاشة في lib/screens/
// lib/screens/new_feature_screen.dart

class NewFeatureScreen extends StatefulWidget {
  static const String routeName = '/new-feature';
  
  const NewFeatureScreen({Key? key}) : super(key: key);

  @override
  State<NewFeatureScreen> createState() => _NewFeatureScreenState();
}

class _NewFeatureScreenState extends State<NewFeatureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزة الجديدة'),
      ),
      body: const Center(
        child: Text('محتوى الميزة الجديدة'),
      ),
    );
  }
}

// 2. إضافة المسار في lib/main.dart
MaterialApp(
  routes: {
    // المسارات الموجودة...
    NewFeatureScreen.routeName: (context) => const NewFeatureScreen(),
  },
)
```

#### 2. **إضافة نموذج بيانات جديد**

```dart
// lib/models/new_model.dart

class NewModel {
  final String id;
  final String name;
  final DateTime createdAt;
  
  const NewModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  /// إنشاء نموذج من بيانات Firestore
  factory NewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return NewModel(
      id: doc.id,
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  
  /// تحويل النموذج إلى Map للحفظ في Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  
  /// إنشاء نسخة محدثة من النموذج
  NewModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return NewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

#### 3. **إضافة خدمة جديدة**

```dart
// lib/services/new_service.dart

class NewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'new_collection';
  
  /// جلب جميع العناصر
  Future<List<NewModel>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => NewModel.fromFirestore(doc))
          .toList();
          
    } catch (e) {
      throw Exception('فشل في جلب البيانات: $e');
    }
  }
  
  /// إضافة عنصر جديد
  Future<String> add(NewModel item) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(item.toFirestore());
      
      return docRef.id;
      
    } catch (e) {
      throw Exception('فشل في إضافة العنصر: $e');
    }
  }
}
```

### 🧪 الاختبارات

#### 1. **اختبارات الوحدة**

```dart
// test/services/product_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:gizmo_store/services/product_service.dart';

void main() {
  group('ProductService Tests', () {
    late ProductService productService;
    
    setUp(() {
      productService = ProductService();
    });
    
    test('should return list of products', () async {
      // Arrange
      const expectedCount = 10;
      
      // Act
      final products = await productService.getProducts(limit: expectedCount);
      
      // Assert
      expect(products, isA<List<Product>>());
      expect(products.length, lessThanOrEqualTo(expectedCount));
    });
  });
}
```

#### 2. **اختبارات الويدجت**

```dart
// test/screens/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizmo_store/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen should display app bar', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    
    // Assert
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Gizmo Store'), findsOneWidget);
  });
}
```

### 📱 إرشادات التصميم

#### 1. **استخدام الألوان**

```dart
// lib/constants/app_colors.dart

class AppColors {
  // الألوان الأساسية
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFFFF9800);
  
  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  
  // ألوان النص
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

// الاستخدام في الكود
Container(
  color: AppColors.primary,
  child: Text(
    'نص',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

#### 2. **استخدام المسافات**

```dart
// lib/constants/app_sizes.dart

class AppSizes {
  // المسافات
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  
  // أحجام الخطوط
  static const double fontSmall = 12.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 20.0;
  static const double fontXLarge = 24.0;
}
```

### 🔄 سير العمل (Workflow)

#### 1. **إنشاء فرع جديد**

```bash
# إنشاء فرع للميزة الجديدة
git checkout -b feature/new-feature-name

# أو إنشاء فرع لإصلاح خطأ
git checkout -b fix/bug-description
```

#### 2. **تطوير الميزة**

```bash
# إضافة التغييرات
git add .

# إنشاء commit مع رسالة واضحة
git commit -m "feat: إضافة ميزة البحث المتقدم"

# أو لإصلاح خطأ
git commit -m "fix: إصلاح مشكلة تحميل المنتجات"
```

#### 3. **اختبار التغييرات**

```bash
# تشغيل الاختبارات
flutter test

# تشغيل تحليل الكود
flutter analyze

# تنسيق الكود
dart format .
```

#### 4. **دمج التغييرات**

```bash
# رفع الفرع إلى المستودع
git push origin feature/new-feature-name

# إنشاء Pull Request
# مراجعة الكود
# دمج الفرع بعد الموافقة
```

### 📚 الموارد والمراجع

#### 1. **التوثيق الرسمي**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Guide](https://dart.dev/guides)

#### 2. **أفضل الممارسات**
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Firebase Best Practices](https://firebase.google.com/docs/guides)

#### 3. **أدوات مفيدة**
- **VS Code Extensions**: Flutter, Dart, Firebase
- **Android Studio Plugins**: Flutter, Dart
- **التحليل**: `flutter analyze`
- **التنسيق**: `dart format`
- **الاختبار**: `flutter test`

### 🐛 استكشاف الأخطاء وإصلاحها

#### 1. **مشاكل شائعة**

```dart
// مشكلة: خطأ في تحميل الصور
// الحل: التحقق من صحة الرابط واستخدام placeholder
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)

// مشكلة: بطء في تحميل البيانات
// الحل: استخدام pagination
Query query = FirebaseFirestore.instance
    .collection('products')
    .limit(10); // تحديد عدد العناصر

// مشكلة: تسريب الذاكرة
// الحل: التخلص من controllers
@override
void dispose() {
  _scrollController.dispose();
  _searchController.dispose();
  super.dispose();
}
```

#### 2. **أدوات التشخيص**

```bash
# فحص أداء التطبيق
flutter run --profile

# تحليل حجم التطبيق
flutter build apk --analyze-size

# فحص التبعيات
flutter pub deps
```

### 🚀 النشر والتوزيع

#### 1. **بناء التطبيق للإنتاج**

```bash
# بناء للأندرويد
flutter build apk --release

# بناء للويب
flutter build web --release

# بناء للـ iOS (على macOS فقط)
flutter build ios --release
```

#### 2. **إعداد متغيرات البيئة**

```dart
// lib/config/environment.dart

class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.gizmostore.com',
  );
  
  static const bool isProduction = bool.fromEnvironment(
    'PRODUCTION',
    defaultValue: false,
  );
}
```

---

**🎯 ملاحظة**: هذا التوثيق يُحدث باستمرار مع تطوير المشروع. للحصول على أحدث المعلومات، يُرجى مراجعة الملفات المصدرية والتوثيق المرفق.

## 🎯 نظرة عامة على المشروع

### الغرض من المشروع والأهداف الرئيسية

**Gizmo Store** هو تطبيق متجر إلكتروني متكامل مطور باستخدام تقنية Flutter، يهدف إلى توفير تجربة تسوق إلكتروني حديثة وسلسة للمستخدمين. يركز المشروع على تقديم حلول تقنية متقدمة في مجال التجارة الإلكترونية مع التركيز على تجربة المستخدم والأداء العالي.

#### الأهداف الرئيسية:

1. **تطوير منصة تجارة إلكترونية شاملة**
   - توفير جميع الوظائف الأساسية للتسوق الإلكتروني
   - دعم عمليات البيع والشراء بطريقة آمنة وموثوقة
   - إدارة المخزون والمنتجات بكفاءة

2. **تحسين تجربة المستخدم (UX/UI)**
   - تصميم واجهات مستخدم بديهية وجذابة
   - توفير تنقل سلس بين الشاشات المختلفة
   - دعم اللغة العربية والإنجليزية

3. **تطبيق أفضل الممارسات التقنية**
   - استخدام معمارية نظيفة ومنظمة
   - تطبيق مبادئ البرمجة الحديثة
   - ضمان الأمان وحماية البيانات

4. **التوافق مع المنصات المتعددة**
   - دعم أنظمة Android و iOS
   - إمكانية التشغيل على الويب
   - تصميم متجاوب مع جميع أحجام الشاشات

### الفئة المستهدفة والمستخدمون النهائيون

#### المستخدمون الأساسيون:

1. **المتسوقون الأفراد**
   - الأشخاص الذين يبحثون عن منتجات إلكترونية عالية الجودة
   - المستخدمون الذين يفضلون التسوق الإلكتروني للراحة والسهولة
   - العملاء الذين يقدرون التجربة التفاعلية والتصميم الحديث

2. **عشاق التكنولوجيا**
   - المهتمون بأحدث الأجهزة الإلكترونية والتقنيات
   - المستخدمون الذين يبحثون عن مواصفات تفصيلية للمنتجات
   - الأشخاص الذين يقارنون بين المنتجات قبل الشراء

3. **المستخدمون من مختلف الأعمار**
   - الشباب والبالغون الذين يستخدمون الهواتف الذكية
   - المستخدمون الذين يفضلون التطبيقات سهلة الاستخدام
   - العملاء الذين يقدرون الدعم متعدد اللغات

#### الخصائص الديموغرافية:

- **العمر**: 18-65 سنة
- **المستوى التقني**: متوسط إلى متقدم
- **الاهتمامات**: التكنولوجيا، التسوق الإلكتروني، الأجهزة الذكية
- **السلوك**: يفضلون التسوق عبر التطبيقات المحمولة

### التقنيات واللغات المستخدمة في المشروع

#### التقنيات الأساسية:

1. **Flutter Framework**
   - **الإصدار**: 3.16.9+
   - **اللغة**: Dart 3.2.6+
   - **المنصات المدعومة**: Android, iOS, Web
   - **السبب**: تطوير متعدد المنصات بكود واحد، أداء عالي، واجهات مستخدم غنية

2. **Firebase Backend Services**
   - **Firebase Core**: إدارة التطبيق والإعدادات الأساسية
   - **Cloud Firestore**: قاعدة بيانات NoSQL للمنتجات والطلبات
   - **Firebase Auth**: نظام المصادقة وإدارة المستخدمين
   - **Firebase Storage**: تخزين الصور والملفات
   - **Firebase Messaging**: الإشعارات الفورية

3. **إدارة الحالة (State Management)**
   - **Provider Pattern**: لإدارة حالة التطبيق بكفاءة
   - **ChangeNotifier**: للتحديثات التفاعلية للواجهات

#### المكتبات والحزم المستخدمة:

1. **واجهة المستخدم والتصميم**
   ```yaml
   cupertino_icons: ^1.0.2          # أيقونات iOS
   cached_network_image: ^3.4.1     # تحميل وتخزين الصور مؤقتاً
   ```

2. **التدويل والترجمة**
   ```yaml
   flutter_localizations: sdk: flutter  # دعم اللغات المتعددة
   intl: ^0.20.2                        # تنسيق التواريخ والأرقام
   ```

3. **التخزين المحلي**
   ```yaml
   shared_preferences: ^2.5.3       # تخزين الإعدادات محلياً
   ```

4. **Firebase UI Components**
   ```yaml
   firebase_ui_firestore: ^1.6.5    # واجهات جاهزة لـ Firestore
   firebase_ui_auth: ^1.15.0        # واجهات المصادقة الجاهزة
   ```

5. **الإشعارات والوسائط**
   ```yaml
   flutter_local_notifications: ^17.2.3  # الإشعارات المحلية
   image_picker: ^1.0.4                  # اختيار الصور
   permission_handler: ^11.3.1           # إدارة الأذونات
   ```

6. **خدمات السحابة**
   ```yaml
   cloudinary_public: ^0.21.0       # إدارة الصور السحابية
   ```

#### معمارية التطبيق:

1. **Model-View-Provider (MVP)**
   - **Models**: تمثيل البيانات (Product, User, Order, etc.)
   - **Views**: الواجهات والشاشات
   - **Providers**: إدارة الحالة والمنطق التجاري

2. **Clean Architecture Principles**
   - فصل الطبقات والمسؤوليات
   - سهولة الاختبار والصيانة
   - قابلية التوسع والتطوير

3. **Responsive Design**
   - تصميم متجاوب مع جميع أحجام الشاشات
   - دعم الاتجاهين العمودي والأفقي
   - تحسين للأجهزة اللوحية والهواتف

#### أدوات التطوير:

1. **بيئة التطوير**
   - Android Studio / VS Code
   - Flutter SDK
   - Dart SDK

2. **إدارة الإصدارات**
   - Git للتحكم في الإصدارات
   - GitHub للاستضافة والتعاون

3. **الاختبار والنشر**
   - Flutter Test للاختبارات الوحدة
   - Firebase Hosting للنشر على الويب
   - Google Play Store / App Store للنشر على المتاجر

---

# 2. هيكل المشروع

## 📁 البنية العامة للمشروع

```
gizmo_store/
├── android/                    # إعدادات Android
│   ├── app/
│   │   ├── google-services.json    # إعدادات Firebase للأندرويد
│   │   └── build.gradle            # إعدادات البناء
│   └── gradle/                     # إعدادات Gradle
├── ios/                        # إعدادات iOS
├── lib/                        # الكود الرئيسي للتطبيق
│   ├── constants/              # الثوابت والقيم الثابتة
│   ├── l10n/                   # ملفات الترجمة والتدويل
│   ├── models/                 # نماذج البيانات
│   ├── providers/              # مزودي الحالة (State Management)
│   ├── screens/                # شاشات التطبيق
│   ├── services/               # خدمات التطبيق
│   ├── utils/                  # أدوات مساعدة
│   ├── widgets/                # مكونات واجهة المستخدم
│   ├── main.dart               # نقطة البداية الرئيسية
│   ├── routes.dart             # إعدادات التنقل
│   └── firebase_options.dart   # إعدادات Firebase
├── web/                        # إعدادات الويب
├── pubspec.yaml               # تبعيات المشروع
├── firebase.json              # إعدادات Firebase
├── firestore.rules           # قواعد Firestore
└── README.md                 # دليل المشروع
```

## 📂 تفصيل المجلدات الرئيسية

### 🎯 مجلد `lib/` - الكود الرئيسي

#### 📋 `constants/` - الثوابت
- **app_colors.dart**: ألوان التطبيق الموحدة
- **app_spacing.dart**: المسافات والأبعاد
- **app_animations.dart**: إعدادات الحركات والانتقالات
- **app_buttons.dart**: أنماط الأزرار الموحدة
- **app_cards.dart**: أنماط البطاقات
- **app_navigation.dart**: إعدادات التنقل

#### 🌐 `l10n/` - التدويل والترجمة
- **app_en.arb**: النصوص الإنجليزية (1701 سطر)
- **app_ar.arb**: النصوص العربية (1109 سطر)
- **app_localizations.dart**: فئة التدويل المولدة تلقائياً

#### 📊 `models/` - نماذج البيانات
- **product.dart**: نموذج المنتج مع خصائص شاملة
- **cart_item.dart**: عنصر السلة
- **order.dart**: نموذج الطلب
- **user_model.dart**: نموذج المستخدم
- **address.dart**: نموذج العنوان
- **category.dart**: نموذج الفئة
- **dashboard_stats.dart**: إحصائيات لوحة التحكم

#### 🔄 `providers/` - إدارة الحالة
- **cart_provider.dart**: إدارة حالة السلة (72 سطر)
- **auth_provider.dart**: إدارة حالة المصادقة
- **wishlist_provider.dart**: إدارة المفضلة
- **theme_provider.dart**: إدارة السمة
- **language_provider.dart**: إدارة اللغة
- **search_provider.dart**: إدارة البحث
- **checkout_provider.dart**: إدارة عملية الشراء

#### 🖥️ `screens/` - شاشات التطبيق
##### الشاشات الرئيسية:
- **home/home_screen.dart**: الشاشة الرئيسية (742 سطر)
- **product/product_detail_screen.dart**: تفاصيل المنتج (543 سطر)
- **cart/cart_screen.dart**: شاشة السلة
- **auth/auth_screen.dart**: شاشة المصادقة
- **profile/profile_screen.dart**: الملف الشخصي
- **order/orders_screen.dart**: شاشة الطلبات (856 سطر)
- **search/search_screen.dart**: شاشة البحث
- **categories_screen.dart**: شاشة الفئات (582 سطر)
- **wishlist/wishlist_screen.dart**: شاشة المفضلة (516 سطر)

##### شاشات إدارية:
- **admin/admin_panel.dart**: لوحة التحكم الإدارية
- **admin/add_product_screen.dart**: إضافة منتج
- **admin/manage_products_screen.dart**: إدارة المنتجات

##### شاشات الإعدادات:
- **settings_screen.dart**: الإعدادات العامة (445 سطر)
- **edit_profile_screen.dart**: تعديل الملف الشخصي
- **security_settings_screen.dart**: إعدادات الأمان

#### ⚙️ `services/` - طبقة الخدمات
- **firestore_service.dart**: خدمة قاعدة البيانات (663 سطر)
- **auth_service.dart**: خدمة المصادقة (75 سطر)
- **firebase_auth_service.dart**: خدمة Firebase Auth المتقدمة
- **cart_service.dart**: خدمة السلة
- **product_service.dart**: خدمة المنتجات
- **database_setup_service.dart**: إعداد قاعدة البيانات
- **sample_data_service.dart**: بيانات تجريبية

#### 🛠️ `utils/` - الأدوات المساعدة
- **app_exceptions.dart**: إدارة الاستثناءات
- **validators.dart**: التحقق من صحة البيانات
- **helpers.dart**: دوال مساعدة عامة

#### 🧩 `widgets/` - مكونات واجهة المستخدم
- **product/**: مكونات المنتجات
- **cart/**: مكونات السلة
- **common/**: مكونات مشتركة
- **image_upload_widget.dart**: رفع الصور

## 🔗 العلاقات بين الملفات

### 1. التدفق الرئيسي للتطبيق
```
main.dart → routes.dart → screens/ → services/ → models/
```

### 2. إدارة الحالة
```
providers/ ↔ screens/ ↔ widgets/
```

### 3. طبقة البيانات
```
services/ → models/ → providers/ → screens/
```

### 4. التدويل
```
l10n/ → screens/ → widgets/
```

## 📦 التبعيات والمكتبات

### التبعيات الأساسية:
```yaml
dependencies:
  flutter: sdk: flutter
  
  # Firebase
  firebase_core: ^3.8.0
  cloud_firestore: ^5.6.0
  firebase_auth: ^5.3.3
  firebase_ui_firestore: ^1.6.5
  firebase_ui_auth: ^1.15.0
  firebase_messaging: ^15.0.4
  
  # State Management
  provider: ^6.1.2
  
  # UI Components
  cached_network_image: ^3.4.1
  flutter_localizations: sdk: flutter
  intl: any
  
  # Cloud Services
  cloudinary: ^1.1.0
  
  # Utilities
  shared_preferences: ^2.3.2
  image_picker: ^1.1.2
```

### تبعيات التطوير:
```yaml
dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0
```

## 🏗️ معمارية التطبيق

### نمط MVP (Model-View-Provider)
- **Model**: نماذج البيانات في `models/`
- **View**: الشاشات والمكونات في `screens/` و `widgets/`
- **Provider**: إدارة الحالة في `providers/`

### طبقات التطبيق:
1. **طبقة العرض (Presentation Layer)**: `screens/` و `widgets/`
2. **طبقة المنطق (Business Logic Layer)**: `providers/` و `services/`
3. **طبقة البيانات (Data Layer)**: `models/` و `services/`

### الفصل بين الاهتمامات:
- **UI**: منفصلة في `screens/` و `widgets/`
- **Business Logic**: في `providers/` و `services/`
- **Data Models**: في `models/`
- **Constants**: في `constants/`
- **Utilities**: في `utils/`

---

# 3. الواجهات والنظم الفرعية

## 🖥️ الواجهات الرئيسية

### 1. 🏠 الشاشة الرئيسية (Home Screen)
**الملف**: `lib/screens/home/home_screen.dart`

#### الوظائف الأساسية:
- عرض المنتجات المميزة والعروض الخاصة
- شريط البحث السريع
- عرض الفئات الرئيسية
- التنقل السريع للأقسام المختلفة

#### مكونات الواجهة:
- **AppBar**: شريط التطبيق مع أيقونة البحث والإشعارات
- **Search Bar**: شريط البحث التفاعلي
- **Categories Grid**: شبكة الفئات الرئيسية
- **Featured Products**: المنتجات المميزة
- **Special Offers**: العروض الخاصة
- **Bottom Navigation**: شريط التنقل السفلي

#### التفاعل مع المستخدم:
```
المستخدم → البحث → نتائج البحث
المستخدم → اختيار فئة → شاشة المنتجات
المستخدم → اختيار منتج → تفاصيل المنتج
```

### 2. 🛍️ شاشة المنتجات (Products Screen)
**الملف**: `lib/screens/products_screen.dart`

#### الوظائف الأساسية:
- عرض قائمة المنتجات مع التصفح اللانهائي
- فلترة وترتيب المنتجات
- البحث داخل المنتجات
- إضافة المنتجات للسلة والمفضلة

#### مكونات الواجهة:
- **Product Grid**: شبكة المنتجات
- **Filter Options**: خيارات الفلترة
- **Sort Options**: خيارات الترتيب
- **Loading Indicators**: مؤشرات التحميل
- **Product Cards**: بطاقات المنتجات

#### تدفق البيانات:
```
Firestore → ProductsScreen → ProductCard → ProductDetailScreen
```

### 3. 📱 تفاصيل المنتج (Product Detail Screen)
**الملف**: `lib/screens/product/product_detail_screen.dart`

#### الوظائف الأساسية:
- عرض تفاصيل المنتج الكاملة
- معرض الصور التفاعلي
- إضافة للسلة مع تحديد الكمية
- إضافة للمفضلة
- مشاركة المنتج

#### مكونات الواجهة:
- **Image Gallery**: معرض الصور
- **Product Info**: معلومات المنتج
- **Price Display**: عرض السعر
- **Quantity Selector**: محدد الكمية
- **Action Buttons**: أزرار الإجراءات
- **Reviews Section**: قسم التقييمات

### 4. 🛒 شاشة السلة (Cart Screen)
**الملف**: `lib/screens/cart/cart_screen.dart`

#### الوظائف الأساسية:
- عرض عناصر السلة
- تعديل الكميات
- حذف العناصر
- حساب المجموع الكلي
- الانتقال لعملية الدفع

#### مكونات الواجهة:
- **Cart Items List**: قائمة عناصر السلة
- **Quantity Controls**: أدوات التحكم في الكمية
- **Price Summary**: ملخص الأسعار
- **Checkout Button**: زر الدفع
- **Empty Cart State**: حالة السلة الفارغة

### 5. 💳 شاشة الدفع (Checkout Screen)
**الملف**: `lib/screens/checkout_screen.dart`

#### الوظائف الأساسية:
- اختيار عنوان التوصيل
- اختيار طريقة الشحن
- اختيار طريقة الدفع
- مراجعة الطلب النهائي
- تأكيد الطلب

#### مكونات الواجهة:
- **Address Selection**: اختيار العنوان
- **Shipping Methods**: طرق الشحن
- **Payment Methods**: طرق الدفع
- **Order Summary**: ملخص الطلب
- **Place Order Button**: زر تأكيد الطلب

#### تدفق عملية الدفع:
```
Cart → Checkout → Address → Shipping → Payment → Confirmation
```

### 6. 📋 شاشة الطلبات (Orders Screen)
**الملف**: `lib/screens/order/orders_screen.dart`

#### الوظائف الأساسية:
- عرض تاريخ الطلبات
- تتبع حالة الطلبات
- تفاصيل كل طلب
- إعادة الطلب
- إلغاء الطلبات

#### مكونات الواجهة:
- **Orders List**: قائمة الطلبات
- **Order Status**: حالة الطلب
- **Order Details**: تفاصيل الطلب
- **Tracking Info**: معلومات التتبع
- **Action Buttons**: أزرار الإجراءات

### 7. ❤️ شاشة المفضلة (Wishlist Screen)
**الملف**: `lib/screens/wishlist/wishlist_screen.dart`

#### الوظائف الأساسية:
- عرض المنتجات المفضلة
- إزالة من المفضلة
- إضافة للسلة
- مشاركة المنتجات

#### مكونات الواجهة:
- **Wishlist Grid**: شبكة المفضلة
- **Product Cards**: بطاقات المنتجات
- **Remove Button**: زر الإزالة
- **Add to Cart**: إضافة للسلة

### 8. 🔍 شاشة البحث المتقدم (Advanced Search Screen)
**الملف**: `lib/screens/advanced_search_screen.dart`

#### الوظائف الأساسية:
- البحث بالفئات
- البحث بنطاق الأسعار
- البحث بالتقييمات
- فلترة النتائج
- حفظ عمليات البحث

#### مكونات الواجهة:
- **Search Filters**: فلاتر البحث
- **Price Range**: نطاق الأسعار
- **Category Filter**: فلتر الفئات
- **Results Grid**: شبكة النتائج
- **Save Search**: حفظ البحث

### 9. ⚙️ شاشة الإعدادات (Settings Screen)
**الملف**: `lib/screens/settings_screen.dart`

#### الوظائف الأساسية:
- تغيير اللغة
- تغيير السمة
- إعدادات الإشعارات
- إعدادات الحساب
- معلومات التطبيق

#### مكونات الواجهة:
- **Language Selector**: محدد اللغة
- **Theme Toggle**: مفتاح السمة
- **Notification Settings**: إعدادات الإشعارات
- **Account Settings**: إعدادات الحساب
- **About Section**: قسم حول التطبيق

## 🔄 النظم الفرعية

### 1. نظام إدارة الحالة (State Management)
**المزودون (Providers)**:
- `CartProvider`: إدارة حالة السلة
- `AuthProvider`: إدارة حالة المصادقة
- `WishlistProvider`: إدارة المفضلة
- `ThemeProvider`: إدارة السمة
- `LanguageProvider`: إدارة اللغة

### 2. نظام المصادقة (Authentication System)
**المكونات**:
- `AuthService`: خدمة المصادقة
- `Firebase Auth`: مصادقة Firebase
- `User Model`: نموذج المستخدم

### 3. نظام قاعدة البيانات (Database System)
**المكونات**:
- `FirestoreService`: خدمة Firestore
- `Product Model`: نموذج المنتج
- `Order Model`: نموذج الطلب
- `User Model`: نموذج المستخدم

### 4. نظام التدويل (Internationalization)
**المكونات**:
- `app_en.arb`: النصوص الإنجليزية
- `app_ar.arb`: النصوص العربية
- `AppLocalizations`: فئة التدويل

## 📊 مخططات التدفق

### تدفق التسوق الأساسي:
```
الشاشة الرئيسية → اختيار منتج → تفاصيل المنتج → إضافة للسلة → السلة → الدفع → تأكيد الطلب
```

### تدفق المصادقة:
```
شاشة تسجيل الدخول → إدخال البيانات → التحقق → الشاشة الرئيسية
```

### تدفق البحث:
```
شريط البحث → إدخال النص → النتائج → فلترة → اختيار منتج
```

### تدفق إدارة الطلبات:
```
تأكيد الطلب → معالجة → شحن → توصيل → تأكيد الاستلام
```

## 🎨 تصميم واجهة المستخدم

### نظام الألوان:
- **اللون الأساسي**: أزرق (#2196F3)
- **اللون الثانوي**: برتقالي (#FF9800)
- **لون الخطأ**: أحمر (#F44336)
- **لون النجاح**: أخضر (#4CAF50)

### الخطوط:
- **الخط الأساسي**: Roboto (للإنجليزية)
- **الخط العربي**: Cairo (للعربية)

### المسافات:
- **صغيرة**: 8px
- **متوسطة**: 16px
- **كبيرة**: 24px
- **كبيرة جداً**: 32px

---

# 4. التعليمات التشغيلية

## 🔧 متطلبات النظام

### المتطلبات الأساسية:
- **Flutter SDK**: الإصدار 3.16.9 أو أحدث
- **Dart SDK**: الإصدار 3.2.6 أو أحدث
- **IDE**: Android Studio أو VS Code
- **Git**: لإدارة الإصدارات
- **Node.js**: للأدوات الإضافية (اختياري)

### متطلبات النظام:
#### Windows:
- Windows 10 أو أحدث (64-bit)
- 8 GB RAM (16 GB مُوصى به)
- 10 GB مساحة فارغة على القرص الصلب
- PowerShell 5.0 أو أحدث

#### macOS:
- macOS 10.14 أو أحدث
- 8 GB RAM (16 GB مُوصى به)
- 10 GB مساحة فارغة على القرص الصلب
- Xcode (للتطوير على iOS)

#### Linux:
- Ubuntu 18.04 LTS أو أحدث
- 8 GB RAM (16 GB مُوصى به)
- 10 GB مساحة فارغة على القرص الصلب

### أجهزة الاختبار:
- **Android**: الإصدار 5.0 (API 21) أو أحدث
- **iOS**: iOS 12.0 أو أحدث
- **Web**: Chrome, Firefox, Safari, Edge

## 📥 خطوات التثبيت والإعداد

### 1. تثبيت Flutter SDK

#### Windows:
```powershell
# تحميل Flutter SDK
# قم بتحميل Flutter من الموقع الرسمي
# https://docs.flutter.dev/get-started/install/windows

# إضافة Flutter إلى PATH
$env:PATH += ";C:\flutter\bin"

# التحقق من التثبيت
flutter doctor
```

#### macOS/Linux:
```bash
# تحميل Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# إضافة Flutter إلى PATH
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

### 2. إعداد IDE

#### Android Studio:
1. تحميل وتثبيت Android Studio
2. تثبيت Flutter و Dart plugins
3. إعداد Android SDK
4. إنشاء Android Virtual Device (AVD)

#### VS Code:
1. تحميل وتثبيت VS Code
2. تثبيت Flutter extension
3. تثبيت Dart extension

### 3. استنساخ المشروع

```bash
# استنساخ المستودع
git clone [repository-url]
cd gizmo_store

# التحقق من حالة Flutter
flutter doctor

# تثبيت التبعيات
flutter pub get
```

### 4. إعداد Firebase

#### إنشاء مشروع Firebase:
1. الذهاب إلى [Firebase Console](https://console.firebase.google.com/)
2. إنشاء مشروع جديد
3. تفعيل Authentication
4. تفعيل Cloud Firestore
5. تفعيل Storage

#### إعداد Android:
1. إضافة تطبيق Android في Firebase Console
2. تحميل `google-services.json`
3. وضع الملف في `android/app/`
4. تحديث `android/build.gradle` و `android/app/build.gradle`

#### إعداد iOS:
1. إضافة تطبيق iOS في Firebase Console
2. تحميل `GoogleService-Info.plist`
3. وضع الملف في `ios/Runner/`
4. تحديث `ios/Runner/Info.plist`

#### إعداد Web:
1. إضافة تطبيق Web في Firebase Console
2. نسخ إعدادات Firebase
3. تحديث `web/index.html`

### 5. إعداد قاعدة البيانات

#### Firestore Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // قواعد المنتجات
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && 
                      request.auth.token.admin == true;
    }
    
    // قواعد المستخدمين
    match /users/{userId} {
      allow read, write: if request.auth != null && 
                            request.auth.uid == userId;
    }
    
    // قواعد الطلبات
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
                            request.auth.uid == resource.data.userId;
    }
  }
}
```

#### Storage Rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && 
                      request.auth.token.admin == true;
    }
    
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && 
                            request.auth.uid == userId;
    }
  }
}
```

## 🚀 تشغيل التطبيق

### التشغيل في وضع التطوير:

#### Android:
```bash
# تشغيل على جهاز Android
flutter run

# تشغيل على محاكي محدد
flutter run -d [device-id]

# تشغيل مع Hot Reload
flutter run --hot
```

#### iOS:
```bash
# تشغيل على جهاز iOS
flutter run

# تشغيل على محاكي iOS
flutter run -d "iPhone 14"
```

#### Web:
```bash
# تشغيل على الويب
flutter run -d web-server --web-port 3000

# تشغيل على Chrome
flutter run -d chrome
```

### بناء التطبيق للإنتاج:

#### Android APK:
```bash
# بناء APK
flutter build apk

# بناء APK مُحسن
flutter build apk --release

# بناء App Bundle
flutter build appbundle
```

#### iOS:
```bash
# بناء للـ iOS
flutter build ios

# بناء للـ App Store
flutter build ipa
```

#### Web:
```bash
# بناء للويب
flutter build web

# بناء مُحسن للإنتاج
flutter build web --release
```

## 🔧 إعدادات التطوير

### متغيرات البيئة:
```bash
# إعداد متغيرات البيئة
export FLUTTER_ROOT=/path/to/flutter
export ANDROID_HOME=/path/to/android-sdk
export PATH=$PATH:$FLUTTER_ROOT/bin:$ANDROID_HOME/tools
```

### إعدادات VS Code:
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.debugExternalLibraries": false,
  "dart.debugSdkLibraries": false,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

### إعدادات Android Studio:
1. File → Settings → Languages & Frameworks → Flutter
2. تحديد مسار Flutter SDK
3. تفعيل Hot Reload
4. إعداد Code Style للـ Dart

## 🧪 تشغيل الاختبارات

### اختبارات الوحدة:
```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبار محدد
flutter test test/unit/product_test.dart

# تشغيل مع تقرير التغطية
flutter test --coverage
```

### اختبارات التكامل:
```bash
# تشغيل اختبارات التكامل
flutter drive --target=test_driver/app.dart
```

### اختبارات الواجهة:
```bash
# تشغيل اختبارات الواجهة
flutter test integration_test/
```

## 🐛 استكشاف الأخطاء وإصلاحها

### مشاكل شائعة وحلولها:

#### مشكلة: Flutter Doctor يظهر أخطاء
```bash
# تشغيل Flutter Doctor
flutter doctor

# إصلاح المشاكل تلقائياً
flutter doctor --android-licenses
```

#### مشكلة: فشل في تثبيت التبعيات
```bash
# تنظيف المشروع
flutter clean

# إعادة تثبيت التبعيات
flutter pub get

# إعادة بناء المشروع
flutter pub deps
```

#### مشكلة: أخطاء في البناء
```bash
# تنظيف البناء
flutter clean

# إعادة البناء
flutter build apk --debug
```

#### مشكلة: أخطاء Firebase
1. التحقق من ملفات الإعداد
2. التأكد من تطابق package name
3. التحقق من قواعد Firestore
4. مراجعة إعدادات Authentication

### سجلات الأخطاء:
```bash
# عرض السجلات
flutter logs

# عرض سجلات Android
adb logcat

# عرض سجلات iOS
xcrun simctl spawn booted log stream
```

## 🖼️ استكشاف أخطاء تحميل الصور في لوحة الإدارة

### المشاكل الشائعة وحلولها:

#### 1. مشكلة إعدادات Cloudinary
```dart
// التحقق من إعدادات Cloudinary في lib/services/cloudinary_service.dart
class CloudinaryService {
  static const String cloudName = 'gizmo-store';
  static const String uploadPreset = 'gizmo_products';
  
  // تأكد من أن Upload Preset غير موقع (unsigned)
  // في لوحة تحكم Cloudinary
}
```

**الحلول:**
- تحقق من أن `cloudName` صحيح في حساب Cloudinary
- تأكد من أن `uploadPreset` موجود وغير موقع (unsigned)
- راجع إعدادات الأمان في Cloudinary Dashboard

#### 2. مشكلة صلاحيات التطبيق
```xml
<!-- في android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

#### 3. تحسين معالجة الأخطاء
```dart
// في lib/screens/admin/add_product_screen.dart
Future<void> _addImage() async {
  try {
    // اختبار الاتصال بـ Cloudinary أولاً
    final isConnected = await CloudinaryService.testConnection();
    if (!isConnected) {
      _showSnackBar('فشل في الاتصال بخدمة تحميل الصور', Colors.red);
      return;
    }
    
    final imageUrl = await ImageUploadService.pickAndUploadSingleImage(
      'gizmo_store/products',
    );
    
    if (imageUrl != null) {
      setState(() {
        _formData.images.add(imageUrl);
      });
      _showSnackBar('تم تحميل الصورة بنجاح', Colors.green);
    }
  } on PermissionException {
    _showSnackBar('يرجى منح صلاحيات الوصول للكاميرا والتخزين', Colors.red);
  } on NetworkException {
    _showSnackBar('تحقق من اتصال الإنترنت وحاول مرة أخرى', Colors.red);
  } on CloudinaryException catch (e) {
    _showSnackBar('خطأ في خدمة تحميل الصور: ${e.message}', Colors.red);
  } catch (e) {
    _showSnackBar('حدث خطأ غير متوقع: $e', Colors.red);
  }
}
```

#### 4. إضافة وظيفة اختبار الاتصال
```dart
// إضافة إلى lib/services/cloudinary_service.dart
static Future<bool> testConnection() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
    );
    return response.statusCode == 200 || response.statusCode == 405;
  } catch (e) {
    return false;
  }
}
```

### خطوات التشخيص:
1. **فحص السجلات**: `flutter logs` للبحث عن رسائل الخطأ
2. **اختبار على أجهزة مختلفة**: Android/iOS/Web
3. **اختبار أحجام صور مختلفة**: صغيرة/متوسطة/كبيرة
4. **مراجعة Cloudinary Dashboard**: للتحقق من محاولات التحميل

## 📍 حل مشكلة إدارة العناوين

### المشكلة الحالية:
تظهر رسالة خطأ Firestore عند محاولة تحميل العناوين: `Missing or insufficient permissions [cloud_firestore/permission-denied]`

### الحل:

#### 1. تحديث قواعد Firestore
```javascript
// في firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // قواعد المستخدمين
    match /users/{userId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == userId || isAdmin());
      
      // قواعد العناوين الفرعية
      match /addresses/{addressId} {
        allow read, write: if request.auth != null && 
          (request.auth.uid == userId || isAdmin());
      }
    }
    
    // وظيفة التحقق من المدير
    function isAdmin() {
      return request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
  }
}
```

#### 2. تحديث بنية البيانات
```dart
// في lib/services/firestore_service.dart
class FirestoreService {
  // جلب عناوين المستخدم
  Stream<List<Address>> getUserAddresses(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Address.fromFirestore(doc))
            .toList());
  }
  
  // إضافة عنوان جديد
  Future<void> addAddress(String userId, Address address) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(address.toFirestore());
  }
  
  // تحديث عنوان
  Future<void> updateAddress(String userId, String addressId, Address address) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .update(address.toFirestore());
  }
  
  // حذف عنوان
  Future<void> deleteAddress(String userId, String addressId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }
  
  // تعيين عنوان افتراضي
  Future<void> setDefaultAddress(String userId, String addressId) async {
    final batch = _firestore.batch();
    
    // إزالة الافتراضي من جميع العناوين
    final addresses = await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();
    
    for (final doc in addresses.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }
    
    // تعيين العنوان الجديد كافتراضي
    batch.update(
      _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId),
      {'isDefault': true}
    );
    
    await batch.commit();
  }
}
```

#### 3. تحسين واجهة إدارة العناوين
```dart
// تحسينات في lib/screens/address_management_screen.dart
class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  Widget build(BuildContext context) {
    // إضافة معالجة أفضل للأخطاء
    return StreamBuilder<List<Address>>(
      stream: _firestoreService.getUserAddresses(_currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // معالجة أخطاء الصلاحيات
          if (snapshot.error.toString().contains('permission-denied')) {
            return _buildPermissionDeniedWidget();
          }
          return _buildErrorWidget(snapshot.error.toString());
        }
        
        // باقي الكود...
      },
    );
  }
  
  Widget _buildPermissionDeniedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'غير مخول لك الوصول إلى العناوين',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى تسجيل الدخول مرة أخرى',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
```

#### 4. نشر قواعد Firestore المحدثة
```bash
# نشر قواعد Firestore الجديدة
firebase deploy --only firestore:rules

# أو نشر جميع الخدمات
firebase deploy
```

### اختبار الحل:
1. تسجيل الدخول كمستخدم عادي
2. الانتقال إلى إدارة العناوين
3. إضافة عنوان جديد
4. تعديل عنوان موجود
5. حذف عنوان
6. تعيين عنوان افتراضي

## 📱 نشر التطبيق

### Google Play Store:
1. إنشاء حساب مطور
2. بناء App Bundle
3. رفع التطبيق
4. إعداد Store Listing
5. مراجعة ونشر

### Apple App Store:
1. إنشاء حساب مطور Apple
2. بناء IPA
3. رفع عبر Xcode أو Transporter
4. إعداد App Store Connect
5. مراجعة ونشر

### Firebase Hosting (للويب):
```bash
# تثبيت Firebase CLI
npm install -g firebase-tools

# تسجيل الدخول
firebase login

# تهيئة المشروع
firebase init hosting

# نشر التطبيق
firebase deploy
```

---