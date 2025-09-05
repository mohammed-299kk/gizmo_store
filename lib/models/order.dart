// استيراد CartItem من نفس المجلد
import 'cart_item.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

/// نموذج الطلب المحسن مع جميع الحقول المطلوبة للتكامل مع Firebase
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final DateTime date;
  final double total;
  final String status;
  final String paymentMethod; // إضافة حقل طريقة الدفع
  final String? shippingAddress;
  final String? phoneNumber;
  final String? notes;
  final DateTime? deliveryDate;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.date,
    required this.total,
    required this.status,
    required this.paymentMethod, // إضافة حقل طريقة الدفع كحقل مطلوب
    this.shippingAddress,
    this.phoneNumber,
    this.notes,
    this.deliveryDate,
  });

  /// تحويل Order إلى Map لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'total': total,
      'status': status,
      'paymentMethod': paymentMethod, // إضافة حقل طريقة الدفع
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      'notes': notes,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  /// إنشاء Order من Map مأخوذة من Firestore
  factory Order.fromMap(Map<String, dynamic> map, {String? documentId}) {
    // تحويل قائمة العناصر من Map إلى OrderItem
    final itemsList = (map['items'] as List<dynamic>? ?? [])
        .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return Order(
      id: documentId ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: itemsList,
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      paymentMethod: map['paymentMethod'] ?? 'cash_on_delivery', // إضافة حقل طريقة الدفع مع قيمة افتراضية
      shippingAddress: map['shippingAddress'],
      phoneNumber: map['phoneNumber'],
      notes: map['notes'],
      deliveryDate: map['deliveryDate'] != null 
          ? DateTime.parse(map['deliveryDate']) 
          : null,
    );
  }

  /// نسخ الطلب مع تعديل بعض الحقول
  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    DateTime? date,
    double? total,
    String? status,
    String? paymentMethod,
    String? shippingAddress,
    String? phoneNumber,
    String? notes,
    DateTime? deliveryDate,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      date: date ?? this.date,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }
}

/// نموذج عنصر الطلب
class OrderItem {
  final String id;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String? size;
  final String? color;

  OrderItem({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
  });

  /// تحويل OrderItem إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  /// إنشاء OrderItem من Map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'],
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      size: map['size'],
      color: map['color'],
    );
  }

  /// إنشاء OrderItem من CartItem
  factory OrderItem.fromCartItem(CartItem cartItem) {
    return OrderItem(
      id: cartItem.product.id,
      name: cartItem.product.name,
      image: cartItem.product.image,
      price: cartItem.product.price,
      quantity: cartItem.quantity,
      size: '', // CartItem doesn't have size, using empty string
      color: '', // CartItem doesn't have color, using empty string
    );
  }

  /// تحويل قائمة CartItem إلى قائمة OrderItem
  static List<OrderItem> fromCartItems(List<CartItem> cartItems) {
    return cartItems.map((cartItem) => OrderItem(
      id: cartItem.product.id,
      name: cartItem.product.name,
      image: cartItem.product.image,
      price: cartItem.product.price,
      quantity: cartItem.quantity,
      size: '', // CartItem doesn't have size, using empty string
      color: '', // CartItem doesn't have color, using empty string
    )).toList();
  }

  /// نسخ العنصر مع تعديل بعض الحقول
  OrderItem copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? size,
    String? color,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}
