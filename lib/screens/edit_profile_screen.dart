import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'شاشة تعديل الملف الشخصي قيد التطوير',
          style: TextStyle(fontSize: 20, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}