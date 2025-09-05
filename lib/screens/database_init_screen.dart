import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/database_setup_service.dart';
import '../services/extended_products_service.dart';

class DatabaseInitScreen extends StatefulWidget {
  const DatabaseInitScreen({super.key});

  @override
  State<DatabaseInitScreen> createState() => _DatabaseInitScreenState();
}

class _DatabaseInitScreenState extends State<DatabaseInitScreen> {
  bool _isInitializing = false;
  bool _isAddingExtendedProducts = false;
  String _status = 'جاهز لتهيئة قاعدة البيانات';
  final List<String> _logs = [];

  Future<void> _initializeDatabase() async {
    setState(() {
      _isInitializing = true;
      _status = 'جاري تهيئة قاعدة البيانات...';
      _logs.clear();
    });

    try {
      _addLog('بدء تهيئة قاعدة البيانات...');
      
      _addLog('إنشاء الفئات...');
      await DatabaseSetupService.setupCategories(context);
      _addLog('✅ تم إنشاء الفئات بنجاح');
      
      _addLog('إنشاء المنتجات التجريبية...');
      await DatabaseSetupService.setupSampleProducts(context);
      _addLog('✅ تم إنشاء المنتجات بنجاح');
      
      setState(() {
        _status = '✅ تم تهيئة قاعدة البيانات بنجاح!';
        _isInitializing = false;
      });
      
      _addLog('🎉 تمت تهيئة قاعدة البيانات بنجاح!');
      
      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'نجح التهيئة',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'تم تهيئة قاعدة البيانات بنجاح!\nيمكنك الآن استخدام التطبيق.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to main app
                },
                child: const Text(
                  'موافق',
                  style: TextStyle(color: Color(0xFFB71C1C)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = '❌ فشل في تهيئة قاعدة البيانات';
        _isInitializing = false;
      });
      _addLog('❌ خطأ: $e');
    }
  }

  Future<void> _addExtendedProducts() async {
    setState(() {
      _isAddingExtendedProducts = true;
      _status = 'جاري إضافة المنتجات الموسعة...';
      _logs.clear();
    });

    try {
      _addLog('بدء إضافة المنتجات الموسعة...');
      
      await ExtendedProductsService.addExtendedProducts(context);
      _addLog('✅ تم إضافة 400 منتج جديد بنجاح!');
      
      setState(() {
        _status = '✅ تم إضافة المنتجات الموسعة بنجاح!';
        _isAddingExtendedProducts = false;
      });
      
      _addLog('🎉 تمت إضافة جميع المنتجات الموسعة بنجاح!');
      
      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'نجحت الإضافة',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'تم إضافة 400 منتج جديد بنجاح!\nيمكنك الآن تصفح المزيد من المنتجات.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'موافق',
                  style: TextStyle(color: Color(0xFFB71C1C)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = '❌ فشل في إضافة المنتجات الموسعة';
        _isAddingExtendedProducts = false;
      });
      _addLog('❌ خطأ: $e');
    }
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'تهيئة قاعدة البيانات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB71C1C), Color(0xFFB71C1C).withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.storage,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_isInitializing || _isAddingExtendedProducts) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Initialize Button
            if (!_isInitializing && !_isAddingExtendedProducts)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _initializeDatabase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تهيئة قاعدة البيانات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Extended Products Button
            if (!_isInitializing && !_isAddingExtendedProducts)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addExtendedProducts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إضافة 400 منتج موسع (50 لكل فئة)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Logs Section
            if (_logs.isNotEmpty) ...[
              const Text(
                'سجل العمليات:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          log,
                          style: TextStyle(
                            color: log.contains('✅') 
                                ? Colors.green 
                                : log.contains('❌') 
                                    ? Colors.red 
                                    : Colors.white70,
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            
            // Info Section
            if (_logs.isEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Color(0xFFB71C1C),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'تهيئة قاعدة البيانات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.databaseInitDescription,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
