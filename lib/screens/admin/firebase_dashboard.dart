import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseDashboard extends StatefulWidget {
  const FirebaseDashboard({super.key});

  @override
  State<FirebaseDashboard> createState() => _FirebaseDashboardState();
}

class _FirebaseDashboardState extends State<FirebaseDashboard> {
  bool _isConnected = false;
  int _totalUsers = 0;
  int _totalProducts = 0;
  int _totalOrders = 0;
  String _connectionStatus = 'جاري الفحص...';
  List<Map<String, dynamic>> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
    _loadDashboardData();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      // فحص اتصال Firebase
      await Firebase.initializeApp();
      
      // فحص Firestore
      await FirebaseFirestore.instance
          .collection('test')
          .doc('connection')
          .set({'timestamp': FieldValue.serverTimestamp()});
      
      setState(() {
        _isConnected = true;
        _connectionStatus = 'متصل بنجاح';
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _connectionStatus = 'فشل الاتصال: $e';
      });
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      // عدد المستخدمين (تقديري)
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      
      // عدد المنتجات
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();
      
      // عدد الطلبات
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .get();

      setState(() {
        _totalUsers = usersSnapshot.docs.length;
        _totalProducts = productsSnapshot.docs.length;
        _totalOrders = ordersSnapshot.docs.length;
      });

      // تحديث الأنشطة الحديثة
      _loadRecentActivities();
    } catch (e) {
      print('خطأ في تحميل بيانات لوحة التحكم: $e');
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      final activities = <Map<String, dynamic>>[];
      
      // أحدث المنتجات المضافة
      final recentProducts = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();
      
      for (var doc in recentProducts.docs) {
        activities.add({
          'type': 'منتج جديد',
          'title': doc.data()['name'] ?? 'منتج غير معروف',
          'time': 'منذ دقائق',
          'icon': Icons.shopping_bag,
          'color': Colors.green,
        });
      }

      setState(() {
        _recentActivities = activities;
      });
    } catch (e) {
      print('خطأ في تحميل الأنشطة الحديثة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('لوحة تحكم Firebase'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _checkFirebaseConnection();
              _loadDashboardData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة الاتصال
            _buildConnectionCard(),
            
            const SizedBox(height: 20),
            
            // إحصائيات سريعة
            const Text(
              'الإحصائيات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(child: _buildStatCard('المستخدمين', _totalUsers.toString(), Icons.people, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('المنتجات', _totalProducts.toString(), Icons.inventory, Colors.green)),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(child: _buildStatCard('الطلبات', _totalOrders.toString(), Icons.shopping_cart, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('المبيعات', '${(_totalOrders * 150000).toString()} جنيه', Icons.monetization_on, Colors.purple)),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // الأنشطة الحديثة
            const Text(
              'الأنشطة الحديثة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildRecentActivities(),
            
            const SizedBox(height: 24),
            
            // أدوات إدارية
            const Text(
              'أدوات الإدارة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildAdminTools(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isConnected ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isConnected ? Icons.cloud_done : Icons.cloud_off,
            color: _isConnected ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'حالة الاتصال',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _connectionStatus,
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    if (_recentActivities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'لا توجد أنشطة حديثة',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _recentActivities.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.white24),
        itemBuilder: (context, index) {
          final activity = _recentActivities[index];
          return ListTile(
            leading: Icon(
              activity['icon'],
              color: activity['color'],
            ),
            title: Text(
              activity['title'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              activity['type'],
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              activity['time'],
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminTools() {
    return Column(
      children: [
        _buildToolButton(
          'تنظيف قاعدة البيانات',
          'حذف البيانات التجريبية',
          Icons.cleaning_services,
          Colors.red,
          () => _showCleanupDialog(),
        ),
        const SizedBox(height: 12),
        _buildToolButton(
          'إضافة بيانات تجريبية',
          'إضافة منتجات وتصنيفات جديدة',
          Icons.add_box,
          Colors.green,
          () => _addSampleData(),
        ),
        const SizedBox(height: 12),
        _buildToolButton(
          'تصدير البيانات',
          'تصدير قاعدة البيانات كملف JSON',
          Icons.download,
          Colors.blue,
          () => _exportData(),
        ),
      ],
    );
  }

  Widget _buildToolButton(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  void _showCleanupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('تنظيف قاعدة البيانات', style: TextStyle(color: Colors.white)),
        content: const Text(
          'هل أنت متأكد من حذف جميع البيانات التجريبية؟ هذا الإجراء لا يمكن التراجع عنه.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cleanupDatabase();
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _cleanupDatabase() async {
    try {
      // حذف المنتجات
      final productsSnapshot = await FirebaseFirestore.instance.collection('products').get();
      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تنظيف قاعدة البيانات بنجاح')),
      );
      
      _loadDashboardData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تنظيف قاعدة البيانات: $e')),
      );
    }
  }

  Future<void> _addSampleData() async {
    // سيتم تنفيذ هذا لاحقاً
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
    );
  }

  Future<void> _exportData() async {
    // سيتم تنفيذ هذا لاحقاً
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
    );
  }
}
