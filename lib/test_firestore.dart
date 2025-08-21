import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirestoreScreen extends StatelessWidget {
  const TestFirestoreScreen({super.key});

  Future<void> _addTestData() async {
    try {
      await FirebaseFirestore.instance.collection("products").add({
        "name": "Test Product",
        "price": 99.99,
        "created_at": DateTime.now(),
      });
      debugPrint("✅ Data added successfully!");
    } catch (e) {
      debugPrint("❌ Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: _addTestData,
          child: const Text("Add Test Data"),
        ),
      ),
    );
  }
}
