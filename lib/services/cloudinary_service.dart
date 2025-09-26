import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // إعدادات Cloudinary للمتجر
  static const String cloudName = 'gizmo-store'; 
  static const String uploadPreset = 'gizmo_products';
  
  static final CloudinaryPublic cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
  );
  
  // رفع صورة واحدة
  static Future<String> uploadImage(File imageFile, {required String folder}) async {
    try {
      print('🔄 بدء رفع الصورة: ${imageFile.path}');
      print('📁 المجلد: $folder');
      print('☁️ Cloud Name: $cloudName');
      print('📤 Upload Preset: $uploadPreset');
      
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder,
        ),
      );
      
      print('✅ تم رفع الصورة بنجاح!');
      print('🔗 رابط الصورة: ${response.secureUrl}');
      
      return response.secureUrl;
    } catch (e) {
      print('❌ خطأ في رفع الصورة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في رفع الصورة: $e');
    }
  }
  
  // رفع عدة صور
  static Future<List<String>> uploadMultipleImages(List<File> imageFiles, {required String folder}) async {
    print('📤 بدء رفع ${imageFiles.length} صورة');
    List<String> urls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];
      print('📸 رفع الصورة ${i + 1}/${imageFiles.length}: ${imageFile.path}');
      
      try {
        String url = await uploadImage(imageFile, folder: folder);
        urls.add(url);
        print('✅ تم رفع الصورة ${i + 1} بنجاح');
      } catch (e) {
        print('❌ فشل في رفع الصورة ${i + 1}: $e');
        // لا نضيف URL في حالة الفشل
      }
    }
    
    print('📊 تم رفع ${urls.length} من أصل ${imageFiles.length} صورة');
    return urls;
  }
}
