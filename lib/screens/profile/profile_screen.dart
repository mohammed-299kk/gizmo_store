import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/providers/app_state.dart';
import 'package:gizmo_store/screens/auth/auth_screen.dart';
import 'package:gizmo_store/screens/order/orders_screen.dart';
import 'package:gizmo_store/screens/cart/cart_screen.dart';
import 'package:gizmo_store/test_firebase_connection.dart';
import 'package:gizmo_store/screens/admin/firebase_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // دالة لبناء بطاقة الإحصائيات
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB71C1C), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // دالة لعرض حوار العناوين
  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'العناوين المحفوظة',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.home, color: Color(0xFFB71C1C)),
              title:
                  Text('المنزل', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'الخرطوم، شارع النيل، المنطقة الأولى',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ListTile(
              leading: Icon(Icons.work, color: Color(0xFFB71C1C)),
              title: Text('العمل', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'الخرطوم، وسط البلد، مجمع الأعمال',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('إغلاق', style: TextStyle(color: Color(0xFFB71C1C))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: إضافة عنوان جديد')),
              );
            },
            child: const Text('إضافة عنوان',
                style: TextStyle(color: Color(0xFFB71C1C))),
          ),
        ],
      ),
    );
  }

  // دالة لعرض إعدادات الإشعارات
  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'إعدادات الإشعارات',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('إشعارات الطلبات',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('تلقي إشعارات حول حالة الطلبات',
                  style: TextStyle(color: Colors.white70)),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFFB71C1C),
            ),
            SwitchListTile(
              title: const Text('إشعارات العروض',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('تلقي إشعارات حول العروض والخصومات',
                  style: TextStyle(color: Colors.white70)),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFFB71C1C),
            ),
            SwitchListTile(
              title: const Text('إشعارات المنتجات الجديدة',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('تلقي إشعارات حول المنتجات الجديدة',
                  style: TextStyle(color: Colors.white70)),
              value: false,
              onChanged: (value) {},
              activeColor: const Color(0xFFB71C1C),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('إغلاق', style: TextStyle(color: Color(0xFFB71C1C))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ الإعدادات')),
              );
            },
            child:
                const Text('حفظ', style: TextStyle(color: Color(0xFFB71C1C))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final appState = Provider.of<AppState>(context);
    final User? user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _isLoading ? null : () => _showLogoutDialog(context),
            ),
        ],
      ),
      body: user == null
          ? _buildGuestView(context)
          : _buildUserProfile(user, context),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'لم تقم بتسجيل الدخول بعد',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'سجل الدخول للوصول إلى جميع الميزات',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(User user, BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة معلومات المستخدم
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB71C1C), Color(0xFF8E0000)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'مستخدم',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email ?? 'لا يوجد بريد إلكتروني',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'الخرطوم، السودان',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // إحصائيات سريعة
          Row(
            children: [
              Expanded(
                child: _buildStatCard('الطلبات', '12', Icons.shopping_bag),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('المفضلة', '8', Icons.favorite),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('النقاط', '250', Icons.star),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // الإعدادات
          const Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsOption(
            context,
            icon: Icons.shopping_bag,
            title: 'طلباتي',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersScreen()),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.favorite_border,
            title: 'المفضلة',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: شاشة المفضلة')),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.shopping_cart,
            title: 'السلة',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.location_on_outlined,
            title: 'العناوين',
            onTap: () {
              _showAddressDialog(context);
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.notifications_none,
            title: 'الإشعارات',
            onTap: () {
              _showNotificationSettings(context);
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.bug_report,
            title: 'اختبار Firebase',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FirebaseConnectionTest()),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.dashboard,
            title: 'لوحة تحكم Firebase',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FirebaseDashboard()),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.color_lens_outlined,
            title: 'المظهر',
            trailing: Switch(
              value: appState.isDarkMode,
              onChanged: (value) {
                appState.toggleDarkMode();
              },
              activeColor: const Color(0xFFB71C1C),
            ),
            onTap: null,
          ),
          const SizedBox(height: 32),

          // معلومات التطبيق
          const Text(
            'معلومات التطبيق',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsOption(
            context,
            icon: Icons.help_outline,
            title: 'المساعدة والدعم',
            onTap: () {
              // TODO: الانتقال إلى شاشة المساعدة
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.security_outlined,
            title: 'الخصوصية',
            onTap: () {
              // TODO: الانتقال إلى شاشة الخصوصية
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.info_outline,
            title: 'عن التطبيق',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          const SizedBox(height: 32),

          // زر تسجيل الخروج
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('تسجيل الخروج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: _isLoading ? null : () => _showLogoutDialog(context),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB71C1C)),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() => _isLoading = true);

                try {
                  final authProvider =
                      Provider.of<auth.AuthProvider>(context, listen: false);
                  await authProvider.signOut();
                  // سيتم توجيه المستخدم تلقائيًا عبر AuthGate
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('حدث خطأ أثناء تسجيل الخروج: $e')),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('عن التطبيق'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gizmo Store',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('تطبيق متجر إلكتروني متخصص في الأجهزة الذكية والإلكترونيات'),
              SizedBox(height: 16),
              Text('الإصدار: 1.0.0'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}
