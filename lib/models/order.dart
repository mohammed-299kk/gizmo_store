// استيراد CartItem من نفس المجلد
import 'cart_item.dart';

class Order {
  final List<CartItem> items;
  final DateTime date;
  final double total;

  Order({
    required this.items,
    required this.date,
    required this.total,
  });

  // تحويل Order إلى Map لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'total': total,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // إنشاء Order من Map مأخوذة من Firestore أو أي مصدر بيانات
  factory Order.fromMap(Map<String, dynamic> map) {
    // تحويل قائمة العناصر من Map إلى CartItem
    final itemsList = (map['items'] as List<dynamic>? ?? [])
        .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return Order(
      items: itemsList,
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      total: (map['total'] ?? 0).toDouble(),
    );
  }
}
