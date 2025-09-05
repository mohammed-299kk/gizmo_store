import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_preferences_service.dart';

class ThemeProvider extends ChangeNotifier {
  final UserPreferencesService _preferencesService = UserPreferencesService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isDarkMode = false; // Light mode as default
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }
  
  ThemeProvider() {
    _loadSavedTheme();
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
  
  Future<void> _loadSavedTheme() async {
    try {
      final savedTheme = await _preferencesService.getThemePreference();
      _isDarkMode = savedTheme;
      notifyListeners();
    } catch (e) {
      // If there's an error loading the saved theme, use default (light mode)
      _isDarkMode = false;
      debugPrint('Error loading theme preference: $e');
    }
  }
  
  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      await _preferencesService.saveThemePreference(_isDarkMode);
      notifyListeners();
    } catch (e) {
      // Revert the change if saving fails
      _isDarkMode = !_isDarkMode;
      debugPrint('Error saving theme preference: $e');
    }
  }
  
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) {
      return; // No change needed
    }
    
    try {
      _isDarkMode = isDark;
      await _preferencesService.saveThemePreference(_isDarkMode);
      notifyListeners();
    } catch (e) {
      // Revert the change if saving fails
      _isDarkMode = !_isDarkMode;
      debugPrint('Error saving theme preference: $e');
    }
  }
  
  // Method to sync preferences when user logs in
  Future<void> syncPreferences() async {
    try {
      await _preferencesService.syncPreferencesOnLogin();
      final savedTheme = await _preferencesService.getThemePreference();
      _isDarkMode = savedTheme;
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing theme preferences: $e');
    }
  }
  
  // Method to reset preferences on logout
  Future<void> resetPreferences() async {
    try {
      await _preferencesService.clearPreferencesOnLogout();
      _isDarkMode = false; // Reset to light mode default
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting theme preferences: $e');
    }
  }
  
  // Light theme configuration
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD32F2F), // Red 600 - أحمر حيوي
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
  
  // Dark theme configuration
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD32F2F), // Red 600 - أحمر حيوي
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1B1F),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: const Color(0xFF1C1B1F),
    cardTheme: CardThemeData(
      color: const Color(0xFF2B2930),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
