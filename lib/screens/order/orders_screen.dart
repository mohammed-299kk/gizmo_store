import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/order.dart' as order_model;
import '../../services/firestore_service.dart';
import '../../utils/app_exceptions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_animations.dart';
import '../../constants/app_buttons.dart';
import '../../constants/app_navigation.dart';
import '../../constants/app_cards.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedStatus = 'الكل';
  String? _currentUserId;

  final List<String> _statusFilters = [
    'الكل',
    'قيد التحضير',
    'قيد الشحن',
    'تم التوصيل',
    'ملغي'
  ];

  // دالة مساعدة لتحديد نوع الصورة وعرضها بشكل صحيح
  Widget _buildImageWidget(String? imagePath,
      {double? width, double? height, BoxFit? fit}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // إذا كانت الصورة تبدأ بـ http أو https فهي من الإنترنت
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else {
      // إذا لم تبدأ بـ http فهي صورة محلية
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  /// جلب معرف المستخدم الحالي
  void _getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
    }
  }

  /// تصفية الطلبات حسب الحالة المحددة
  String? get _statusFilter {
    return _selectedStatus == 'الكل' ? null : _selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigation.buildSubPageAppBar(
        context: context,
        title: 'طلباتي',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // فتح فلتر الطلبات
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // فلتر حالة الطلب
          Container(
            margin: AppSpacing.screenPaddingHorizontal,
            padding: AppSpacing.paddingMD,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppSpacing.borderRadiusLG,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppAnimations.fadeInUp(
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'فلتر حسب الحالة',
                  border: OutlineInputBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: AppSpacing.paddingMD,
                  prefixIcon: Icon(
                    Icons.filter_list_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                items: _statusFilters.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
            ),
          ),
          AppSpacing.verticalMD,

          // قائمة الطلبات مع StreamBuilder
          Expanded(
            child: _currentUserId == null
                ? _buildNotLoggedInView()
                : StreamBuilder<List<order_model.Order>>(
                    stream: _firestoreService.getUserOrdersStream(
                      _currentUserId!,
                      status: _statusFilter,
                    ),
                    builder: (context, snapshot) {
                      // حالة التحميل
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      
                      // حالة الخطأ
                      if (snapshot.hasError) {
                        return _buildErrorView(snapshot.error.toString());
                      }
                      
                      // حالة عدم وجود بيانات
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyView();
                      }
                      
                      // عرض الطلبات
                      final orders = snapshot.data!;
                      return RefreshIndicator(
                        onRefresh: () async {
                          // إعادة تحميل البيانات عن طريق إعادة بناء الـ Stream
                          setState(() {});
                        },
                        child: ListView.separated(
                          padding: AppSpacing.screenPaddingAll,
                          itemCount: orders.length,
                          separatorBuilder: (context, index) => AppSpacing.verticalMD,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return AppAnimations.fadeInUp(
                              delay: Duration(milliseconds: index * 100),
                              child: _buildOrderCard(order),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// عرض رسالة للمستخدم غير المسجل
  Widget _buildNotLoggedInView() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: AppAnimations.fadeInUp(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: AppSpacing.paddingXXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  size: AppSpacing.iconSizeXLarge * 2,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              AppSpacing.verticalXL,
              Text(
                'يجب تسجيل الدخول لعرض الطلبات',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalMD,
              Text(
                'سجل دخولك لتتمكن من متابعة طلباتك',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalXL,
              AppButton(
                text: 'تسجيل الدخول',
                onPressed: () => Navigator.pushNamed(context, '/auth'),
                icon: const Icon(Icons.login_outlined),
                style: AppButtons.primaryButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// عرض رسالة الخطأ
  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: AppAnimations.fadeInUp(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: AppSpacing.paddingXXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: AppSpacing.iconSizeXLarge * 2,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              AppSpacing.verticalXL,
              Text(
                'حدث خطأ أثناء تحميل الطلبات',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalMD,
              Container(
                padding: AppSpacing.paddingMD,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: AppSpacing.borderRadiusMD,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  error,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.verticalXL,
              AppButton(
                text: 'إعادة المحاولة',
                onPressed: () {
                  setState(() {}); // إعادة بناء الـ StreamBuilder
                },
                icon: const Icon(Icons.refresh_outlined),
                style: AppButtons.primaryButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// عرض رسالة عدم وجود طلبات
  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: AppAnimations.fadeInUp(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: AppSpacing.paddingXXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: AppSpacing.iconSizeXLarge * 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              AppSpacing.verticalXL,
              Text(
                _selectedStatus == 'الكل'
                    ? 'لا توجد طلبات بعد'
                    : 'لا توجد طلبات بحالة "$_selectedStatus"',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalMD,
              Text(
                'ابدأ التسوق لإنشاء طلبك الأول',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalXL,
              AppButton(
                text: 'ابدأ التسوق',
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.shopping_cart_outlined),
                style: AppButtons.primaryButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(order_model.Order order) {
    final dateFormat = DateFormat('yyyy-MM-dd'); // استخدام DateFormat بشكل صحيح

    return AppCard(
      decoration: AppCards.orderCard,
      margin: AppSpacing.paddingMD,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLG,
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLG,
            ),
          ),
        ),
        child: ExpansionTile(
          tilePadding: AppSpacing.paddingLG,
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            padding: AppSpacing.paddingSM,
            decoration: BoxDecoration(
              color: _getStatusColor(order.status),
              borderRadius: AppSpacing.borderRadiusSM,
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(order.status).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              order.status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            'طلب ${order.id}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Padding(
            padding: AppSpacing.paddingTopXS,
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppSpacing.iconSizeSmall,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                AppSpacing.horizontalXS,
                Text(
                  'تاريخ: ${dateFormat.format(order.date)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: AppSpacing.paddingSM,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              borderRadius: AppSpacing.borderRadiusSM,
            ),
            child: Text(
              '${order.total.toStringAsFixed(0)} جنيه',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          children: [
            Container(
              padding: AppSpacing.paddingLG,
              child: Column(
                children: [
                  ...order.items.map((item) => Padding(
                    padding: AppSpacing.paddingBottomSM,
                    child: _buildOrderItem(item),
                  )),
                  Divider(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    thickness: 1,
                  ),
                  AppSpacing.verticalMD,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _viewOrderDetails(order),
                          icon: Icon(
                            Icons.visibility_outlined,
                            size: AppSpacing.iconSizeSmall,
                          ),
                          label: const Text('تفاصيل الطلب'),
                          style: OutlinedButton.styleFrom(
                            padding: AppSpacing.buttonPaddingMedium,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.buttonBorderRadius,
                            ),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      if (order.status == 'قيد الشحن') ...[
                        AppSpacing.horizontalMD,
                        Expanded(
                          child: AppButton(
                            text: 'تتبع الطلب',
                            onPressed: () => _trackOrder(order),
                            icon: Icon(
                              Icons.local_shipping_outlined,
                              size: AppSpacing.iconSizeSmall,
                            ),
                            style: AppButtons.primaryButton,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(order_model.OrderItem item) {
    return AppCard(
      decoration: AppCards.basicCard.copyWith(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      ),
      padding: AppSpacing.paddingMD,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusMD,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildImageWidget(
                item.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalXS,
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: AppSpacing.iconSizeXSmall,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    AppSpacing.horizontalXS,
                    Text(
                      'الكمية: ${item.quantity}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: AppSpacing.paddingSM,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              borderRadius: AppSpacing.borderRadiusSM,
            ),
            child: Text(
              '${(item.price * item.quantity).toStringAsFixed(0)} جنيه',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تم التوصيل':
        return Colors.green;
      case 'قيد الشحن':
        return Color(0xFFB71C1C);
      case 'قيد التحضير':
        return Color(0xFFB71C1C);
      case 'ملغي':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewOrderDetails(order_model.Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OrderDetailsScreen(order: order),
    );
  }

  void _trackOrder(order_model.Order order) {
    // تنقل إلى شاشة تتبع الطلب
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final order_model.Order order;

  const OrderDetailsScreen({super.key, required this.order});

  // دالة مساعدة لتحديد نوع الصورة وعرضها بشكل صحيح
  Widget _buildImageWidget(String? imagePath,
      {double? width, double? height, BoxFit? fit}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // إذا كانت الصورة تبدأ بـ http أو https فهي من الإنترنت
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else {
      // إذا لم تبدأ بـ http فهي صورة محلية
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat =
        DateFormat('yyyy-MM-dd HH:mm'); // استخدام DateFormat بشكل صحيح

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'تفاصيل الطلب #${order.id}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text('تاريخ الطلب: ${dateFormat.format(order.date)}'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.credit_card, size: 16),
              SizedBox(width: 8),
              Text('طريقة الدفع: بطاقة ائتمان'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 8),
              Text('العنوان: الخرطوم، حي الرياض، شارع النيل فهد'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'المنتجات:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...order.items.map((item) => _buildOrderItem(item)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المجموع الفرعي:'),
              Text('${order.total.toStringAsFixed(0)} جنيه'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الشحن:'),
              Text('10 جنيه'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الضريبة:'),
              Text('${(order.total * 0.15).toStringAsFixed(0)} جنيه'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الكلي:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${(order.total + 10 + (order.total * 0.15)).toStringAsFixed(0)} جنيه',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'إغلاق',
            onPressed: () => Navigator.pop(context),
            style: AppButtons.primaryButton,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(order_model.OrderItem item) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImageWidget(
          item.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(item.name),
      subtitle: Text('الكمية: ${item.quantity}'),
      trailing: Text('${(item.price * item.quantity).toStringAsFixed(0)} جنيه'),
    );
  }
}
