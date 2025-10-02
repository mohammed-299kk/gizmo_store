import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  // إعدادات Cloudinary للمتجر (محدثة)
  // Cloud Name: dvnh28qtz
  // API Key: 833666144724123
  // API Secret: BVUme5tWtYpNl-qAWsHq0bUOF6g
  static const String cloudName = 'dvnh28qtz';

  // استخدام gizmo_store الموجود
  // تأكد من أن preset موجود في Cloudinary Dashboard:
  // Name: gizmo_store
  // Mode: Unsigned
  // Asset folder: gizmo_store/products
  static const String uploadPreset = 'gizmo_store';

  static const String apiKey = '833666144724123';
  static const String apiSecret = 'BVUme5tWtYpNl-qAWsHq0bUOF6g';

  // رفع XFile (يعمل على الويب والأجهزة المحلية)
  static Future<String> uploadXFile(XFile imageFile,
      {required String folder}) async {
    try {
      print('🔄 بدء رفع الصورة: ${imageFile.path}');
      print('📁 المجلد: $folder');
      print('☁️ Cloud Name: $cloudName');
      print('📤 Upload Preset: $uploadPreset');
      print('🌐 Platform: ${kIsWeb ? "Web" : "Native"}');

      // قراءة الملف كـ bytes
      final bytes = await imageFile.readAsBytes();
      final filename = imageFile.name;

      print(
          '📦 حجم البيانات: ${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB');

      // إنشاء multipart request
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url);

      // إضافة الحقول المطلوبة
      // ملاحظة: في Unsigned Upload، لا نرسل folder هنا
      // بل يجب أن يكون محدد في الـ preset في Cloudinary Dashboard
      request.fields['upload_preset'] = uploadPreset;
      // لا نضيف folder هنا في unsigned upload
      // request.fields['folder'] = folder;

      // إضافة الملف
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
        ),
      );

      print('📤 إرسال الطلب إلى Cloudinary...');
      print('🔗 URL: https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      print('📋 Fields: ${request.fields}');

      // إرسال الطلب مع timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('انتهت مهلة رفع الصورة. يرجى المحاولة مرة أخرى.');
        },
      );

      // قراءة الاستجابة
      final response = await http.Response.fromStream(streamedResponse);

      print('📊 حالة الاستجابة: ${response.statusCode}');
      print('📄 محتوى الاستجابة الكامل: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final secureUrl = responseData['secure_url'] as String;

        print('✅ تم رفع الصورة بنجاح!');
        print('🔗 رابط الصورة: $secureUrl');

        return secureUrl;
      } else {
        print('❌ فشل رفع الصورة: ${response.statusCode}');
        print('📄 محتوى الاستجابة: ${response.body}');

        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'خطأ غير معروف';

        // معالجة أخطاء محددة
        if (response.statusCode == 401 || errorMessage.contains('API key')) {
          throw Exception('❌ خطأ في إعدادات Cloudinary!\n'
              '📋 الحل:\n'
              '1. تأكد من Cloud Name: "$cloudName"\n'
              '2. تأكد من Upload Preset: "$uploadPreset"\n'
              '3. في Cloudinary Dashboard > Settings > Upload > Upload presets\n'
              '4. قم بإنشاء preset جديد واجعله "unsigned"\n'
              '5. أو استخدم "ml_default" كـ preset افتراضي\n'
              'التفاصيل: $errorMessage');
        }

        throw Exception('فشل في رفع الصورة: $errorMessage');
      }
    } catch (e) {
      print('❌ خطأ في رفع الصورة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');

      // معالجة أنواع مختلفة من الأخطاء
      if (e.toString().contains('Invalid upload preset')) {
        throw Exception('❌ Upload Preset غير صحيح!\n'
            'تأكد من أن "$uploadPreset" موجود في Cloudinary وهو من نوع "unsigned"');
      } else if (e.toString().contains('Invalid cloud name')) {
        throw Exception('❌ Cloud Name غير صحيح!\n'
            'تأكد من أن "$cloudName" هو Cloud Name الصحيح من Cloudinary Dashboard');
      } else if (e.toString().contains('timeout')) {
        throw Exception(
            'انتهت مهلة رفع الصورة. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.');
      } else if (e.toString().contains('API key')) {
        // إعادة رمي الخطأ الأصلي إذا كان يحتوي على تفاصيل API key
        rethrow;
      } else {
        throw Exception(
            'فشل في رفع الصورة. تحقق من حجم الصورة واتصال الإنترنت. التفاصيل: ${e.toString()}');
      }
    }
  }

  // رفع صورة واحدة باستخدام HTTP مباشرة (للتوافق مع الكود القديم)
  static Future<String> uploadImage(File imageFile,
      {required String folder}) async {
    try {
      print('🔄 بدء رفع الصورة: ${imageFile.path}');
      print('📁 المجلد: $folder');
      print('☁️ Cloud Name: $cloudName');
      print('📤 Upload Preset: $uploadPreset');
      print('🌐 Platform: ${kIsWeb ? "Web" : "Native"}');

      // قراءة الملف كـ bytes
      Uint8List bytes;
      String filename;

      if (kIsWeb) {
        // على الويب، نقرأ الملف مباشرة
        print('🌐 قراءة الملف على الويب...');
        bytes = await imageFile.readAsBytes();
        filename = imageFile.path.split('/').last;
      } else {
        // على الأجهزة المحلية، نتحقق من وجود الملف أولاً
        print('📱 قراءة الملف على الجهاز...');
        if (!await imageFile.exists()) {
          throw Exception('الملف غير موجود: ${imageFile.path}');
        }

        final fileSize = await imageFile.length();
        print(
            '📏 حجم الملف: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

        bytes = await imageFile.readAsBytes();
        filename = imageFile.path.split('/').last;
      }

      print(
          '📦 حجم البيانات: ${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB');

      // إنشاء multipart request
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url);

      // إضافة الحقول المطلوبة
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;

      // إضافة الملف
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
        ),
      );

      print('📤 إرسال الطلب إلى Cloudinary...');

      // إرسال الطلب مع timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('انتهت مهلة رفع الصورة. يرجى المحاولة مرة أخرى.');
        },
      );

      // قراءة الاستجابة
      final response = await http.Response.fromStream(streamedResponse);

      print('📊 حالة الاستجابة: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final secureUrl = responseData['secure_url'] as String;

        print('✅ تم رفع الصورة بنجاح!');
        print('🔗 رابط الصورة: $secureUrl');

        return secureUrl;
      } else {
        print('❌ فشل رفع الصورة: ${response.statusCode}');
        print('📄 محتوى الاستجابة: ${response.body}');

        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'خطأ غير معروف';

        throw Exception('فشل في رفع الصورة: $errorMessage');
      }
    } catch (e) {
      print('❌ خطأ في رفع الصورة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');

      // معالجة أنواع مختلفة من الأخطاء
      if (e.toString().contains('Invalid upload preset')) {
        throw Exception(
            'خطأ في إعدادات Cloudinary. يرجى التحقق من Upload Preset.');
      } else if (e.toString().contains('Invalid cloud name')) {
        throw Exception(
            'خطأ في اسم حساب Cloudinary. يرجى التحقق من Cloud Name.');
      } else if (e.toString().contains('timeout')) {
        throw Exception(
            'انتهت مهلة رفع الصورة. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.');
      } else if (e.toString().contains('No such file')) {
        throw Exception('الملف غير موجود. يرجى اختيار صورة صحيحة.');
      } else {
        throw Exception(
            'فشل في رفع الصورة. تحقق من حجم الصورة واتصال الإنترنت. التفاصيل: ${e.toString()}');
      }
    }
  }

  // رفع عدة صور
  static Future<List<String>> uploadMultipleImages(List<File> imageFiles,
      {required String folder}) async {
    print('📤 بدء رفع ${imageFiles.length} صورة');
    List<String> urls = [];
    List<String> errors = [];

    for (int i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];
      print('📸 رفع الصورة ${i + 1}/${imageFiles.length}: ${imageFile.path}');

      try {
        String url = await uploadImage(imageFile, folder: folder);
        urls.add(url);
        print('✅ تم رفع الصورة ${i + 1} بنجاح');
      } catch (e) {
        print('❌ فشل في رفع الصورة ${i + 1}: $e');
        errors.add('الصورة ${i + 1}: ${e.toString()}');
        // نرمي الخطأ مباشرة بدلاً من تجاهله
        rethrow;
      }
    }

    print('📊 تم رفع ${urls.length} من أصل ${imageFiles.length} صورة');

    if (errors.isNotEmpty) {
      print('⚠️ حدثت أخطاء في رفع بعض الصور:');
      for (var error in errors) {
        print('  - $error');
      }
    }

    return urls;
  }
}
