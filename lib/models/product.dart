// lib/models/product.dart
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? image;
  final List<String>? images;

  // Getter for imageUrl compatibility
  // يعيد أول صورة من القائمة، أو الصورة الرئيسية، أو صورة افتراضية
  String? get imageUrl {
    // أولاً: جرب الصورة الرئيسية
    if (image != null && image!.isNotEmpty) {
      return image;
    }
    // ثانياً: جرب أول صورة من القائمة
    if (images != null && images!.isNotEmpty) {
      return images!.first;
    }
    // أخيراً: صورة افتراضية
    return 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=300&fit=crop&crop=center';
  }

  final double rating;
  final int reviewsCount;
  final String category;
  final String brand;
  final int discount;
  final List<String>? specifications;
  final List<Map<String, dynamic>>? reviews;
  final bool featured;
  final bool isAvailable;
  final String currency;
  final String location;
  final int? stock;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.originalPrice,
    this.image,
    this.images,
    this.rating = 4.5,
    this.reviewsCount = 0,
    this.category = 'uncategorized',
    this.brand = '',
    this.discount = 0,
    this.specifications,
    this.reviews,
    this.featured = false,
    this.isAvailable = true,
    this.currency = '',
    this.location = '',
    this.stock,
    this.createdAt,
  });

  // تحويل من Map إلى Product
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] != null
          ? (map['price'] is String
              ? double.tryParse(map['price']) ?? 0.0
              : (map['price']).toDouble())
          : 0.0,
      originalPrice: map['originalPrice'] != null
          ? (map['originalPrice'] is String
              ? double.tryParse(map['originalPrice'])
              : (map['originalPrice']).toDouble())
          : null,
      image: map['image'] ??
          map['imageUrl'], // Support both 'image' and 'imageUrl'
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      rating: map['rating'] != null
          ? (map['rating'] is String
              ? double.tryParse(map['rating']) ?? 4.5
              : (map['rating']).toDouble())
          : 4.5,
      reviewsCount: map['reviewsCount'] ??
          map['reviewCount'] ??
          0, // Support both field names
      category: map['category'] ?? 'uncategorized',
      brand: map['brand'] ?? '',
      discount: map['discount'] ?? 0,
      specifications: map['specifications'] != null
          ? (map['specifications'] is Map
              ? (map['specifications'] as Map)
                  .values
                  .map((e) => e.toString())
                  .toList()
              : List<String>.from(map['specifications']))
          : [],
      reviews: map['reviews'] != null && map['reviews'] is List
          ? (map['reviews'] as List)
              .where((e) => e is Map)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : null,
      featured: map['featured'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
      currency: map['currency'] ?? '',
      location: map['location'] ?? '',
      stock: map['stock'] ?? map['stockQuantity'], // Support both field names
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
              ? map['createdAt']
              : DateTime.tryParse(map['createdAt'].toString()))
          : null,
    );
  }

  // تحويل Product إلى Map
  Map<String, dynamic> toMap() {
    final imagesList = images ?? [];
    return {
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'image': image ?? (imagesList.isNotEmpty ? imagesList.first : null),
      'imageUrl': image ?? (imagesList.isNotEmpty ? imagesList.first : null),
      'images': imagesList,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'category': category,
      'brand': brand,
      'discount': discount,
      'specifications': specifications,
      'reviews': reviews,
      'featured': featured,
      'isAvailable': isAvailable,
      'currency': currency,
      'location': location,
      'stock': stock,
      'createdAt': createdAt,
    };
  }
}
