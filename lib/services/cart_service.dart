// lib/services/cart_service.dart
import '../models/cart_item.dart';

/// خدمة إدارة السلة (Cart) بشكل ثابت (Static) عبر التطبيق
class CartService {
  // قائمة العناصر في السلة (خاصة بالخدمة)
  static final List<CartItem> _items = [];

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
    }
  }

  /// إزالة عنصر من السلة
  static void removeItem(String productId) {
    _items.removeWhere((e) => e.product.id == productId);
  }

  /// تنظيف السلة بالكامل
  static void clear() {
    _items.clear();
  }

  /// حساب المجموع الكلي للسلة
  static double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// التحقق إذا كانت السلة فارغة
  static bool get isEmpty => _items.isEmpty;
}
