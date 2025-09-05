import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TempAdminCreator extends StatefulWidget {
  const TempAdminCreator({super.key});

  @override
  State<TempAdminCreator> createState() => _TempAdminCreatorState();
}

class _TempAdminCreatorState extends State<TempAdminCreator> {
  bool _isCreating = false;
  String _message = '';

  Future<void> _createAdminUser() async {
    setState(() {
      _isCreating = true;
      _message = 'Creating admin user...';
    });

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      String uid;
      
      // Try to sign in first to check if user exists
      setState(() {
        _message = 'Checking existing user...';
      });
      
      try {
        // Try to create user first
        setState(() {
          _message = 'Creating Firebase Auth user...';
        });
        
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: 'admin@gmail.com',
          password: 'mohammed123#',
        );
        uid = userCredential.user!.uid;
      } catch (createError) {
        // If user already exists, try to sign in
        if (createError.toString().contains('email-already-in-use')) {
          setState(() {
            _message = 'User exists, attempting sign in...';
          });
          
          try {
            UserCredential signInResult = await auth.signInWithEmailAndPassword(
              email: 'admin@gmail.com',
              password: 'mohammed123#',
            );
            uid = signInResult.user!.uid;
            setState(() {
              _message = 'Successfully signed in existing user...';
            });
          } catch (signInError) {
            // User exists but can't sign in - show detailed error
            setState(() {
              _message = 'Sign-in failed: ${signInError.toString()}';
              _isCreating = false;
            });
            return;
          }
        } else {
          throw createError;
        }
      }
      
      // Then create Firestore document with the actual UID
      setState(() {
        _message = 'Creating user profile...';
      });
      
      final adminUserData = {
        'uid': uid,
        'email': 'admin@gmail.com',
        'name': 'Admin User',
        'userType': 'admin',
        'isAdmin': true,
        'isActive': true,
        'preferences': {
          'language': 'en',
          'notifications': true,
          'theme': 'light'
        },
        'profile': {
          'firstName': 'Admin',
          'lastName': 'User',
          'avatar': null,
          'phone': null,
          'address': null,
          'dateOfBirth': null
        },
        'stats': {
          'totalOrders': 0,
          'totalSpent': 0,
          'favoriteProducts': [],
          'cartItems': []
        },
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('users')
          .doc(uid)
          .set(adminUserData);

      // Sign out the user after creation
      await auth.signOut();

      setState(() {
        _message = 'Admin user created successfully! You can now login with admin@gmail.com and password mohammed123#';
        _isCreating = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Error creating admin user: $e';
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Creator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isCreating ? null : _createAdminUser,
              child: _isCreating
                  ? const CircularProgressIndicator()
                  : const Text('Create Admin User'),
            ),
            const SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}