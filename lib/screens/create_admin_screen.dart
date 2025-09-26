import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAdminScreen extends StatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  State<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  bool _isLoading = false;
  String _message = '';

  Future<void> _createAdminUser() async {
    setState(() {
      _isLoading = true;
      _message = 'جاري إنشاء المستخدم الأدمن...';
    });

    try {
      // First, try to create the user in Firebase Auth
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: 'admin@gizmo.com',
          password: 'gizmo1234',
        );
        setState(() {
          _message = 'تم إنشاء المستخدم في Firebase Auth بنجاح';
        });
      } catch (e) {
        if (e.toString().contains('email-already-in-use')) {
          // User already exists, try to sign in
          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: 'admin@gizmo.com',
            password: 'gizmo1234',
          );
          setState(() {
            _message = 'المستخدم موجود بالفعل في Firebase Auth';
          });
        } else {
          throw e;
        }
      }

      if (userCredential?.user != null) {
        final user = userCredential!.user!;
        
        // Update display name
        await user.updateDisplayName('Admin User');
        
        setState(() {
          _message = 'جاري إنشاء مستند المستخدم في Firestore...';
        });
        
        // Create user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': 'Admin User',
          'isAdmin': true,
          'role': 'admin',
          'userType': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        setState(() {
          _message = 'تم إنشاء المستخدم الأدمن بنجاح!\n'
                    'البريد الإلكتروني: admin@gizmo.com\n'
                    'كلمة المرور: gizmo1234\n'
                    'UID: ${user.uid}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'خطأ في إنشاء المستخدم الأدمن: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء المستخدم الأدمن'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'إنشاء المستخدم الأدمن',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'سيتم إنشاء مستخدم أدمن بالبيانات التالية:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'البريد الإلكتروني: admin@gizmo.com',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Text(
              'كلمة المرور: gizmo1234',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _createAdminUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'إنشاء المستخدم الأدمن',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _message.isEmpty ? 'لم يتم تنفيذ أي عملية بعد' : _message,
                style: TextStyle(
                  fontSize: 14,
                  color: _message.contains('خطأ') ? Colors.red : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}