import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;

class FirebaseOptionsScreen extends StatefulWidget {
  const FirebaseOptionsScreen({super.key});

  @override
  State<FirebaseOptionsScreen> createState() => _FirebaseOptionsScreenState();
}

class _FirebaseOptionsScreenState extends State<FirebaseOptionsScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _firebaseConfig = {};

  @override
  void initState() {
    super.initState();
    _loadFirebaseConfig();
  }

  Future<void> _loadFirebaseConfig() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load current Firebase configuration
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;
      final messaging = FirebaseMessaging.instance;

      _firebaseConfig = {
        'auth': {
          'currentUser': auth.currentUser?.uid ?? 'غير مسجل',
          'tenantId': auth.tenantId ?? 'غير محدد',
          'app': auth.app.name,
        },
        'firestore': {
          'app': firestore.app.name,
          'settings': 'متصل',
        },
        'storage': {
          'bucket': storage.bucket,
          'app': storage.app.name,
        },
        'messaging': {
          'token': await messaging.getToken() ?? 'غير متوفر',
          'app': messaging.app.name,
        },
      };
    } catch (e) {
      _showErrorMessage('فشل في تحميل إعدادات Firebase: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'إعدادات Firebase',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2A2A2A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFirebaseConfig,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFB71C1C),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Firebase Authentication'),
                  _buildConfigSection('auth'),
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader('Cloud Firestore'),
                  _buildConfigSection('firestore'),
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader('Firebase Storage'),
                  _buildConfigSection('storage'),
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader('Firebase Messaging'),
                  _buildConfigSection('messaging'),
                  const SizedBox(height: 24),
                  
                  _buildActionsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB71C1C), Color(0xFF8E0000)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConfigSection(String section) {
    final config = _firebaseConfig[section] as Map<String, dynamic>? ?? {};
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: config.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${entry.key}:',
                    style: const TextStyle(
                      color: Color(0xFFB71C1C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إجراءات Firebase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActionButton(
            'تحديث رمز FCM',
            Icons.notifications,
            _refreshFCMToken,
          ),
          const SizedBox(height: 8),
          
          _buildActionButton(
            'مسح ذاكرة التخزين المؤقت',
            Icons.clear_all,
            _clearCache,
          ),
          const SizedBox(height: 8),
          
          _buildActionButton(
            'اختبار الاتصال',
            Icons.network_check,
            _testConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A3A3A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshFCMToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.deleteToken();
      final newToken = await messaging.getToken();
      
      setState(() {
        _firebaseConfig['messaging']['token'] = newToken ?? 'غير متوفر';
      });
      
      _showSuccessMessage('تم تحديث رمز FCM بنجاح');
    } catch (e) {
      _showErrorMessage('فشل في تحديث رمز FCM: $e');
    }
  }

  Future<void> _clearCache() async {
    try {
      // Clear Firestore cache
      await FirebaseFirestore.instance.clearPersistence();
      _showSuccessMessage('تم مسح ذاكرة التخزين المؤقت بنجاح');
    } catch (e) {
      _showErrorMessage('فشل في مسح ذاكرة التخزين المؤقت: $e');
    }
  }

  Future<void> _testConnection() async {
    try {
      // Test Firestore connection
      await FirebaseFirestore.instance.collection('test').limit(1).get();
      _showSuccessMessage('الاتصال بـ Firebase يعمل بشكل صحيح');
    } catch (e) {
      _showErrorMessage('فشل في الاتصال بـ Firebase: $e');
    }
  }
}
