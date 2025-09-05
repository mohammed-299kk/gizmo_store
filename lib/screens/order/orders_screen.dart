import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/order.dart' as order_model;
import '../../services/firestore_service.dart';
import '../../utils/app_exceptions.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () async {
              if (_currentUserId != null) {
                await _firestoreService.addSampleOrders(_currentUserId!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة طلبات تجريبية بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force rebuild to refresh the stream
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // فلتر حالة الطلب
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'فلتر حسب الحالة',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              items: _statusFilters.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),

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
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return _buildOrderCard(order);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'يجب تسجيل الدخول لعرض الطلبات',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// عرض رسالة الخطأ
  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ أثناء تحميل الطلبات',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {}); // إعادة بناء الـ StreamBuilder
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  /// عرض رسالة عدم وجود طلبات
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _selectedStatus == 'الكل'
                ? 'لا توجد طلبات بعد'
                : 'لا توجد طلبات بحالة "$_selectedStatus"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ التسوق لإنشاء طلبك الأول',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(order_model.Order order) {
    final dateFormat = DateFormat('yyyy-MM-dd'); // استخدام DateFormat بشكل صحيح

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            order.status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'طلب ${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('تاريخ: ${dateFormat.format(order.date)}'),
        trailing: Text(
          '${order.total.toStringAsFixed(0)} جنيه',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        children: [
          ...order.items.map((item) => _buildOrderItem(item)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () => _viewOrderDetails(order),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  child: Text('تفاصيل الطلب',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ),
                if (order.status == 'قيد الشحن')
                  ElevatedButton(
                    onPressed: () => _trackOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text('تتبع الطلب'),
                  ),
              ],
            ),
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
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(item.name),
      subtitle: Text('الكمية: ${item.quantity}'),
      trailing: Text(
        '${(item.price * item.quantity).toStringAsFixed(0)} جنيه',
        style: const TextStyle(fontWeight: FontWeight.bold),
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('إغلاق'),
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
