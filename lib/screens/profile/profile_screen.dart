import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/providers/wishlist_provider.dart';
import 'package:gizmo_store/services/firestore_service.dart';
import 'package:gizmo_store/services/firebase_auth_service.dart';
import 'package:gizmo_store/screens/auth/auth_screen.dart';
import 'package:gizmo_store/screens/order/orders_screen.dart';
import 'package:gizmo_store/screens/edit_profile_screen.dart';
import 'package:gizmo_store/screens/security_settings_screen.dart';
import 'package:gizmo_store/screens/settings_screen.dart';
import 'package:gizmo_store/screens/profile/address_management_screen.dart';
import 'package:gizmo_store/screens/profile/notifications_screen.dart';
import 'package:gizmo_store/screens/profile/help_support_screen.dart';
import 'package:gizmo_store/screens/wishlist/wishlist_screen.dart';
import 'package:gizmo_store/utils/image_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // WishlistProvider now uses real-time listener, no need to manually load
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final User? user = authProvider.user;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
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
          Icon(Icons.person_off_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.youAreGuestNow,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.loginToViewProfile,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16),
            textAlign: TextAlign.center,
            strutStyle: const StrutStyle(height: 1.5),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(AppLocalizations.of(context)!.goToRegistrationPage),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(User user, BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(context, user),
          const SizedBox(height: 24),
          _buildStatsRow(context, user, wishlistProvider),
          const SizedBox(height: 24),
          _buildSettingsSection(context),
          const SizedBox(height: 24),
          _buildInfoSection(context),
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: Text(AppLocalizations.of(context)!.logout,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16)),
              onPressed: () => _showLogoutDialog(context),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, dynamic timestamp) {
    if (timestamp == null) return AppLocalizations.of(context)!.notSpecified;
    try {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return AppLocalizations.of(context)!.notSpecified;
    }
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    // استخدام StreamBuilder بدلاً من FutureBuilder لتجنب مشاكل timeout
    // عرض المعلومات من Firebase Auth مباشرة، وتحديثها من Firestore عند توفرها
    return StreamBuilder<Map<String, dynamic>?>(
      stream: _firestoreService.getUserDataStream(user.uid),
      initialData: null, // لا ننتظر البيانات، نعرض من Firebase Auth مباشرة
      builder: (context, snapshot) {
        // عرض المعلومات الأساسية من Firebase Auth مباشرة
        // وتحديثها من Firestore عند توفرها
        final userData = snapshot.data;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: user.photoURL != null &&
                                user.photoURL!.isNotEmpty
                            ? ClipOval(
                                child: ImageHelper.buildCachedImage(
                                  imageUrl: user.photoURL!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Text(
                                  user.displayName
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      'U',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user.displayName ??
                                        AppLocalizations.of(context)!.newUser,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                StreamBuilder<User?>(
                                  stream:
                                      FirebaseAuth.instance.authStateChanges(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Icon(Icons.cloud_sync,
                                          color: Colors.white54, size: 20);
                                    } else if (snapshot.hasData) {
                                      return const Icon(Icons.cloud_done,
                                          color: Colors.greenAccent, size: 20);
                                    } else if (snapshot.hasError) {
                                      return const Icon(Icons.cloud_off,
                                          color: Colors.redAccent, size: 20);
                                    }
                                    return const Icon(Icons.cloud_off,
                                        color: Colors.redAccent, size: 20);
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.edit,
                                    color: Colors.white70, size: 18),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (user.email != null)
                              Text(
                                user.email!,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.8)),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (userData != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.white70, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Member since',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                _formatDate(context, userData['createdAt']),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(
      BuildContext context, User user, WishlistProvider wishlistProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(context, AppLocalizations.of(context)!.orders,
              '', Icons.shopping_cart_outlined, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()));
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
              context,
              AppLocalizations.of(context)!.favorites,
              '',
              Icons.favorite_border, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WishlistScreen()));
          }),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: Theme.of(context).colorScheme.primary, size: 32),
              const SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSectionContainer(
      context,
      AppLocalizations.of(context)!.myAccount,
      [
        _buildSettingsOption(context,
            icon: Icons.person_outline,
            title: AppLocalizations.of(context)!.editProfile, onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditProfileScreen()));
        }),
        _buildSettingsOption(context,
            icon: Icons.shopping_cart_outlined,
            title: AppLocalizations.of(context)!.myOrders, onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OrdersScreen()));
        }),
        _buildSettingsOption(context,
            icon: Icons.favorite_border,
            title: AppLocalizations.of(context)!.favorites, onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WishlistScreen()));
        }),
        _buildSettingsOption(context,
            icon: Icons.location_on_outlined,
            title: AppLocalizations.of(context)!.addresses, onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddressManagementScreen()));
        }),
        _buildSettingsOption(context,
            icon: Icons.settings,
            title: AppLocalizations.of(context)!.settings, onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
        }),
        // Dark mode toggle removed - available in Settings screen
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return _buildSectionContainer(
      context,
      AppLocalizations.of(context)!.app,
      [
        _buildSettingsOption(context,
            icon: Icons.notifications_none,
            title: AppLocalizations.of(context)!.notifications, onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()));
        }),
        _buildSettingsOption(context,
            icon: Icons.help_outline,
            title: AppLocalizations.of(context)!.helpAndSupport, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HelpSupportScreen(),
            ),
          );
        }),
        _buildSettingsOption(context,
            icon: Icons.security_outlined,
            title: AppLocalizations.of(context)!.privacyAndSecurity, onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SecuritySettingsScreen()));
        }),
        _buildSettingsOption(context,
            icon: Icons.info_outline,
            title: AppLocalizations.of(context)!.aboutApp,
            onTap: () => _showAboutDialog(context)),
      ],
    );
  }

  Widget _buildSectionContainer(
      BuildContext context, String title, List<Widget> children) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(Divider(
          height: 1,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          indent: 16,
          endIndent: 16,
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(children: spacedChildren), // Use spacedChildren here
        ),
      ],
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required IconData icon,
      required String title,
      Widget? trailing,
      VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        // Removed borderRadius here, will be handled by parent Container
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14), // Increased vertical padding
          child: Row(
            children: [
              Icon(icon,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  size: 22),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16))),
              trailing ??
                  Icon(Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.38)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(AppLocalizations.of(context)!.logout,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text(AppLocalizations.of(context)!.areYouSureYouWantToLogout,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.7))),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7)))),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider =
                    Provider.of<auth.AuthProvider>(context, listen: false);
                await authProvider.signOut();
              },
              child: Text(AppLocalizations.of(context)!.confirm,
                  style: const TextStyle(color: Colors.redAccent)),
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(AppLocalizations.of(context)!.aboutGizmoStore,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.version100,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7))),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.demoEcommerceApp,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7))),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.ok,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)))
          ],
        );
      },
    );
  }
}
