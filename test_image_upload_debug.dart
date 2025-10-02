import 'dart:io';
import 'package:flutter/foundation.dart';
import 'lib/services/cloudinary_service.dart';
import 'lib/services/image_upload_service.dart';

void main() async {
  print('🧪 بدء اختبار رفع الصور...');
  
  try {
    // اختبار إعدادات Cloudinary
    print('☁️ اختبار إعدادات Cloudinary...');
    print('Cloud Name: ${CloudinaryService.cloudName}');
    print('Upload Preset: ${CloudinaryService.uploadPreset}');
    
    // محاولة إنشاء ملف وهمي للاختبار (فقط للاختبار المحلي)
    if (!kIsWeb) {
      print('💻 اختبار على المنصة المحلية...');
      
      // إنشاء ملف صورة وهمي للاختبار
      final testFile = File('test_image.jpg');
      if (await testFile.exists()) {
        print('📁 ملف الاختبار موجود: ${testFile.path}');
        
        // اختبار رفع الصورة
        print('📤 بدء رفع الصورة...');
        final result = await CloudinaryService.uploadImage(
          testFile,
          folder: 'gizmo_store/test',
        );
        
        print('✅ تم رفع الصورة بنجاح: $result');
      } else {
        print('⚠️ ملف الاختبار غير موجود');
      }
    } else {
      print('🌐 اختبار على الويب...');
      print('⚠️ لا يمكن إنشاء ملفات محلية على الويب');
    }
    
  } catch (e, stackTrace) {
    print('❌ خطأ في الاختبار: $e');
    print('📊 نوع الخطأ: ${e.runtimeType}');
    print('🔍 Stack trace: $stackTrace');
  }
  
  print('🏁 انتهى الاختبار');
}