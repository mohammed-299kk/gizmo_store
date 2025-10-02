import 'package:flutter/material.dart';
import 'app_spacing.dart';
import 'app_colors.dart';

/// نظام التنقل وشريط التطبيق الموحد
class AppNavigation {
  AppNavigation._();

  // تصميم شريط التطبيق الأساسي
  static AppBar buildAppBar({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    bool showBackButton = true,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title) : null),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: foregroundColor ?? AppColors.onSurface,
      elevation: elevation ?? AppSpacing.elevationSM,
      leading: leading,
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      bottom: bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: foregroundColor ?? AppColors.onSurface,
      ),
      iconTheme: IconThemeData(
        color: foregroundColor ?? AppColors.onSurface,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? AppColors.onSurface,
        size: 24,
      ),
    );
  }

  // شريط تطبيق مخصص للصفحة الرئيسية
  static AppBar buildHomeAppBar({
    required BuildContext context,
    String? title,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return buildAppBar(
      context: context,
      title: title ?? 'متجر جيزمو',
      actions: actions ?? [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        AppSpacing.horizontalSM,
      ],
      leading: leading,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSpacing.elevationMD,
    );
  }

  // شريط تطبيق للصفحات الفرعية
  static AppBar buildSubPageAppBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return buildAppBar(
      context: context,
      title: title,
      actions: actions,
      leading: leading,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: AppSpacing.elevationSM,
    );
  }

  // شريط تنقل سفلي
  static BottomNavigationBar buildBottomNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required Function(int) onTap,
    List<BottomNavigationBarItem>? items,
  }) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.primary.withOpacity(0.7),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      elevation: AppSpacing.elevationMD,
      items: items ?? _defaultBottomNavItems,
    );
  }

  // عناصر التنقل السفلي الافتراضية
  static const List<BottomNavigationBarItem> _defaultBottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'الرئيسية',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category_outlined),
      activeIcon: Icon(Icons.category),
      label: 'الفئات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart_outlined),
      activeIcon: Icon(Icons.shopping_cart),
      label: 'السلة',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline),
      activeIcon: Icon(Icons.favorite),
      label: 'المفضلة',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'الحساب',
    ),
  ];

  // درج التنقل الجانبي
  static Drawer buildDrawer({
    required BuildContext context,
    Widget? header,
    List<Widget>? items,
  }) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          header ?? _buildDefaultDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items ?? _buildDefaultDrawerItems(context),
            ),
          ),
        ],
      ),
    );
  }

  // رأس الدرج الافتراضي
  static Widget _buildDefaultDrawerHeader(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.onPrimary,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.verticalMD,
              Text(
                'مرحباً بك',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'في متجر جيزمو',
                style: TextStyle(
                  color: AppColors.onPrimary.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // عناصر الدرج الافتراضية
  static List<Widget> _buildDefaultDrawerItems(BuildContext context) {
    return [
      _buildDrawerItem(
        context: context,
        icon: Icons.home,
        title: 'الرئيسية',
        onTap: () => Navigator.pushReplacementNamed(context, '/'),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.category,
        title: 'الفئات',
        onTap: () => Navigator.pushNamed(context, '/categories'),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.shopping_cart,
        title: 'السلة',
        onTap: () => Navigator.pushNamed(context, '/cart'),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.favorite,
        title: 'المفضلة',
        onTap: () => Navigator.pushNamed(context, '/wishlist'),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.receipt_long,
        title: 'طلباتي',
        onTap: () => Navigator.pushNamed(context, '/orders'),
      ),
      const Divider(),
      _buildDrawerItem(
        context: context,
        icon: Icons.settings,
        title: 'الإعدادات',
        onTap: () => Navigator.pushNamed(context, '/settings'),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.help,
        title: 'المساعدة',
        onTap: () => Navigator.pushNamed(context, '/help'),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.logout,
        title: 'تسجيل الخروج',
        onTap: () {
          // تسجيل الخروج
        },
        textColor: AppColors.error,
      ),
    ];
  }

  // عنصر درج مخصص
  static Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMD,
      ),
      contentPadding: AppSpacing.paddingMD,
    );
  }

  // شريط بحث مخصص
  static Widget buildSearchBar({
    required BuildContext context,
    String? hintText,
    TextEditingController? controller,
    Function(String)? onChanged,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      margin: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText ?? 'البحث في المنتجات...',
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.onSurface.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.paddingMD,
          hintStyle: TextStyle(
            color: AppColors.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  // شريط علامات التبويب
  static TabBar buildTabBar({
    required List<Tab> tabs,
    TabController? controller,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
  }) {
    return TabBar(
      controller: controller,
      tabs: tabs,
      indicatorColor: indicatorColor ?? AppColors.primary,
      labelColor: labelColor ?? AppColors.primary,
      unselectedLabelColor: unselectedLabelColor ?? AppColors.onSurface.withOpacity(0.6),
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    );
  }
}

/// ويدجت مخصص لشريط التطبيق مع تأثيرات
class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const AnimatedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          title,
          key: ValueKey(title),
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: foregroundColor ?? AppColors.onSurface,
      elevation: elevation ?? AppSpacing.elevationSM,
      leading: leading,
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}