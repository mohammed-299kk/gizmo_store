// lib/providers/wishlist_provider.dart
import 'dart:async';
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
  StreamSubscription<QuerySnapshot>? _wishlistSubscription;
  StreamSubscription<User?>? _authSubscription;

  List<WishlistItem> get items => [..._items];
  bool get isLoading => _isLoading;
  int get itemCount => _items.length;

  WishlistProvider() {
    _initializeAuthListener();
  }

  // Initialize auth state listener
  void _initializeAuthListener() {
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _startWishlistListener();
      } else {
        _stopWishlistListener();
        _items.clear();
        notifyListeners();
      }
    });
  }

  // Start real-time wishlist listener
  void _startWishlistListener() {
    final user = _auth.currentUser;
    if (user == null) return;

    _wishlistSubscription?.cancel();
    _wishlistSubscription = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .listen(_handleWishlistSnapshot, onError: _handleWishlistError);
  }

  // Handle wishlist snapshot changes
  Future<void> _handleWishlistSnapshot(QuerySnapshot snapshot) async {
    try {
      final List<WishlistItem> newItems = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        try {
          // إنشاء WishlistItem من البيانات المحفوظة مباشرة
          final wishlistItem = WishlistItem.fromMap(data);
          newItems.add(wishlistItem);
        } catch (e) {
          print('Error creating wishlist item from data: $e');
          // في حالة فشل إنشاء العنصر، نحاول الطريقة القديمة كـ fallback
          try {
            final productSnapshot = await _firestore
                .collection('products')
                .doc(data['productId'])
                .get();
            
            if (productSnapshot.exists) {
              final product = Product.fromMap(productSnapshot.data()!, productSnapshot.id);
              final wishlistItem = WishlistItem(
                id: data['id'] ?? '',
                product: product,
                dateAdded: DateTime.parse(data['dateAdded'] ?? DateTime.now().toIso8601String()),
              );
              newItems.add(wishlistItem);
            }
          } catch (fallbackError) {
            print('Fallback method also failed: $fallbackError');
          }
        }
      }
      
      _items.clear();
      _items.addAll(newItems);
      notifyListeners();
    } catch (e) {
      print('Error handling wishlist snapshot: $e');
    }
  }

  // Handle wishlist listener errors
  void _handleWishlistError(error) {
    print('Wishlist listener error: $error');
  }

  // Stop wishlist listener
  void _stopWishlistListener() {
    _wishlistSubscription?.cancel();
    _wishlistSubscription = null;
  }

  @override
  void dispose() {
    _wishlistSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  // Check if product exists in wishlist
  bool isInWishlist(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Add product to wishlist
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

      // Save to Firebase - the listener will handle updating the list automatically
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(wishlistItem.id)
          .set(wishlistItem.toMap());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to add product to wishlist: $e');
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final itemIndex = _items.indexWhere((item) => item.product.id == productId);
      if (itemIndex == -1) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final item = _items[itemIndex];

      // Delete from Firebase - the listener will handle updating the list automatically
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(item.id)
          .delete();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to remove product from wishlist: $e');
    }
  }

  // Toggle product wishlist status
  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  // Load wishlist from Firebase (deprecated - use real-time listener instead)
  @deprecated
  Future<void> loadWishlist() async {
    // This method is no longer needed as the real-time listener handles updates automatically
    print('loadWishlist is deprecated. Real-time listener handles updates automatically.');
  }

  // Clear all wishlist items
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
      // The listener will handle clearing the list automatically
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to clear wishlist: $e');
    }
  }
}
