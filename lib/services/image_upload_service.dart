import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'cloudinary_service.dart';

/// خدمة رفع الصور مع دعم جميع الصيغ الشائعة
/// الصيغ المدعومة: JPG, JPEG, PNG, GIF, WEBP, BMP, TIFF
/// بدون قيود على الحجم أو الأبعاد
class ImageUploadService {
  static final ImagePicker _picker = ImagePicker();
  
  // دعم جميع صيغ الصور الشائعة: JPG, JPEG, PNG, GIF, WEBP, BMP
  // بدون قيود على الحجم أو الأبعاد

  // رفع صور المنتجات
  static Future<List<String>> uploadProductImages(List<File> images) async {
    return await CloudinaryService.uploadMultipleImages(
      images,
      folder: 'gizmo_store/products',
    );
  }
  
  // رفع صورة الفئة
  static Future<String> uploadCategoryImage(File image) async {
    return await CloudinaryService.uploadImage(
      image,
      folder: 'gizmo_store/categories',
    );
  }
  
  // رفع صورة الملف الشخصي
  static Future<String> uploadProfileImage(File image, String userId) async {
    return await CloudinaryService.uploadImage(
      image,
      folder: 'gizmo_store/profiles/$userId',
    );
  }

  // اختيار صورة واحدة من المعرض
  static Future<File?> pickImageFromGallery() async {
    try {
      print('📱 بدء اختيار صورة من المعرض...');
      
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100, // جودة عالية
      );
      
      if (pickedFile != null) {
        print('✅ تم اختيار الصورة: ${pickedFile.path}');
        print('📏 حجم الملف: ${await pickedFile.length()} bytes');
        return File(pickedFile.path);
      } else {
        print('⚠️ لم يتم اختيار أي صورة');
        return null;
      }
    } catch (e) {
      print('❌ خطأ في اختيار الصورة من المعرض: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في اختيار الصورة: $e');
    }
  }

  // اختيار صورة واحدة من الكاميرا
  static Future<File?> pickImageFromCamera() async {
    try {
      print('📷 بدء التقاط صورة من الكاميرا...');
      
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100, // جودة عالية
      );
      
      if (pickedFile != null) {
        print('✅ تم التقاط الصورة: ${pickedFile.path}');
        print('📏 حجم الملف: ${await pickedFile.length()} bytes');
        return File(pickedFile.path);
      } else {
        print('⚠️ لم يتم التقاط أي صورة');
        return null;
      }
    } catch (e) {
      print('❌ خطأ في التقاط الصورة من الكاميرا: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في التقاط الصورة: $e');
    }
  }

  // اختيار عدة صور من المعرض - دعم جميع الصيغ والأحجام
  static Future<List<File>> pickMultipleImages() async {
    try {
      print('📱 بدء اختيار عدة صور من المعرض...');
      
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 100, // جودة عالية بدون قيود حجم
      );
      
      print('📊 تم اختيار ${pickedFiles.length} صورة');
      
      final List<File> files = pickedFiles.map((file) => File(file.path)).toList();
      
      for (int i = 0; i < files.length; i++) {
        print('📸 الصورة ${i + 1}: ${files[i].path}');
      }
      
      return files;
    } catch (e) {
      print('❌ خطأ في اختيار الصور المتعددة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في اختيار الصور: $e');
    }
  }

  // عرض خيارات اختيار الصورة
  static Future<File?> showImageSourceDialog(context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر مصدر الصورة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('المعرض'),
                onTap: () {
                  Navigator.of(context).pop('gallery');
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () {
                  Navigator.of(context).pop('camera');
                },
              ),
            ],
          ),
        );
      },
    );

    if (result == 'gallery') {
      return await pickImageFromGallery();
    } else if (result == 'camera') {
      return await pickImageFromCamera();
    }
    
    return null;
  }

  // رفع صورة واحدة مع اختيار المصدر
  static Future<String?> pickAndUploadSingleImage(
    context, {
    required String folder,
  }) async {
    try {
      print('📱 بدء اختيار ورفع صورة واحدة...');
      final File? imageFile = await showImageSourceDialog(context);
      if (imageFile != null) {
        print('📤 رفع الصورة إلى المجلد: $folder');
        final url = await CloudinaryService.uploadImage(imageFile, folder: folder);
        print('✅ تم رفع الصورة بنجاح: $url');
        return url;
      } else {
        print('⚠️ لم يتم اختيار أي صورة');
        return null;
      }
    } catch (e) {
      print('❌ خطأ في اختيار ورفع الصورة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في رفع الصورة: $e');
    }
  }

  // رفع عدة صور
  static Future<List<String>> pickAndUploadMultipleImages(
    context, {
    required String folder,
  }) async {
    try {
      print('📱 بدء اختيار ورفع عدة صور...');
      final List<File> imageFiles = await pickMultipleImages();
      
      if (imageFiles.isNotEmpty) {
        print('📤 رفع ${imageFiles.length} صورة إلى المجلد: $folder');
        final urls = await CloudinaryService.uploadMultipleImages(
          imageFiles,
          folder: folder,
        );
        print('✅ تم رفع ${urls.length} من أصل ${imageFiles.length} صورة بنجاح');
        return urls;
      } else {
        print('⚠️ لم يتم اختيار أي صور');
        return [];
      }
    } catch (e) {
      print('❌ خطأ في اختيار ورفع الصور: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في رفع الصور: $e');
    }
  }
}
