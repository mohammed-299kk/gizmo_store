import 'package:flutter/material.dart';
//import '../../services/sample_data_service.dart';

class AddSampleDataScreen extends StatefulWidget {
  const AddSampleDataScreen({super.key});

  @override
  State<AddSampleDataScreen> createState() => _AddSampleDataScreenState();
}

class _AddSampleDataScreenState extends State<AddSampleDataScreen> {
  bool _isLoading = false;
  String _message = '';

  Future<void> _addSampleData() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // final sampleDataService = SampleDataService();
      //await sampleDataService.addAllSampleData();

      setState(() {
        _message = 'تم إضافة البيانات النموذجية بنجاح!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _message = 'خطأ في إضافة البيانات: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة البيانات النموذجية'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.data_usage,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'إضافة البيانات النموذجية',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'اضغط على الزر أدناه لإضافة المنتجات والفئات النموذجية إلى قاعدة البيانات',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('جاري إضافة البيانات...'),
                ],
              )
            else
              ElevatedButton(
                onPressed: _addSampleData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'إضافة البيانات النموذجية',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 20),
            if (_message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _message.contains('خطأ')
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _message.contains('خطأ') ? Colors.red : Colors.green,
                  ),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('خطأ')
                        ? Colors.red.shade800
                        : Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
