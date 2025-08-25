import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../utils/app_exceptions.dart'; // Added this line

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
    } on FirebaseException catch (e) {
      print('Firebase Error getting categories: ${e.message}');
      throw FirestoreException('Failed to get categories: ${e.message}');
    } catch (e) {
      print('Error getting categories: $e');
      throw FirestoreException('An unexpected error occurred while getting categories: $e');
    }
  }

  // ------------------------------
  // المنتجات
  // ------------------------------

  // إضافة منتج جديد
  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add(product.toMap());
    } on FirebaseException catch (e) {
      print('Firebase Error adding product: ${e.message}');
      throw FirestoreException('Failed to add product: ${e.message}');
    } catch (e) {
      print('Error adding product: $e');
      throw FirestoreException('An unexpected error occurred while adding product: $e');
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
    } on FirebaseException catch (e) {
      print('Firebase Error updating product: ${e.message}');
      throw FirestoreException('Failed to update product: ${e.message}');
    } catch (e) {
      print('Error updating product: $e');
      throw FirestoreException('An unexpected error occurred while updating product: $e');
    }
  }

  // حذف منتج
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
    } on FirebaseException catch (e) {
      print('Firebase Error deleting product: ${e.message}');
      throw FirestoreException('Failed to delete product: ${e.message}');
    } catch (e) {
      print('Error deleting product: $e');
      throw FirestoreException('An unexpected error occurred while deleting product: $e');
    }
  }

  // جلب منتج واحد حسب الـ ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _db.collection('products').doc(productId).get();
      if (doc.exists) {
        return Product.fromMap(doc.data()!, doc.id);
      }
      return null; // Product not found, not an error
    } on FirebaseException catch (e) {
      print('Firebase Error getting product by ID: ${e.message}');
      throw FirestoreException('Failed to get product by ID: ${e.message}');
    } catch (e) {
      print('Error getting product by ID: $e');
      throw FirestoreException('An unexpected error occurred while getting product by ID: $e');
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
    } on FirebaseException catch (e) {
      print('Firebase Error getting featured products: ${e.message}');
      throw FirestoreException('Failed to get featured products: ${e.message}');
    } catch (e) {
      print('Error getting featured products: $e');
      throw FirestoreException('An unexpected error occurred while getting featured products: $e');
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
    } on FirebaseException catch (e) {
      print('Firebase Error getting products by category: ${e.message}');
      throw FirestoreException('Failed to get products by category: ${e.message}');
    } catch (e) {
      print('Error getting products by category: $e');
      throw FirestoreException('An unexpected error occurred while getting products by category: $e');
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
    } on FirebaseException catch (e) {
      print('Firebase Error searching products: ${e.message}');
      throw FirestoreException('Failed to search products: ${e.message}');
    } catch (e) {
      print('Error searching products: $e');
      throw FirestoreException('An unexpected error occurred while searching products: $e');
    }
  }

  // ------------------------------
  // الطلبات
  // ------------------------------
  Future<int> getUserOrderCount(String userId) async {
    try {
      final snapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.size;
    } on FirebaseException catch (e) {
      print('Firebase Error getting user order count: ${e.message}');
      throw FirestoreException('Failed to get user order count: ${e.message}');
    } catch (e) {
      print('Error getting user order count: $e');
      throw FirestoreException('An unexpected error occurred: $e');
    }
  }
}
