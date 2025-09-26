import 'package:cloud_firestore/cloud_firestore.dart';

/// خدمة إدارة الفئات
class CategoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'categories';

  /// الحصول على جميع الفئات
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(_collection).orderBy('name').get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'isActive': data['isActive'] ?? true,
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
        };
      }).toList();
    } catch (e) {
      throw Exception('فشل في تحميل الفئات: $e');
    }
  }

  /// إضافة فئة جديدة
  static Future<String> addCategory({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'name': name,
        'description': description,
        'imageUrl': imageUrl ?? '',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('فشل في إضافة الفئة: $e');
    }
  }

  /// تحديث فئة موجودة
  static Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String description,
    String? imageUrl,
    bool? isActive,
  }) async {
    try {
      await _firestore.collection(_collection).doc(categoryId).update({
        'name': name,
        'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (isActive != null) 'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('فشل في تحديث الفئة: $e');
    }
  }

  /// حذف فئة
  static Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection(_collection).doc(categoryId).delete();
    } catch (e) {
      throw Exception('فشل في حذف الفئة: $e');
    }
  }

  /// الحصول على فئة بواسطة المعرف
  static Future<Map<String, dynamic>?> getCategoryById(
      String categoryId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection(_collection).doc(categoryId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'isActive': data['isActive'] ?? true,
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
        };
      }
      return null;
    } catch (e) {
      throw Exception('فشل في تحميل الفئة: $e');
    }
  }

  /// البحث في الفئات
  static Future<List<Map<String, dynamic>>> searchCategories(
      String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'isActive': data['isActive'] ?? true,
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
        };
      }).toList();
    } catch (e) {
      throw Exception('فشل في البحث في الفئات: $e');
    }
  }
}
