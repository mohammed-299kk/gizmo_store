// lib/providers/wishlist_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wishlist_item.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<WishlistItem> _items = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  List<WishlistItem> get items => [..._items];
  bool get isLoading => _isLoading;
  int get itemCount => _items.length;

  // التحقق من وجود منتج في المفضلة
  bool isInWishlist(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // إضافة منتج للمفضلة
  Future<void> addToWishlist(Product product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (isInWishlist(product.id)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final wishlistItem = WishlistItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        dateAdded: DateTime.now(),
      );

      // حفظ في Firebase
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(wishlistItem.id)
          .set(wishlistItem.toMap());

      _items.add(wishlistItem);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('فشل في إضافة المنتج للمفضلة: $e');
    }
  }

  // إزالة منتج من المفضلة
  Future<void> removeFromWishlist(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final itemIndex = _items.indexWhere((item) => item.product.id == productId);
      if (itemIndex == -1) return;

      final item = _items[itemIndex];

      // حذف من Firebase
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(item.id)
          .delete();

      _items.removeAt(itemIndex);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('فشل في إزالة المنتج من المفضلة: $e');
    }
  }

  // تبديل حالة المنتج في المفضلة
  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  // تحميل المفضلة من Firebase
  Future<void> loadWishlist() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .orderBy('dateAdded', descending: true)
          .get();

      _items.clear();
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // هنا نحتاج لجلب بيانات المنتج الكاملة
        final productSnapshot = await _firestore
            .collection('products')
            .doc(data['productId'])
            .get();
        
        if (productSnapshot.exists) {
          final product = Product.fromMap(productSnapshot.data()!, productSnapshot.id);
          final wishlistItem = WishlistItem.fromMap(data, product);
          _items.add(wishlistItem);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('فشل في تحميل المفضلة: $e');
    }
  }

  // مسح جميع المفضلة
  Future<void> clearWishlist() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      _items.clear();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('فشل في مسح المفضلة: $e');
    }
  }
}
