import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('الخصوصية والأمان', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('إعدادات الأمان'),
            _buildDetailCard([
              _buildSettingsOption(
                icon: Icons.lock_outline,
                title: 'تغيير كلمة المرور',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تغيير كلمة المرور قيد التطوير')),
                  );
                },
              ),
              _buildSettingsOption(
                icon: Icons.fingerprint,
                title: 'المصادقة البيومترية',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('المصادقة البيومترية قيد التطوير')),
                  );
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('إعدادات الخصوصية'),
            _buildDetailCard([
              _buildSettingsOption(
                icon: Icons.privacy_tip_outlined,
                title: 'إدارة بيانات الخصوصية',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('إدارة بيانات الخصوصية قيد التطوير')),
                  );
                },
              ),
              _buildSettingsOption(
                icon: Icons.policy_outlined,
                title: 'سياسة الخصوصية',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سياسة الخصوصية قيد التطوير')),
                  );
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSettingsOption({required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 22),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
              trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}