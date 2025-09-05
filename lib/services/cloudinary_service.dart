import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';
  
  static final CloudinaryPublic cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
  );
  
  static Future<String> uploadImage(File imageFile, {String? folder}) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder ?? 'gizmo_store/products',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  
  static Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    String? folder,
  }) async {
    List<String> urls = [];
    
    for (File imageFile in imageFiles) {
      try {
        String url = await uploadImage(imageFile, folder: folder);
        urls.add(url);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    
    return urls;
  }
}
