// lib/providers/review_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = false;
  String _sortBy = 'الأحدث';
  double _filterRating = 0;

  // Getters
  List<Map<String, dynamic>> get reviews => [..._reviews];
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;
  double get filterRating => _filterRating;

  // تحميل تقييمات منتج
  Future<void> loadProductReviews(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      Query query = _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId);

      // تطبيق فلتر التقييم
      if (_filterRating > 0) {
        query = query.where('rating', isEqualTo: _filterRating);
      }

      // تطبيق الترتيب
      switch (_sortBy) {
        case 'الأحدث':
          query = query.orderBy('date', descending: true);
          break;
        case 'الأقدم':
          query = query.orderBy('date', descending: false);
          break;
        case 'الأعلى تقييماً':
          query = query.orderBy('rating', descending: true);
          break;
        case 'الأقل تقييماً':
          query = query.orderBy('rating', descending: false);
          break;
        case 'الأكثر فائدة':
          query = query.orderBy('helpfulCount', descending: true);
          break;
      }

      final snapshot = await query.get();

      _reviews = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('فشل في تحميل التقييمات: $e');
    }
  }

  // إضافة تقييم جديد
  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
    List<String> images = const [],
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول أولاً');

    _isLoading = true;
    notifyListeners();

    try {
      // التحقق من وجود تقييم سابق
      final existingReview = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: user.uid)
          .get();

      if (existingReview.docs.isNotEmpty) {
        throw Exception('لقد قمت بتقييم هذا المنتج من قبل');
      }

      final reviewData = {
        'productId': productId,
        'userId': user.uid,
        'userName': user.displayName ?? 'مستخدم',
        'userLocation': 'الخرطوم',
        'rating': rating,
        'comment': comment,
        'date': DateTime.now().toIso8601String(),
        'images': images,
        'isVerifiedPurchase': false,
        'helpfulCount': 0,
        'helpfulUsers': [],
      };

      await _firestore.collection('reviews').add(reviewData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // تغيير ترتيب التقييمات
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  // تغيير فلتر التقييم
  void setFilterRating(double rating) {
    _filterRating = rating;
    notifyListeners();
  }

  // الحصول على إحصائيات التقييمات
  Map<int, int> getReviewStats() {
    Map<int, int> stats = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in _reviews) {
      int rating = (review['rating'] as double).round();
      stats[rating] = (stats[rating] ?? 0) + 1;
    }

    return stats;
  }

  // التحقق من إمكانية التقييم
  Future<bool> canUserReview(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final existingReview = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: user.uid)
          .get();

      return existingReview.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  // مسح التقييمات
  void clearReviews() {
    _reviews.clear();
    notifyListeners();
  }
}
