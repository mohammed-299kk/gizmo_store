import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_preferences_service.dart';

class LanguageProvider extends ChangeNotifier {
  final UserPreferencesService _preferencesService = UserPreferencesService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Locale _currentLocale = const Locale('ar'); // Arabic as default
  
  Locale get currentLocale => _currentLocale;
  
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';
  
  LanguageProvider() {
    _loadSavedLanguage();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User logged in - sync preferences from cloud
        await syncPreferences();
      } else {
        // User logged out - reset to defaults
        await resetPreferences();
      }
    });
  }
  
  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguage = await _preferencesService.getLanguagePreference();
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    } catch (e) {
      // If there's an error loading the saved language, use default (Arabic)
      _currentLocale = const Locale('ar');
      debugPrint('Error loading language preference: $e');
    }
  }
  
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) {
      return; // No change needed
    }
    
    try {
      await _preferencesService.saveLanguagePreference(languageCode);
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      // Handle error - could show a snackbar or log the error
      debugPrint('Error saving language preference: $e');
    }
  }
  
  // Method to sync preferences when user logs in
  Future<void> syncPreferences() async {
    try {
      await _preferencesService.syncPreferencesOnLogin();
      final savedLanguage = await _preferencesService.getLanguagePreference();
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing language preferences: $e');
    }
  }
  
  // Method to reset preferences on logout
  Future<void> resetPreferences() async {
    try {
      await _preferencesService.clearPreferencesOnLogout();
      _currentLocale = const Locale('ar'); // Reset to Arabic default
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting language preferences: $e');
    }
  }
  
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLocale.languageCode == 'en' ? 'ar' : 'en';
    await changeLanguage(newLanguage);
  }
  
  TextDirection get textDirection {
    return _currentLocale.languageCode == 'ar' 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }
  
  String get languageDisplayName {
    switch (_currentLocale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }
}
