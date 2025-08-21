import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  int _currentBottomNavIndex = 0;
  String _currentCategory = 'الكل';
  String _searchQuery = '';
  bool _isDarkMode = false;

  int get currentBottomNavIndex => _currentBottomNavIndex;
  String get currentCategory => _currentCategory;
  String get searchQuery => _searchQuery;
  bool get isDarkMode => _isDarkMode;

  // تحديث مؤشر التنقل السفلي
  void updateBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }

  // تحديث التصنيف الحالي
  void updateCurrentCategory(String category) {
    _currentCategory = category;
    notifyListeners();
  }

  // تحديث استعلام البحث
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // تبديل وضع الظلام
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // إعادة تعيين حالة التطبيق
  void reset() {
    _currentBottomNavIndex = 0;
    _currentCategory = 'الكل';
    _searchQuery = '';
    notifyListeners();
  }
}
