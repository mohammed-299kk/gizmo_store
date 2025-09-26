import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/order.dart' as order_model;
import '../models/address.dart';
import '../utils/app_exceptions.dart'; // Added this line

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ------------------------------
  // Categories
  // ------------------------------
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _db.collection('categories').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'],
          'image': data['image'] ?? data['imageUrl'] ?? '',
          'icon': data['icon'] ?? '',
        };
      }).toList();
    } on FirebaseException catch (e) {
      print('Firebase Error getting categories: ${e.message}');
      throw FirestoreException('Failed to get categories: ${e.message}');
    } catch (e) {
      print('Error getting categories: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting categories: $e');
    }
  }

  // ------------------------------
  // Products
  // ------------------------------

  // Add new product
  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add(product.toMap());
    } on FirebaseException catch (e) {
      print('Firebase Error adding product: ${e.message}');
      throw FirestoreException('Failed to add product: ${e.message}');
    } catch (e) {
      print('Error adding product: $e');
      throw FirestoreException(
          'An unexpected error occurred while adding product: $e');
    }
  }

  // Get all products as Stream
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        return Product.fromMap(data, doc.id);
      }).toList();
    });
  }

  // Get all products as Future (for search functionality)
  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('products').get();
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      print('Firebase Error getting all products: ${e.message}');
      throw FirestoreException('Failed to get all products: ${e.message}');
    } catch (e) {
      print('Error getting all products: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting all products: $e');
    }
  }

  // Update existing product
  Future<void> updateProduct(Product product) async {
    try {
      await _db.collection('products').doc(product.id).update(product.toMap());
    } on FirebaseException catch (e) {
      print('Firebase Error updating product: ${e.message}');
      throw FirestoreException('Failed to update product: ${e.message}');
    } catch (e) {
      print('Error updating product: $e');
      throw FirestoreException(
          'An unexpected error occurred while updating product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
    } on FirebaseException catch (e) {
      print('Firebase Error deleting product: ${e.message}');
      throw FirestoreException('Failed to delete product: ${e.message}');
    } catch (e) {
      print('Error deleting product: $e');
      throw FirestoreException(
          'An unexpected error occurred while deleting product: $e');
    }
  }

  // Get single product by ID
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
      throw FirestoreException(
          'An unexpected error occurred while getting product by ID: $e');
    }
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('products')
          .where('featured', isEqualTo: true)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      print('Firebase Error getting featured products: ${e.message}');
      throw FirestoreException('Failed to get featured products: ${e.message}');
    } catch (e) {
      print('Error getting featured products: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting featured products: $e');
    }
  }

  // Get products by category
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
      throw FirestoreException(
          'Failed to get products by category: ${e.message}');
    } catch (e) {
      print('Error getting products by category: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting products by category: $e');
    }
  }

  // Search products with improved functionality
  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        // Return all products if query is empty
        QuerySnapshot snapshot = await _db.collection('products').get();
        return snapshot.docs.map((doc) {
          return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      }

      // Convert query to lowercase for case-insensitive search
      String lowerQuery = query.toLowerCase();

      // Get all products and filter locally for better search functionality
      QuerySnapshot snapshot = await _db.collection('products').get();

      List<Product> allProducts = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Filter products based on name, category, and brand
      List<Product> filteredProducts = allProducts.where((product) {
        String productName = product.name.toLowerCase();
        String productCategory = (product.category ?? '').toLowerCase();
        String productBrand = (product.brand ?? '').toLowerCase();

        return productName.contains(lowerQuery) ||
            productCategory.contains(lowerQuery) ||
            productBrand.contains(lowerQuery);
      }).toList();

      return filteredProducts;
    } on FirebaseException catch (e) {
      print('Firebase Error searching products: ${e.message}');
      throw FirestoreException('Failed to search products: ${e.message}');
    } catch (e) {
      print('Error searching products: $e');
      throw FirestoreException(
          'An unexpected error occurred while searching products: $e');
    }
  }

  // ------------------------------
  // Orders
  // ------------------------------

  /// Get user orders count
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

  /// Get user orders with status filtering option
  Future<List<order_model.Order>> getUserOrders(String userId,
      {String? status}) async {
    try {
      Query query = _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true);

      // Add status filter if specified
      if (status != null && status.isNotEmpty && status != 'الكل') {
        query = query.where('status', isEqualTo: status);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return order_model.Order.fromMap(data, documentId: doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      print('Firebase Error getting user orders: ${e.message}');
      throw FirestoreException('Failed to get user orders: ${e.message}');
    } catch (e) {
      print('Error getting user orders: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting user orders: $e');
    }
  }

  /// Get user orders as Stream for real-time updates
  Stream<List<order_model.Order>> getUserOrdersStream(String userId,
      {String? status}) {
    try {
      // Use simple query without orderBy to avoid composite index requirement
      Query query = _db.collection('orders').where('userId', isEqualTo: userId);

      // Add status filter if specified
      if (status != null && status.isNotEmpty && status != 'الكل') {
        query = query.where('status', isEqualTo: status);
      }

      return query.snapshots().map((snapshot) {
        var orders = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return order_model.Order.fromMap(data, documentId: doc.id);
        }).toList();

        // Sort orders by date in memory instead of using orderBy
        orders.sort((a, b) => b.date.compareTo(a.date));

        return orders;
      }).handleError((error) {
        print('Error in user orders stream: $error');
        if (error is FirebaseException) {
          throw FirestoreException(
              'Failed to get user orders: ${error.message}');
        } else {
          throw FirestoreException(
              'An unexpected error occurred while getting user orders: $error');
        }
      });
    } catch (e) {
      print('Error creating user orders stream: $e');
      // Return stream containing error instead of empty stream
      return Stream.error(
          FirestoreException('Failed to create orders stream: $e'));
    }
  }

  /// Add sample orders for testing
  Future<void> addSampleOrders(String userId) async {
    try {
      // Sample order 1
      final order1 = order_model.Order(
        id: '',
        userId: userId,
        items: [
          order_model.OrderItem(
            id: '1',
            name: 'iPhone 15 Pro Max',
            price: 1200.0,
            quantity: 1,
            image:
                'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
          ),
          order_model.OrderItem(
            id: '2',
            name: 'AirPods Pro',
            price: 250.0,
            quantity: 2,
            image:
                'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
          ),
        ],
        date: DateTime.now().subtract(const Duration(days: 2)),
        total: 1700.0,
        status: 'قيد الشحن',
        paymentMethod: 'بطاقة ائتمان',
        shippingAddress: 'الخرطوم، حي الرياض، شارع النيل',
        phoneNumber: '+249123456789',
      );

      // Sample order 2
      final order2 = order_model.Order(
        id: '',
        userId: userId,
        items: [
          order_model.OrderItem(
            id: '3',
            name: 'Samsung Galaxy S24',
            price: 900.0,
            quantity: 1,
            image:
                'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400',
          ),
        ],
        date: DateTime.now().subtract(const Duration(days: 5)),
        total: 900.0,
        status: 'تم التوصيل',
        paymentMethod: 'الدفع عند الاستلام',
        shippingAddress: 'الخرطوم بحري، حي الصحافة',
        phoneNumber: '+249123456789',
      );

      // Sample order 3
      final order3 = order_model.Order(
        id: '',
        userId: userId,
        items: [
          order_model.OrderItem(
            id: '4',
            name: 'MacBook Pro 14"',
            price: 2500.0,
            quantity: 1,
            image:
                'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400',
          ),
        ],
        date: DateTime.now().subtract(const Duration(days: 1)),
        total: 2500.0,
        status: 'قيد التحضير',
        paymentMethod: 'بطاقة ائتمان',
        shippingAddress: 'أم درمان، حي الثورة',
        phoneNumber: '+249123456789',
      );

      await _db.collection('orders').add(order1.toMap());
      await _db.collection('orders').add(order2.toMap());
      await _db.collection('orders').add(order3.toMap());

      print('Sample orders added successfully');
    } catch (e) {
      print('Error adding sample orders: $e');
    }
  }

  /// Add sample wishlist items for testing
  Future<void> addSampleWishlistItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      final userId = user.uid;

      // Sample wishlist items
      final wishlistItems = [
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'productId': '1',
          'productName': 'iPhone 15 Pro',
          'productPrice': 1200.0,
          'productImage':
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
          'dateAdded': DateTime.now().toIso8601String(),
        },
        {
          'id': (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          'productId': '2',
          'productName': 'Samsung Galaxy Watch',
          'productPrice': 350.0,
          'productImage':
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
          'dateAdded': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
        },
        {
          'id': (DateTime.now().millisecondsSinceEpoch + 2).toString(),
          'productId': '3',
          'productName': 'AirPods Pro',
          'productPrice': 250.0,
          'productImage':
              'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
          'dateAdded': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        },
      ];

      for (var item in wishlistItems) {
        await _db
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .doc(item['id'] as String)
            .set(item);
      }

      print('Sample wishlist items added successfully');
    } catch (e) {
      print('Error adding sample wishlist items: $e');
    }
  }

  /// Add new order
  Future<String> addOrder(order_model.Order order) async {
    try {
      final docRef = await _db.collection('orders').add(order.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Error adding order: ${e.message}');
      throw FirestoreException('Failed to add order: ${e.message}');
    } catch (e) {
      print('Error adding order: $e');
      throw FirestoreException(
          'An unexpected error occurred while adding order: $e');
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      print('Firebase Error updating order status: ${e.message}');
      throw FirestoreException('Failed to update order status: ${e.message}');
    } catch (e) {
      print('Error updating order status: $e');
      throw FirestoreException(
          'An unexpected error occurred while updating order status: $e');
    }
  }

  /// Get single order by ID
  Future<order_model.Order?> getOrderById(String orderId) async {
    try {
      final doc = await _db.collection('orders').doc(orderId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return order_model.Order.fromMap(data, documentId: doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Error getting order by ID: ${e.message}');
      throw FirestoreException('Failed to get order by ID: ${e.message}');
    } catch (e) {
      print('Error getting order by ID: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting order by ID: $e');
    }
  }

  // ------------------------------
  // Address management
  // ------------------------------

  // Fetch user addresses
  Stream<List<Address>> getUserAddresses(String userId) {
    try {
      return _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Address.fromFirestore(doc.data(), doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error getting user addresses: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting addresses: $e');
    }
  }

  // Add new address
  Future<String> addAddress(String userId, Address address) async {
    try {
      // If new address is default, remove default from other addresses
      if (address.isDefault) {
        await _setAllAddressesNonDefault(userId);
      }

      final docRef = await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .add(address.toFirestore());

      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Error adding address: ${e.message}');
      throw FirestoreException('Failed to add address: ${e.message}');
    } catch (e) {
      print('Error adding address: $e');
      throw FirestoreException(
          'An unexpected error occurred while adding address: $e');
    }
  }

  // Update existing address
  Future<void> updateAddress(
      String userId, String addressId, Address address) async {
    try {
      // If updated address is default, remove default from other addresses
      if (address.isDefault) {
        await _setAllAddressesNonDefault(userId, excludeAddressId: addressId);
      }

      await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .update(address.toFirestore());
    } on FirebaseException catch (e) {
      print('Firebase Error updating address: ${e.message}');
      throw FirestoreException('Failed to update address: ${e.message}');
    } catch (e) {
      print('Error updating address: $e');
      throw FirestoreException(
          'An unexpected error occurred while updating address: $e');
    }
  }

  // Delete address
  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
    } on FirebaseException catch (e) {
      print('Firebase Error deleting address: ${e.message}');
      throw FirestoreException('Failed to delete address: ${e.message}');
    } catch (e) {
      print('Error deleting address: $e');
      throw FirestoreException(
          'An unexpected error occurred while deleting address: $e');
    }
  }

  // Set address as default
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      // Remove default from all addresses
      await _setAllAddressesNonDefault(userId);

      // Set specified address as default
      await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .update({
        'isDefault': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      print('Firebase Error setting default address: ${e.message}');
      throw FirestoreException('Failed to set default address: ${e.message}');
    } catch (e) {
      print('Error setting default address: $e');
      throw FirestoreException(
          'An unexpected error occurred while setting default address: $e');
    }
  }

  // Fetch default address
  Future<Address?> getDefaultAddress(String userId) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return Address.fromFirestore(doc.data(), doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Error getting default address: ${e.message}');
      throw FirestoreException('Failed to get default address: ${e.message}');
    } catch (e) {
      print('Error getting default address: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting default address: $e');
    }
  }

  // Fetch specific address
  Future<Address?> getAddress(String userId, String addressId) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Address.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Error getting address: ${e.message}');
      throw FirestoreException('Failed to get address: ${e.message}');
    } catch (e) {
      print('Error getting address: $e');
      throw FirestoreException(
          'An unexpected error occurred while getting address: $e');
    }
  }

  // Helper function to remove default from all addresses
  Future<void> _setAllAddressesNonDefault(String userId,
      {String? excludeAddressId}) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .get();

      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        if (excludeAddressId == null || doc.id != excludeAddressId) {
          batch.update(doc.reference, {
            'isDefault': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      await batch.commit();
    } catch (e) {
      print('Error setting addresses non-default: $e');
      throw FirestoreException(
          'An unexpected error occurred while updating addresses: $e');
    }
  }
}
