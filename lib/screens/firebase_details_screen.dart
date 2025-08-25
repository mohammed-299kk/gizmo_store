import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/firebase_options.dart'; // Import generated Firebase options

class FirebaseDetailsScreen extends StatelessWidget {
  const FirebaseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseApp app = Firebase.app();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('تفاصيل Firebase', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('معلومات التطبيق'),
            _buildDetailCard([
              _buildDetailRow('اسم التطبيق:', app.name),
              _buildDetailRow('معرف المشروع:', DefaultFirebaseOptions.currentPlatform.projectId),
              _buildDetailRow('مفتاح API:', DefaultFirebaseOptions.currentPlatform.apiKey),
              _buildDetailRow('معرف التطبيق:', DefaultFirebaseOptions.currentPlatform.appId),
              _buildDetailRow('معرف حزمة Android:', DefaultFirebaseOptions.currentPlatform.androidClientId ?? 'غير متوفر'),
              _buildDetailRow('معرف عميل iOS:', DefaultFirebaseOptions.currentPlatform.iosClientId ?? 'غير متوفر'),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('حالة المصادقة'),
            _buildDetailCard([
              _buildDetailRow('حالة تسجيل الدخول:', currentUser != null ? 'مسجل الدخول' : 'غير مسجل الدخول'),
              if (currentUser != null) ...[
                _buildDetailRow('معرف المستخدم (UID):', currentUser.uid),
                _buildDetailRow('البريد الإلكتروني:', currentUser.email ?? 'غير متوفر'),
                _buildDetailRow('اسم العرض:', currentUser.displayName ?? 'غير متوفر'),
                _buildDetailRow('مجهول:', currentUser.isAnonymous ? 'نعم' : 'لا'),
              ],
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('حالة الخدمات (تقديري)'),
            _buildDetailCard([
              _buildDetailRow('Firestore:', 'متصل (إذا كان التطبيق يعمل)'),
              _buildDetailRow('Messaging:', 'متصل (إذا تم تهيئته)'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}