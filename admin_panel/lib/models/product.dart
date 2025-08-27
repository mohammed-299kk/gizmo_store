class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? image;
  final List<String>? images;
  final String category;
  final bool featured;
  final bool isAvailable;
  final int? stock;
  final double? rating;
  final int? reviewsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.image,
    this.images,
    required this.category,
    this.featured = false,
    this.isAvailable = true,
    this.stock,
    this.rating,
    this.reviewsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromFirestore(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice']?.toDouble(),
      image: data['image'],
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      category: data['category'] ?? '',
      featured: data['featured'] ?? false,
      isAvailable: data['isAvailable'] ?? true,
      stock: data['stock'],
      rating: data['rating']?.toDouble(),
      reviewsCount: data['reviewsCount'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'images': images,
      'category': category,
      'featured': featured,
      'isAvailable': isAvailable,
      'stock': stock,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? image,
    List<String>? images,
    String? category,
    bool? featured,
    bool? isAvailable,
    int? stock,
    double? rating,
    int? reviewsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      image: image ?? this.image,
      images: images ?? this.images,
      category: category ?? this.category,
      featured: featured ?? this.featured,
      isAvailable: isAvailable ?? this.isAvailable,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
