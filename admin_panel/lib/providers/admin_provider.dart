import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/user_model.dart';
import '../models/dashboard_stats.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  String? _errorMessage;
  
  // Dashboard data
  DashboardStats? _dashboardStats;
  
  // Products data
  List<Product> _products = [];
  final List<String> _categories = [];
  
  // Orders data
  List<OrderModel> _orders = [];
  
  // Users data
  List<UserModel> _users = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardStats? get dashboardStats => _dashboardStats;
  List<Product> get products => _products;
  List<String> get categories => _categories;
  List<OrderModel> get orders => _orders;
  List<UserModel> get users => _users;

  // Dashboard Methods
  Future<void> loadDashboardStats() async {
    try {
      _setLoading(true);
      
      // Get total users
      final usersSnapshot = await _firestore.collection('users').get();
      final totalUsers = usersSnapshot.docs.length;
      
      // Get total products
      final productsSnapshot = await _firestore.collection('products').get();
      final totalProducts = productsSnapshot.docs.length;
      
      // Get total orders
      final ordersSnapshot = await _firestore.collection('orders').get();
      final totalOrders = ordersSnapshot.docs.length;
      
      // Get pending orders
      final pendingOrdersSnapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .get();
      final pendingOrders = pendingOrdersSnapshot.docs.length;
      
      // Calculate total sales
      double totalSales = 0;
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        if (data['status'] == 'delivered') {
          totalSales += (data['total'] ?? 0).toDouble();
        }
      }
      
      _dashboardStats = DashboardStats(
        totalUsers: totalUsers,
        totalProducts: totalProducts,
        totalOrders: totalOrders,
        pendingOrders: pendingOrders,
        totalSales: totalSales,
      );
      
    } catch (e) {
      _errorMessage = 'Failed to load dashboard stats: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Products Methods
  Future<void> loadProducts() async {
    try {
      _setLoading(true);
      final snapshot = await _firestore.collection('products').get();
      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromFirestore(doc.id, data);
      }).toList();
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      _setLoading(true);
      await _firestore.collection('products').add(product.toMap());
      await loadProducts(); // Refresh the list
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    try {
      _setLoading(true);
      await _firestore.collection('products').doc(productId).update(product.toMap());
      await loadProducts(); // Refresh the list
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      _setLoading(true);
      await _firestore.collection('products').doc(productId).delete();
      await loadProducts(); // Refresh the list
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Orders Methods
  Future<void> loadOrders() async {
    try {
      _setLoading(true);
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();
      _orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromFirestore(doc.id, data);
      }).toList();
    } catch (e) {
      _errorMessage = 'Failed to load orders: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      _setLoading(true);
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadOrders(); // Refresh the list
    } catch (e) {
      _errorMessage = 'Failed to update order status: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Users Methods
  Future<void> loadUsers() async {
    try {
      _setLoading(true);
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromFirestore(doc.id, data);
      }).toList();
    } catch (e) {
      _errorMessage = 'Failed to load users: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleUserStatus(String userId, bool isBlocked) async {
    try {
      _setLoading(true);
      await _firestore.collection('users').doc(userId).update({
        'isBlocked': isBlocked,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadUsers(); // Refresh the list
    } catch (e) {
      _errorMessage = 'Failed to update user status: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Utility Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
