import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

void main() async {
  print('🧪 اختبار إعدادات Cloudinary...');
  
  // إعدادات Cloudinary
  const String cloudName = 'gizmo-store';
  const String uploadPreset = 'gizmo_products';
  
  try {
    final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
    print('✅ تم إنشاء كائن Cloudinary بنجاح');
    print('☁️ Cloud Name: $cloudName');
    print('📤 Upload Preset: $uploadPreset');
    
    // اختبار الاتصال بـ Cloudinary
    print('\n🔍 اختبار الاتصال بـ Cloudinary...');
    
    // محاولة رفع صورة اختبار (إذا كانت متوفرة)
    final testImagePath = 'assets/images/logo.png';
    final testFile = File(testImagePath);
    
    if (await testFile.exists()) {
      print('📁 وجدت ملف الاختبار: $testImagePath');
      
      try {
        print('📤 بدء رفع الصورة...');
        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            testFile.path,
            folder: 'gizmo_store/test',
          ),
        );
        
        print('✅ تم رفع الصورة بنجاح!');
        print('🔗 رابط الصورة: ${response.secureUrl}');
        print('🆔 معرف الصورة: ${response.publicId}');
        
      } catch (e) {
        print('❌ خطأ في رفع الصورة: $e');
        print('📊 نوع الخطأ: ${e.runtimeType}');
        
        if (e.toString().contains('Invalid upload preset')) {
          print('⚠️ خطأ في Upload Preset - تحقق من الإعدادات في Cloudinary Dashboard');
        } else if (e.toString().contains('Invalid cloud name')) {
          print('⚠️ خطأ في Cloud Name - تحقق من اسم الحساب في Cloudinary');
        }
      }
    } else {
      print('⚠️ ملف الاختبار غير موجود: $testImagePath');
      print('💡 يمكنك إضافة أي صورة في مجلد assets/images/ لاختبار الرفع');
    }
    
  } catch (e) {
    print('❌ خطأ في إعداد Cloudinary: $e');
    print('📊 نوع الخطأ: ${e.runtimeType}');
  }
  
  print('\n🏁 انتهى الاختبار');
}