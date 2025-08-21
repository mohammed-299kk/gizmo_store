// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? image;
  final List<String>? images;
  final double? rating;
  final int? reviewsCount;
  final String? category;
  final int? discount;
  final List<String>? specifications;
  final List<Map<String, dynamic>>? reviews;
  final bool featured;
  final String currency;
  final String location;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.originalPrice,
    this.image,
    this.images,
    this.rating,
    this.reviewsCount,
    this.category,
    this.discount,
    this.specifications,
    this.reviews,
    this.featured = false,
    this.currency = 'جنيه سوداني',
    this.location = 'الخرطوم، السودان',
  });

  // تحويل من Map إلى Product
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: (map['originalPrice'] ?? 0).toDouble(),
      image: map['image'],
      images: List<String>.from(map['images'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      reviewsCount: map['reviewsCount'],
      category: map['category'],
      discount: map['discount'] ?? 0,
      specifications: List<String>.from(map['specifications'] ?? []),
      reviews: (map['reviews'] as List?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList(),
      featured: map['featured'] ?? false,
      currency: map['currency'] ?? 'جنيه سوداني',
      location: map['location'] ?? 'الخرطوم، السودان',
    );
  }

  // تحويل Product إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'images': images,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'category': category,
      'discount': discount,
      'specifications': specifications,
      'reviews': reviews,
      'featured': featured,
      'currency': currency,
      'location': location,
    };
  }
}
