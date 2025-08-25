import 'package:flutter/material.dart';
import 'package:gizmo_store/services/enhanced_sample_data_service.dart';

class TestFirestoreScreen extends StatelessWidget {
  const TestFirestoreScreen({super.key});

  Future<void> _addEnhancedData(BuildContext context) async {
    try {
      await EnhancedSampleDataService().addAllEnhancedData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Enhanced data added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _addEnhancedData(context),
          child: const Text("Add Enhanced Sample Data"),
        ),
      ),
    );
  }
}
