import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminCreator {
  static Future<void> createAdminUser() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Admin user data
      final adminUserData = {
        'uid': 'Hj11wZ1FlANccDf5xoi9ujdZiFM2',
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

      // Create the admin user document
      await firestore
          .collection('users')
          .doc('Hj11wZ1FlANccDf5xoi9ujdZiFM2')
          .set(adminUserData);

      print('Admin user created successfully!');
    } catch (e) {
      print('Error creating admin user: $e');
    }
  }
}