import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ------------------------------
  // التصنيفات
  // ------------------------------
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _db.collection('categories').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'image': doc['image'],
          'icon': doc['icon'],
        };
      }).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // ------------------------------
  // المنتجات
  // ------------------------------

  // إضافة منتج جديد
  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add(product.toMap());
    } catch (e) {
      throw "فشل إضافة المنتج: $e";
    }
  }

  // جلب جميع المنتجات كـ Stream
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromMap(data, doc.id);
      }).toList();
    });
  }

  // تحديث منتج موجود
  Future<void> updateProduct(Product product) async {
    try {
      await _db.collection('products').doc(product.id).update(product.toMap());
    } catch (e) {
      throw "فشل تحديث المنتج: $e";
    }
  }

  // حذف منتج
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
    } catch (e) {
      throw "فشل حذف المنتج: $e";
    }
  }

  // جلب منتج واحد حسب الـ ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _db.collection('products').doc(productId).get();
      if (doc.exists) {
        return Product.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  // جلب المنتجات المميزة
  Future<List<Product>> getFeaturedProducts() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('products')
          .where('featured', isEqualTo: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting featured products: $e');
      return [];
    }
  }

  // جلب المنتجات حسب التصنيف
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  // البحث عن المنتجات
  Future<List<Product>> searchProducts(String query) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
