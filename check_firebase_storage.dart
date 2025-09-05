import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

/// سكريبت للتحقق من حالة Firebase Storage واختبار الاتصال
void main() async {
  print('🔍 بدء فحص Firebase Storage...');
  
  try {
    // تهيئة Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ تم تهيئة Firebase بنجاح');
    
    // فحص Firebase Storage
    await checkStorageStatus();
    
    // فحص البيانات في Firestore
    await checkFirestoreData();
    
    // اختبار رفع ملف تجريبي
    await testFileUpload();
    
  } catch (e) {
    print('❌ خطأ في التهيئة: $e');
    exit(1);
  }
}

/// فحص حالة Firebase Storage
Future<void> checkStorageStatus() async {
  try {
    print('\n📦 فحص Firebase Storage...');
    
    final storage = FirebaseStorage.instance;
    final ref = storage.ref();
    
    // محاولة الحصول على قائمة الملفات
    final result = await ref.listAll();
    print('✅ Firebase Storage متاح');
    print('📁 عدد المجلدات الجذرية: ${result.prefixes.length}');
    print('📄 عدد الملفات في الجذر: ${result.items.length}');
    
    // عرض المجلدات الموجودة
    if (result.prefixes.isNotEmpty) {
      print('\n📂 المجلدات الموجودة:');
      for (var prefix in result.prefixes) {
        print('  - ${prefix.name}');
      }
    }
    
    // فحص مجلد المنتجات
    await checkProductsFolder();
    
  } catch (e) {
    print('❌ خطأ في الوصول إلى Firebase Storage: $e');
    print('💡 تأكد من أن Firebase Storage تم إعداده في وحة التحكم');
  }
}

/// فحص مجلد المنتجات
Future<void> checkProductsFolder() async {
  try {
    final storage = FirebaseStorage.instance;
    final productsRef = storage.ref().child('products');
    
    final result = await productsRef.listAll();
    print('\n🛍️ مجلد المنتجات:');
    print('  📁 عدد مجلدات المنتجات: ${result.prefixes.length}');
    print('  📄 عدد الملفات المباشرة: ${result.items.length}');
    
  } catch (e) {
    print('ℹ️ مجلد المنتجات غير موجود بعد (طبيعي للمشاريع الجديدة)');
  }
}

/// فحص البيانات في Firestore
Future<void> checkFirestoreData() async {
  try {
    print('\n🗄️ فحص بيانات Firestore...');
    
    final firestore = FirebaseFirestore.instance;
    
    // فحص مجموعة المنتجات
    final productsSnapshot = await firestore.collection('products').limit(5).get();
    print('📦 عدد المنتجات: ${productsSnapshot.docs.length}');
    
    if (productsSnapshot.docs.isNotEmpty) {
      print('\n🔍 عينة من المنتجات وروابط الصور:');
      for (var doc in productsSnapshot.docs) {
        final data = doc.data();
        final name = data['name'] ?? 'غير محدد';
        final image = data['image'] ?? 'لا يوجد';
        print('  📱 $name');
        print('    🖼️ الصورة: $image');
        
        // التحقق من نوع رابط الصورة
        if (image.toString().startsWith('https://firebasestorage.googleapis.com')) {
          print('    ✅ رابط Firebase Storage');
        } else if (image.toString().startsWith('https://')) {
          print('    ⚠️ رابط خارجي');
        } else {
          print('    ❌ رابط غير صحيح');
        }
        print('');
      }
    }
    
  } catch (e) {
    print('❌ خطأ في الوصول إلى Firestore: $e');
  }
}

/// اختبار رفع ملف تجريبي
Future<void> testFileUpload() async {
  try {
    print('\n🧪 اختبار رفع ملف تجريبي...');
    
    final storage = FirebaseStorage.instance;
    final testRef = storage.ref().child('test/connection_test.txt');
    
    // إنشاء محتوى تجريبي
    final testContent = 'اختبار الاتصال - ${DateTime.now().toIso8601String()}';
    final data = testContent.codeUnits;
    
    // رفع الملف
    await testRef.putData(data);
    print('✅ تم رفع الملف التجريبي بنجاح');
    
    // الحصول على رابط التحميل
    final downloadUrl = await testRef.getDownloadURL();
    print('🔗 رابط التحميل: $downloadUrl');
    
    // حذف الملف التجريبي
    await testRef.delete();
    print('🗑️ تم حذف الملف التجريبي');
    
  } catch (e) {
    print('❌ فشل اختبار رفع الملف: $e');
    if (e.toString().contains('storage/object-not-found')) {
      print('💡 هذا طبيعي - الملف لم يكن موجوداً للحذف');
    } else if (e.toString().contains('storage/unauthorized')) {
      print('💡 تحقق من قواعد Firebase Storage');
    }
  }
}