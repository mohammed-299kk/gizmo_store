import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'cloudinary_service.dart';

class ImageUploadService {
  static final ImagePicker _picker = ImagePicker();

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
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('فشل في اختيار الصورة: $e');
    }
  }

  // اختيار صورة واحدة من الكاميرا
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('فشل في التقاط الصورة: $e');
    }
  }

  // اختيار عدة صور من المعرض
  static Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      return pickedFiles.map((file) => File(file.path)).toList();
    } catch (e) {
      throw Exception('فشل في اختيار الصور: $e');
    }
  }

  // عرض خيارات اختيار الصورة
  static Future<File?> showImageSourceDialog(context) async {
    return await showDialog<File?>(
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
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await pickImageFromGallery();
                  Navigator.of(context).pop(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await pickImageFromCamera();
                  Navigator.of(context).pop(file);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // رفع صورة واحدة مع اختيار المصدر
  static Future<String?> pickAndUploadSingleImage(
    context, {
    required String folder,
  }) async {
    try {
      final File? imageFile = await showImageSourceDialog(context);
      if (imageFile != null) {
        return await CloudinaryService.uploadImage(imageFile, folder: folder);
      }
      return null;
    } catch (e) {
      throw Exception('فشل في رفع الصورة: $e');
    }
  }

  // رفع عدة صور
  static Future<List<String>> pickAndUploadMultipleImages(
    context, {
    required String folder,
  }) async {
    try {
      final List<File> imageFiles = await pickMultipleImages();
      if (imageFiles.isNotEmpty) {
        return await CloudinaryService.uploadMultipleImages(
          imageFiles,
          folder: folder,
        );
      }
      return [];
    } catch (e) {
      throw Exception('فشل في رفع الصور: $e');
    }
  }
}
