import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'security_settings_screen.dart';
import 'profile/address_management_screen.dart';
import 'profile/notifications_screen.dart';
import 'profile/help_support_screen.dart';
import 'edit_profile_screen.dart';
import 'payment_methods_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(AppLocalizations.of(context)!.account),
          _buildSettingTile(
            icon: Icons.person,
            title: AppLocalizations.of(context)!.profile,
            subtitle: 'تحديث معلوماتك الشخصية',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.security,
            title: 'الأمان والخصوصية',
            subtitle: 'إدارة كلمة المرور والأمان',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecuritySettingsScreen(),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.location_on,
            title: AppLocalizations.of(context)!.addressManagement,
            subtitle: 'إضافة وتعديل عناوين التوصيل',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddressManagementScreen(),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.local_shipping,
            title: AppLocalizations.of(context)!.shipping,
            subtitle: 'إدارة طرق الشحن',
            onTap: () => Navigator.pushNamed(context, '/shipping'),
          ),
          _buildSettingTile(
            icon: Icons.payment,
            title: AppLocalizations.of(context)!.paymentMethods,
            subtitle: 'إدارة طرق الدفع',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
          _buildSectionTitle('التطبيق'),

          _buildSettingTile(
            icon: Icons.notifications,
            title: AppLocalizations.of(context)!.notifications,
            subtitle: 'إدارة إعدادات الإشعارات',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),

          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildSwitchTile(
                icon: Icons.dark_mode,
                title: AppLocalizations.of(context)!.darkMode,
                subtitle: 'تفعيل الوضع المظلم',
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.setTheme(value);
                },
              );
            },
          ),

          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return _buildDropdownTile(
                icon: Icons.language,
                title: AppLocalizations.of(context)!.language,
                value: languageProvider.languageDisplayName,
                items: [
                  AppLocalizations.of(context)!.languageArabic,
                  AppLocalizations.of(context)!.languageEnglish,
                ],
                onChanged: (value) {
                  String languageCode =
                      value == AppLocalizations.of(context)!.languageArabic
                          ? 'ar'
                          : 'en';
                  languageProvider.changeLanguage(languageCode);
                },
              );
            },
          ),

          const SizedBox(height: 20),
          _buildSectionTitle(AppLocalizations.of(context)!.helpAndSupport),

          _buildSettingTile(
            icon: Icons.help_outline,
            title: AppLocalizations.of(context)!.helpCenter,
            subtitle: 'الأسئلة الشائعة والدعم',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),

          _buildSettingTile(
            icon: Icons.contact_support,
            title: AppLocalizations.of(context)!.contactUs,
            subtitle: 'خدمة العملاء والدعم الفني',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),

          _buildSettingTile(
            icon: Icons.star_rate,
            title: AppLocalizations.of(context)!.rateApp,
            subtitle: 'شاركنا رأيك في التطبيق',
            onTap: () => _showComingSoon(AppLocalizations.of(context)!.rateApp),
          ),

          const SizedBox(height: 20),
          _buildSectionTitle(AppLocalizations.of(context)!.appInfo),

          _buildSettingTile(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context)!.aboutApp,
            subtitle: AppLocalizations.of(context)!.version,
            onTap: () => _showAboutDialog(),
          ),

          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: AppLocalizations.of(context)!.privacyPolicy,
            subtitle: 'اطلع على سياسة الخصوصية',
            onTap: () =>
                _showComingSoon(AppLocalizations.of(context)!.privacyPolicy),
          ),

          _buildSettingTile(
            icon: Icons.description,
            title: AppLocalizations.of(context)!.termsOfService,
            subtitle: 'اطلع على شروط الاستخدام',
            onTap: () =>
                _showComingSoon(AppLocalizations.of(context)!.termsOfService),
          ),

          const SizedBox(height: 40),

          // زر تسجيل الخروج
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: const TextStyle(
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
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.8)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.8)),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: Theme.of(context).cardColor,
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
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
        content: Text('$feature ${AppLocalizations.of(context)!.comingSoon}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Text(
          AppLocalizations.of(context)!.aboutGizmoStore,
          style:
              TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: Text(
          AppLocalizations.of(context)!.aboutDescription,
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Text(
          AppLocalizations.of(context)!.logout,
          style:
              TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: Text(
          AppLocalizations.of(context)!.logoutConfirmation,
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.6)),
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
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(
              AppLocalizations.of(context)!.logout,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
