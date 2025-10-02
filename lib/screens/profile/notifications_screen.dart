import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // إعدادات الإشعارات الافتراضية
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newProducts = false;
  bool _priceDrops = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  
  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('أنواع الإشعارات'),
          _buildNotificationCard(
            icon: Icons.shopping_bag_outlined,
            title: 'تحديثات الطلبات',
            subtitle: 'إشعارات حول حالة طلباتك',
            value: _orderUpdates,
            onChanged: (value) {
              setState(() {
                _orderUpdates = value;
              });
              _saveNotificationSettings();
            },
          ),
          _buildNotificationCard(
            icon: Icons.local_offer_outlined,
            title: 'العروض والخصومات',
            subtitle: 'إشعارات حول العروض الخاصة والخصومات',
            value: _promotions,
            onChanged: (value) {
              setState(() {
                _promotions = value;
              });
              _saveNotificationSettings();
            },
          ),
          _buildNotificationCard(
            icon: Icons.new_releases_outlined,
            title: 'المنتجات الجديدة',
            subtitle: 'إشعارات حول المنتجات الجديدة',
            value: _newProducts,
            onChanged: (value) {
              setState(() {
                _newProducts = value;
              });
              _saveNotificationSettings();
            },
          ),
          _buildNotificationCard(
            icon: Icons.trending_down_outlined,
            title: 'انخفاض الأسعار',
            subtitle: 'إشعارات عند انخفاض أسعار المنتجات المفضلة',
            value: _priceDrops,
            onChanged: (value) {
              setState(() {
                _priceDrops = value;
              });
              _saveNotificationSettings();
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('طرق التوصيل'),
          _buildNotificationCard(
            icon: Icons.email_outlined,
            title: 'البريد الإلكتروني',
            subtitle: 'استقبال الإشعارات عبر البريد الإلكتروني',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          _buildNotificationCard(
            icon: Icons.notifications_outlined,
            title: 'الإشعارات المباشرة',
            subtitle: 'استقبال الإشعارات المباشرة على الجهاز',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          _buildNotificationCard(
            icon: Icons.sms_outlined,
            title: 'الرسائل النصية',
            subtitle: 'استقبال الإشعارات عبر الرسائل النصية',
            value: _smsNotifications,
            onChanged: (value) {
              setState(() {
                _smsNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: Color(0xFFB71C1C),
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFFB71C1C),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _testNotification,
            icon: const Icon(Icons.notifications_active),
            label: const Text('اختبار الإشعارات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            label: const Text('استعادة الإعدادات الافتراضية'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('notifications')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _orderUpdates = data['orderUpdates'] ?? true;
          _promotions = data['promotions'] ?? true;
          _newProducts = data['newProducts'] ?? false;
          _priceDrops = data['priceDrops'] ?? true;
          _emailNotifications = data['emailNotifications'] ?? true;
          _pushNotifications = data['pushNotifications'] ?? true;
          _smsNotifications = data['smsNotifications'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في تحميل إعدادات الإشعارات: $e');
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('notifications')
          .set({
        'orderUpdates': _orderUpdates,
        'promotions': _promotions,
        'newProducts': _newProducts,
        'priceDrops': _priceDrops,
        'emailNotifications': _emailNotifications,
        'pushNotifications': _pushNotifications,
        'smsNotifications': _smsNotifications,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في حفظ الإعدادات: $e')),
        );
      }
    }
  }

  void _testNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.white),
            SizedBox(width: 8),
            Text('تم إرسال إشعار تجريبي بنجاح!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استعادة الإعدادات الافتراضية'),
        content: const Text('هل أنت متأكد من استعادة جميع إعدادات الإشعارات إلى القيم الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _orderUpdates = true;
                _promotions = true;
                _newProducts = false;
                _priceDrops = true;
                _emailNotifications = true;
                _pushNotifications = true;
                _smsNotifications = false;
              });
              _saveNotificationSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم استعادة الإعدادات الافتراضية')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB71C1C)),
            child: const Text('استعادة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}