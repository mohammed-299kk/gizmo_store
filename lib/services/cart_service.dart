import 'dart:async';
import '../models/cart_item.dart';

/// خدمة إدارة السلة (Cart) بشكل ثابت (Static) عبر التطبيق
class CartService {
  // قائمة العناصر في السلة (خاصة بالخدمة)
  static final List<CartItem> _items = [];
  
  // Stream Controller لتتبع تغييرات السلة
  static final StreamController<List<CartItem>> _cartController = 
      StreamController<List<CartItem>>.broadcast();
  
  static final StreamController<int> _cartCountController = 
      StreamController<int>.broadcast();

  /// Stream للاستماع لتغييرات السلة
  static Stream<List<CartItem>> get cartStream => _cartController.stream;
  
  /// Stream لتتبع عدد العناصر في السلة
  static Stream<int> get cartCountStream => _cartCountController.stream;

  /// الحصول على كل العناصر بدون السماح بالتعديل من الخارج
  static List<CartItem> getItems() => List.unmodifiable(_items);

  /// إضافة عنصر للسلة
  static void addItem(CartItem item) {
    final index = _items.indexWhere((e) => e.product.id == item.product.id);
    if (index >= 0) {
      // إذا العنصر موجود، زيادة الكمية
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    _notifyListeners();
  }

  /// تحديث كمية عنصر معين
  static void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((e) => e.product.id == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        // إزالة العنصر إذا كانت الكمية صفر أو أقل
        _items.removeAt(index);
      }
      _notifyListeners();
    }
  }

  /// إزالة عنصر من السلة
  static Future<void> removeItem(String productId) async {
    _items.removeWhere((e) => e.product.id == productId);
    _notifyListeners();
  }

  /// تنظيف السلة بالكامل
  static Future<void> clear() async {
    _items.clear();
    _notifyListeners();
  }

  /// حساب المجموع الكلي للسلة
  static double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// التحقق إذا كانت السلة فارغة
  static bool get isEmpty => _items.isEmpty;
  
  /// عدد العناصر في السلة
  static int get itemCount => _items.length;
  
  /// إجمالي الكمية في السلة
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

  /// إشعار المستمعين بالتغييرات
  static void _notifyListeners() {
    _cartController.add(List.unmodifiable(_items));
    _cartCountController.add(totalQuantity);
  }

  /// التحقق من وجود منتج في السلة
  static bool containsProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// الحصول على كمية منتج معين في السلة
  static int getProductQuantity(String productId) {
    final index = _items.indexWhere((e) => e.product.id == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }

  /// تنظيف الموارد
  static void dispose() {
    _cartController.close();
    _cartCountController.close();
  }
}