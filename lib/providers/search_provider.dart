// lib/providers/search_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class SearchProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Product> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  String _currentQuery = '';
  
  // فلاتر البحث
  double _minPrice = 0;
  double _maxPrice = 10000000;
  double _minRating = 0;
  String _selectedCategory = 'الكل';
  String _sortBy = 'الأحدث';
  
  // Getters
  List<Product> get searchResults => [..._searchResults];
  List<String> get searchHistory => [..._searchHistory];
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get minRating => _minRating;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  // البحث الأساسي
  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      _currentQuery = '';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _currentQuery = query;
    notifyListeners();

    try {
      // إضافة إلى تاريخ البحث
      _addToSearchHistory(query);

      // البحث في Firebase
      Query searchQuery = _firestore.collection('products');
      
      // تطبيق الفلاتر
      if (_selectedCategory != 'الكل') {
        searchQuery = searchQuery.where('category', isEqualTo: _selectedCategory);
      }
      
      searchQuery = searchQuery.where('price', isGreaterThanOrEqualTo: _minPrice);
      searchQuery = searchQuery.where('price', isLessThanOrEqualTo: _maxPrice);
      
      if (_minRating > 0) {
        searchQuery = searchQuery.where('rating', isGreaterThanOrEqualTo: _minRating);
      }

      // تطبيق الترتيب
      switch (_sortBy) {
        case 'السعر: من الأقل للأعلى':
          searchQuery = searchQuery.orderBy('price', descending: false);
          break;
        case 'السعر: من الأعلى للأقل':
          searchQuery = searchQuery.orderBy('price', descending: true);
          break;
        case 'التقييم':
          searchQuery = searchQuery.orderBy('rating', descending: true);
          break;
        case 'الأحدث':
        default:
          searchQuery = searchQuery.orderBy('name');
          break;
      }

      final snapshot = await searchQuery.limit(50).get();
      
      _searchResults = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((product) => 
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('فشل في البحث: $e');
    }
  }

  // البحث المتقدم مع الفلاتر
  Future<void> searchWithFilters({
    required String query,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? category,
    String? sortBy,
  }) async {
    if (minPrice != null) _minPrice = minPrice;
    if (maxPrice != null) _maxPrice = maxPrice;
    if (minRating != null) _minRating = minRating;
    if (category != null) _selectedCategory = category;
    if (sortBy != null) _sortBy = sortBy;
    
    await searchProducts(query);
  }

  // إعادة تعيين الفلاتر
  void resetFilters() {
    _minPrice = 0;
    _maxPrice = 10000000;
    _minRating = 0;
    _selectedCategory = 'الكل';
    _sortBy = 'الأحدث';
    notifyListeners();
  }

  // إضافة إلى تاريخ البحث
  void _addToSearchHistory(String query) {
    if (_searchHistory.contains(query)) {
      _searchHistory.remove(query);
    }
    _searchHistory.insert(0, query);
    
    // الاحتفاظ بآخر 10 عمليات بحث فقط
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.take(10).toList();
    }
  }

  // حذف من تاريخ البحث
  void removeFromSearchHistory(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  // مسح تاريخ البحث
  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  // مسح نتائج البحث
  void clearSearchResults() {
    _searchResults.clear();
    _currentQuery = '';
    notifyListeners();
  }

  // البحث بالفئة
  Future<void> searchByCategory(String category) async {
    _selectedCategory = category;
    await searchProducts(_currentQuery.isEmpty ? '' : _currentQuery);
  }

  // اقتراحات البحث
  List<String> getSearchSuggestions(String query) {
    if (query.isEmpty) return _searchHistory;
    
    return _searchHistory
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // البحث الصوتي (placeholder للمستقبل)
  Future<void> startVoiceSearch() async {
    // يمكن تنفيذ البحث الصوتي هنا باستخدام speech_to_text package
    // للآن سنتركه كـ placeholder
  }
}
