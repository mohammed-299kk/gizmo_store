import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _languageKey = 'selected_language';
  static const String _themeKey = 'dark_mode';
  static const String _defaultLanguage = 'ar'; // Arabic as default
  static const bool _defaultDarkMode = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's preferences from Firestore
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('user_preferences')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          return doc.data() ?? _getDefaultPreferences();
        }
      }
      
      // Fallback to local preferences if user not logged in or no Firestore data
      return await _getLocalPreferences();
    } catch (e) {
      debugPrint('Error getting user preferences: $e');
      return await _getLocalPreferences();
    }
  }

  // Save user preferences to both Firestore and local storage
  Future<void> saveUserPreferences({
    String? language,
    bool? isDarkMode,
  }) async {
    try {
      final user = _auth.currentUser;
      final preferences = await getUserPreferences();
      
      // Update only provided values
      if (language != null) {
        preferences['language'] = language;
      }
      if (isDarkMode != null) {
        preferences['isDarkMode'] = isDarkMode;
      }
      
      // Save to local storage first (for offline access)
      await _saveLocalPreferences(preferences);
      
      // Save to Firestore if user is logged in
      if (user != null) {
        await _firestore
            .collection('user_preferences')
            .doc(user.uid)
            .set(preferences, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
      // Even if Firestore fails, local preferences are saved
    }
  }

  // Save language preference
  Future<void> saveLanguagePreference(String languageCode) async {
    await saveUserPreferences(language: languageCode);
  }

  // Save theme preference
  Future<void> saveThemePreference(bool isDarkMode) async {
    await saveUserPreferences(isDarkMode: isDarkMode);
  }

  // Get language preference
  Future<String> getLanguagePreference() async {
    final preferences = await getUserPreferences();
    return preferences['language'] ?? _defaultLanguage;
  }

  // Get theme preference
  Future<bool> getThemePreference() async {
    final preferences = await getUserPreferences();
    return preferences['isDarkMode'] ?? _defaultDarkMode;
  }

  // Sync preferences when user logs in
  Future<void> syncPreferencesOnLogin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Get local preferences
      final localPrefs = await _getLocalPreferences();
      
      // Get Firestore preferences
      final firestoreDoc = await _firestore
          .collection('user_preferences')
          .doc(user.uid)
          .get();
      
      if (firestoreDoc.exists) {
        // Firestore data exists, use it and update local
        final firestorePrefs = firestoreDoc.data() ?? _getDefaultPreferences();
        await _saveLocalPreferences(firestorePrefs);
      } else {
        // No Firestore data, save local preferences to Firestore
        await _firestore
            .collection('user_preferences')
            .doc(user.uid)
            .set(localPrefs);
      }
    } catch (e) {
      debugPrint('Error syncing preferences on login: $e');
    }
  }

  // Clear preferences on logout (keep local defaults)
  Future<void> clearPreferencesOnLogout() async {
    try {
      // Reset to default preferences locally
      await _saveLocalPreferences(_getDefaultPreferences());
    } catch (e) {
      debugPrint('Error clearing preferences on logout: $e');
    }
  }

  // Private helper methods
  Map<String, dynamic> _getDefaultPreferences() {
    return {
      'language': _defaultLanguage,
      'isDarkMode': _defaultDarkMode,
    };
  }

  Future<Map<String, dynamic>> _getLocalPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'language': prefs.getString(_languageKey) ?? _defaultLanguage,
        'isDarkMode': prefs.getBool(_themeKey) ?? _defaultDarkMode,
      };
    } catch (e) {
      debugPrint('Error getting local preferences: $e');
      return _getDefaultPreferences();
    }
  }

  Future<void> _saveLocalPreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, preferences['language'] ?? _defaultLanguage);
      await prefs.setBool(_themeKey, preferences['isDarkMode'] ?? _defaultDarkMode);
    } catch (e) {
      debugPrint('Error saving local preferences: $e');
    }
  }

  // Migration method to update existing users
  Future<void> migrateExistingPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if migration is needed
      final migrationDone = prefs.getBool('preferences_migrated') ?? false;
      if (migrationDone) return;
      
      // Get existing preferences
      final existingLanguage = prefs.getString('selected_language');
      final existingTheme = prefs.getBool('isDarkMode');
      
      // Save using new service
      await saveUserPreferences(
        language: existingLanguage ?? _defaultLanguage,
        isDarkMode: existingTheme ?? _defaultDarkMode,
      );
      
      // Mark migration as done
      await prefs.setBool('preferences_migrated', true);
    } catch (e) {
      debugPrint('Error migrating preferences: $e');
    }
  }
}
