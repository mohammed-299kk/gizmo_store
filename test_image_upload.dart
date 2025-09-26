import 'dart:io';
import 'package:flutter/material.dart';
import 'lib/services/image_upload_service.dart';
import 'lib/services/product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 بدء اختبار خدمات رفع الصور...');
  
  // اختبار 1: محاولة رفع قائمة فارغة من الصور
  try {
    print('\n📋 اختبار 1: رفع قائمة فارغة من الصور');
    final urls = await ImageUploadService.uploadProductImages([]);
    print('✅ النتيجة: ${urls.length} URLs تم إرجاعها');
    print('📊 URLs: $urls');
  } catch (e) {
    print('❌ خطأ في الاختبار 1: $e');
  }
  
  // اختبار 2: محاولة استخدام .first على قائمة فارغة (محاكاة الخطأ السابق)
  try {
    print('\n📋 اختبار 2: محاكاة استخدام .first على قائمة فارغة');
    List<String> emptyList = [];
    if (emptyList.isNotEmpty) {
      final first = emptyList.first;
      print('✅ تم الحصول على العنصر الأول: $first');
    } else {
      print('⚠️ القائمة فارغة - تم تجنب خطأ "Bad state: No element"');
    }
  } catch (e) {
    print('❌ خطأ في الاختبار 2: $e');
  }
  
  print('\n🎉 انتهى الاختبار');
}