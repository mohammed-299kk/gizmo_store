import 'package:flutter/foundation.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  // إضافة منتج إلى السلة
  void addItem(Product product, [int quantity = 1]) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  // إزالة منتج من السلة
  void removeItem(String productId, [int quantity = 1]) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (_items[index].quantity <= quantity) {
        _items.removeAt(index);
      } else {
        _items[index].quantity -= quantity;
      }

      notifyListeners();
    }
  }

  // تحديث كمية منتج
  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }

      notifyListeners();
    }
  }

  // تفريغ السلة
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // التحقق من وجود منتج في السلة
  bool containsProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // الحصول على كمية منتج معين
  int getProductQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }
}
