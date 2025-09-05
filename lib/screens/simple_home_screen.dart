import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class SimpleHomeScreen extends StatelessWidget {
  final String userType;

  const SimpleHomeScreen({super.key, this.userType = 'user'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Gizmo Store'),
        backgroundColor: Color(0xFFB71C1C), // Changed from Color(0xFFB71C1C) to orange
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFFB71C1C), // Changed from Color(0xFFB71C1C) to orange
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // رسالة ترحيب
            Text(
              userType == 'guest' ? AppLocalizations.of(context)!.welcomeGuest : AppLocalizations.of(context)!.welcome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              AppLocalizations.of(context)!.appLaunchedSuccessfully,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),

            // معلومات المستخدم
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        userType == 'guest' ? Icons.person_outline : Icons.person,
                        color: Color(0xFFB71C1C),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${AppLocalizations.of(context)!.userType}: ${userType == 'guest' ? AppLocalizations.of(context)!.guest : AppLocalizations.of(context)!.registeredUser}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.appWorkingNormally,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // أزرار التنقل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.shopping_cart,
                  label: AppLocalizations.of(context)!.cart,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.cartWorks),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.favorite,
                  label: AppLocalizations.of(context)!.wishlist,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.favoritesWork),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.settings,
                  label: AppLocalizations.of(context)!.settings,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.settingsWork),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFB71C1C),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
