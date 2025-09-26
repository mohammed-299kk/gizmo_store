import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;
import '../providers/admin_provider.dart';
import '../widgets/sidebar.dart';
import '../widgets/dashboard_stats_cards.dart';
import '../widgets/recent_orders_widget.dart';
import '../widgets/quick_actions_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  final List<String> _titles = [
    'Dashboard',
    'Products',
    'Orders',
    'Users',
    'Categories',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboardStats();
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من أنك تريد تسجيل الخروج والعودة إلى شاشة التسجيل؟',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<auth.AuthProvider>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        _titles[_selectedIndex],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const Spacer(),
                      
                      // User menu
                      PopupMenuButton<String>(
                        icon: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        onSelected: (value) {
                          if (value == 'logout') {
                            _showLogoutDialog();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                const Icon(Icons.person, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  context.read<auth.AuthProvider>().user?.email ?? 'مدير النظام',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildProductsContent();
      case 2:
        return _buildOrdersContent();
      case 3:
        return _buildUsersContent();
      case 4:
        return _buildCategoriesContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          DashboardStatsCards(),
          SizedBox(height: 24),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent orders
              Expanded(
                flex: 2,
                child: RecentOrdersWidget(),
              ),
              SizedBox(width: 24),
              
              // Quick actions
              Expanded(
                flex: 1,
                child: QuickActionsWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsContent() {
    return const Center(
      child: Text(
        'Products Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildOrdersContent() {
    return const Center(
      child: Text(
        'Orders Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildUsersContent() {
    return const Center(
      child: Text(
        'Users Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildCategoriesContent() {
    return const Center(
      child: Text(
        'Categories Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
