import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/providers/app_state.dart';
import 'package:gizmo_store/providers/wishlist_provider.dart';
import 'package:gizmo_store/services/firestore_service.dart';
import 'package:gizmo_store/services/firebase_auth_service.dart';
import 'package:gizmo_store/screens/auth/auth_screen.dart';
import 'package:gizmo_store/screens/order/orders_screen.dart';
import 'package:gizmo_store/screens/firebase_details_screen.dart';
import 'package:gizmo_store/screens/edit_profile_screen.dart';
import 'package:gizmo_store/screens/security_settings_screen.dart'; // Added this line
import 'package:gizmo_store/screens/settings_screen.dart';
import 'wishlist_screen.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<WishlistProvider>(context, listen: false).loadWishlist();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final User? user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
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
          const Icon(Icons.person_off_outlined, size: 80, color: Colors.white38),
          const SizedBox(height: 20),
          const Text(
            'أنت زائر الآن',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'سجل الدخول لعرض ملفك الشخصي والاستفادة من ميزات التطبيق الكاملة.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
            strutStyle: StrutStyle(height: 1.5),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('الانتقال إلى صفحة التسجيل'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(User user, BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final appState = Provider.of<AppState>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoCard(user),
          const SizedBox(height: 24),
          _buildStatsRow(user, wishlistProvider),
          const SizedBox(height: 24),
          _buildSettingsSection(appState),
          const SizedBox(height: 24),
          _buildInfoSection(),
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
              onPressed: () => _showLogoutDialog(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(User user) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: FirebaseAuthService.getUserData(user.uid),
      builder: (context, snapshot) {
        final userData = snapshot.data;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB71C1C), Color(0xFF8E0000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
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
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                      child: user.photoURL == null
                          ? Text(
                              user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          : null,
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
                                user.displayName ?? 'مستخدم جديد',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Icon(Icons.cloud_sync, color: Colors.white54, size: 20);
                                } else if (snapshot.hasData) {
                                  return const Icon(Icons.cloud_done, color: Colors.greenAccent, size: 20);
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons.cloud_off, color: Colors.redAccent, size: 20);
                                }
                                return const Icon(Icons.cloud_off, color: Colors.redAccent, size: 20);
                              },
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.edit, color: Colors.white70, size: 18),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (user.email != null)
                          Text(
                            user.email!,
                            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
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
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معرف المستخدم',
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                            ),
                            Text(
                              '${user.uid.substring(0, 8)}...',
                              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تاريخ التسجيل',
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                            ),
                            Text(
                              _formatDate(userData['createdAt']),
                              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
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

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'غير محدد';
    try {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'غير محدد';
    }
  }



  Widget _buildStatsRow(User user, WishlistProvider wishlistProvider) {
    return Row(
      children: [
        Expanded(
          child: FutureBuilder<int>(
            future: _firestoreService.getUserOrderCount(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildStatCard('الطلبات', '...', Icons.shopping_bag_outlined);
              } else if (snapshot.hasError) {
                // Handle the error, e.g., show a message or a specific icon
                debugPrint('Error loading order count: ${snapshot.error}'); // For debugging
                return _buildStatCard('الطلبات', 'خطأ', Icons.error_outline); // Display 'Error'
              } else {
                String count = snapshot.data?.toString() ?? '0';
                return _buildStatCard('الطلبات', count, Icons.shopping_bag_outlined);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('المفضلة', wishlistProvider.itemCount.toString(), Icons.favorite_border),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB71C1C), size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(AppState appState) {
    return _buildSectionContainer(
      'حسابي',
      [
        _buildSettingsOption(icon: Icons.person_outline, title: 'تعديل الملف الشخصي', onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
        }),
        _buildSettingsOption(icon: Icons.shopping_bag_outlined, title: 'طلباتي', onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen()));
        }),
        _buildSettingsOption(icon: Icons.favorite_border, title: 'المفضلة', onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistScreen()));
        }),
        _buildSettingsOption(icon: Icons.location_on_outlined, title: 'العناوين', onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إدارة العناوين قيد التطوير')),
          );
        }),
        _buildSettingsOption(icon: Icons.settings, title: 'الإعدادات', onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
        }),
        _buildSettingsOption(
          icon: Icons.color_lens_outlined,
          title: 'المظهر الداكن',
          trailing: Switch(
            value: appState.isDarkMode,
            onChanged: (value) => appState.toggleDarkMode(),
            activeThumbColor: const Color(0xFFB71C1C),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return _buildSectionContainer(
      'التطبيق',
      [
        _buildSettingsOption(icon: Icons.notifications_none, title: 'الإشعارات', onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إدارة الإشعارات قيد التطوير')),
          );
        }),
        _buildSettingsOption(icon: Icons.help_outline, title: 'المساعدة والدعم', onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('المساعدة والدعم قيد التطوير')),
          );
        }),
        _buildSettingsOption(icon: Icons.security_outlined, title: 'الخصوصية والأمان', onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إعدادات الخصوصية والأمان قيد التطوير')),
          );
        }),
        _buildSettingsOption(icon: Icons.info_outline, title: 'عن التطبيق', onTap: () => _showAboutDialog(context)),
        _buildSettingsOption(icon: Icons.cloud_queue, title: 'تفاصيل Firebase', onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FirebaseDetailsScreen()));
        }),
      ],
    );
  }

  Widget _buildSectionContainer(String title, List<Widget> children) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(Divider(
          height: 1,
          color: Colors.white.withValues(alpha: 0.1),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(children: spacedChildren), // Use spacedChildren here
        ),
      ],
    );
  }

  Widget _buildSettingsOption({required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        // Removed borderRadius here, will be handled by parent Container
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Increased vertical padding
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
                await authProvider.signOut();
              },
              child: const Text('تأكيد', style: TextStyle(color: Colors.redAccent)),
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
          backgroundColor: const Color(0xFF1F1F1F),
          title: const Text('عن Gizmo Store', style: TextStyle(color: Colors.white)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الإصدار: 1.0.0', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('تطبيق متجر إلكتروني تجريبي.', style: TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('موافق'))],
        );
      },
    );
  }
}
