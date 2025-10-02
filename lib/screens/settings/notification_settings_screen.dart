import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:gizmo_store/providers/theme_provider.dart';
import 'package:gizmo_store/providers/language_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

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
          // Theme Section
          _buildSectionTitle(context, 'المظهر'),
          _buildSettingsCard(
            context,
            children: [
              ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'الوضع الداكن',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  themeProvider.isDarkMode ? 'مفعّل' : 'غير مفعّل',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.8),
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Language Section
          _buildSectionTitle(context, 'اللغة'),
          _buildSettingsCard(
            context,
            children: [
              ListTile(
                leading: Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'لغة التطبيق',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  languageProvider.languageDisplayName,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.8),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
                  size: 16,
                ),
                onTap: () => _showLanguageDialog(context, languageProvider),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Notifications Section
          _buildSectionTitle(context, 'الإشعارات'),
          _buildSettingsCard(
            context,
            children: [
              ListTile(
                leading: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'إعدادات الإشعارات',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'إدارة تفضيلات الإشعارات',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.8),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
                  size: 16,
                ),
                onTap: () {
                  // Navigate to detailed notifications settings
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('اختر اللغة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('العربية'),
                value: 'ar',
                groupValue: languageProvider.currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    languageProvider.changeLanguage(value);
                    Navigator.pop(dialogContext);
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: languageProvider.currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    languageProvider.changeLanguage(value);
                    Navigator.pop(dialogContext);
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}
