class OrderModel {
  final String? id;
  final String userId;
  final String userEmail;
  final String userName;
  final List<OrderItem> items;
  final double total;
  final String status;
  final String? shippingAddress;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.items,
    required this.total,
    required this.status,
    this.shippingAddress,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromFirestore(String id, Map<String, dynamic> data) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      total: (data['total'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      shippingAddress: data['shippingAddress'],
      phoneNumber: data['phoneNumber'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      productImage: data['productImage'],
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
    };
  }
}
