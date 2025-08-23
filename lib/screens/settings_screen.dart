import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'ريال سعودي';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('الحساب'),
          _buildSettingTile(
            icon: Icons.person,
            title: 'الملف الشخصي',
            subtitle: 'تحديث معلوماتك الشخصية',
            onTap: () => _showComingSoon('الملف الشخصي'),
          ),
          _buildSettingTile(
            icon: Icons.security,
            title: 'الأمان والخصوصية',
            subtitle: 'إدارة كلمة المرور والأمان',
            onTap: () => _showComingSoon('الأمان والخصوصية'),
          ),
          
          const SizedBox(height: 20),
          _buildSectionTitle('التطبيق'),
          
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'الإشعارات',
            subtitle: 'تلقي إشعارات الطلبات والعروض',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'الوضع المظلم',
            subtitle: 'تفعيل الوضع المظلم',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
            },
          ),
          
          _buildDropdownTile(
            icon: Icons.language,
            title: 'اللغة',
            value: _selectedLanguage,
            items: ['العربية', 'English'],
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
            },
          ),
          
          _buildDropdownTile(
            icon: Icons.attach_money,
            title: 'العملة',
            value: _selectedCurrency,
            items: ['ريال سعودي', 'دولار أمريكي', 'يورو'],
            onChanged: (value) {
              setState(() => _selectedCurrency = value!);
            },
          ),
          
          const SizedBox(height: 20),
          _buildSectionTitle('المساعدة والدعم'),
          
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'مركز المساعدة',
            subtitle: 'الأسئلة الشائعة والدعم',
            onTap: () => _showComingSoon('مركز المساعدة'),
          ),
          
          _buildSettingTile(
            icon: Icons.contact_support,
            title: 'تواصل معنا',
            subtitle: 'خدمة العملاء والدعم الفني',
            onTap: () => _showComingSoon('تواصل معنا'),
          ),
          
          _buildSettingTile(
            icon: Icons.star_rate,
            title: 'قيم التطبيق',
            subtitle: 'شاركنا رأيك في التطبيق',
            onTap: () => _showComingSoon('تقييم التطبيق'),
          ),
          
          const SizedBox(height: 20),
          _buildSectionTitle('معلومات التطبيق'),
          
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'حول التطبيق',
            subtitle: 'الإصدار 1.0.0',
            onTap: () => _showAboutDialog(),
          ),
          
          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: 'سياسة الخصوصية',
            subtitle: 'اطلع على سياسة الخصوصية',
            onTap: () => _showComingSoon('سياسة الخصوصية'),
          ),
          
          _buildSettingTile(
            icon: Icons.description,
            title: 'شروط الاستخدام',
            subtitle: 'اطلع على شروط الاستخدام',
            onTap: () => _showComingSoon('شروط الاستخدام'),
          ),
          
          const SizedBox(height: 40),
          
          // زر تسجيل الخروج
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFB71C1C),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB71C1C)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB71C1C)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFB71C1C),
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB71C1C)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white),
          underline: Container(),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature ستتوفر قريباً!'),
        backgroundColor: const Color(0xFFB71C1C),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'حول Gizmo Store',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Gizmo Store هو متجر إلكتروني متخصص في بيع الأجهزة الإلكترونية والتقنية.\n\nالإصدار: 1.0.0\nتم التطوير بواسطة: فريق Gizmo',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'موافق',
              style: TextStyle(color: Color(0xFFB71C1C)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
