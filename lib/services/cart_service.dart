import 'dart:async';
import '../models/cart_item.dart';

/// Cart management service (Cart) statically across the application
class CartService {
  ///// List of items in cart (service-specific)
  static final List<CartItem> _items = [];
  
  // Stream Controller to track cart changes
  static final StreamController<List<CartItem>> _cartController = 
      StreamController<List<CartItem>>.broadcast();
  
  static final StreamController<int> _cartCountController = 
      StreamController<int>.broadcast();

  /// Stream to listen to cart changes
  static Stream<List<CartItem>> get cartStream => _cartController.stream;
  
  /// Stream to track number of items in cart
  static Stream<int> get cartCountStream => _cartCountController.stream;

  /// Get all items without allowing external modification
  static List<CartItem> getItems() => List.unmodifiable(_items);

  /// Add item to cart
  static void addItem(CartItem item) {
    final index = _items.indexWhere((e) => e.product.id == item.product.id);
    if (index >= 0) {
      // If item exists, increase quantity
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    _notifyListeners();
  }

  /// Update quantity of specific item
  static void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((e) => e.product.id == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        // Remove item if quantity is zero or less
        _items.removeAt(index);
      }
      _notifyListeners();
    }
  }

  /// Remove item from cart
  static Future<void> removeItem(String productId) async {
    _items.removeWhere((e) => e.product.id == productId);
    _notifyListeners();
  }

  /// Clear entire cart
  static Future<void> clear() async {
    _items.clear();
    _notifyListeners();
  }

  /// Calculate total cart amount
  static double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Check if cart is empty
  static bool get isEmpty => _items.isEmpty;
  
  /// Number of items in cart
  static int get itemCount => _items.length;
  
  /// Total quantity in cart
  static int get totalQuantity => 
      _items.fold(0, (sum, item) => sum + item.quantity);

  // --- Methods to add for compatibility ---

  static Future<void> loadCart() async {
    // Simulate a network call
    await Future.delayed(const Duration(milliseconds: 100));
    _notifyListeners(); // Notify listeners in case they depend on load
  }

  static Future<void> increaseQuantity(String productId) async {
    final index = _items.indexWhere((e) => e.product.id == productId);
    if (index >= 0) {
      updateQuantity(productId, _items[index].quantity + 1);
    }
  }

  static Future<void> decreaseQuantity(String productId) async {
    final index = _items.indexWhere((e) => e.product.id == productId);
    if (index >= 0 && _items[index].quantity > 1) {
      updateQuantity(productId, _items[index].quantity - 1);
    } else if (index >= 0 && _items[index].quantity <= 1) {
      removeItem(productId);
    }
  }

  static Map<String, dynamic> getCartSummary() {
    return {
      'subtotal': totalPrice,
      'shipping': 15.0, // Example shipping cost
      'total': totalPrice + 15.0,
    };
  }

  /// Notify listeners of changes
  static void _notifyListeners() {
    _cartController.add(List.unmodifiable(_items));
    _cartCountController.add(totalQuantity);
  }

  /// Check if product exists in cart
  static bool containsProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Get quantity of specific product in cart
  static int getProductQuantity(String productId) {
    final index = _items.indexWhere((e) => e.product.id == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }

  /// Clean up resources
  static void dispose() {
    _cartController.close();
    _cartCountController.close();
  }
}
