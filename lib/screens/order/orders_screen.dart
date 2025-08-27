import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // تم استيراد حزمة intl
import 'package:cached_network_image/cached_network_image.dart'; // تم استيراد حزمة الصور

class Order {
  final String id;
  final DateTime date;
  final String status;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });
}

class OrderItem {
  final String id;
  final String name;
  final String image;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<String> _statusFilters = [
    'الكل',
    'قيد التحضير',
    'قيد الشحن',
    'تم التوصيل',
    'ملغي'
  ];
  String _selectedStatus = 'الكل';
  bool _isLoading = false;

  // بيانات الطلبات (عادة ما تأتي من API)
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];

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
    _loadOrders();
  }

  void _loadOrders() async {
    setState(() => _isLoading = true);

    // محاكاة جلب البيانات من API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _orders = [
        Order(
          id: '#12345',
          date: DateTime(2024, 12, 15),
          status: 'تم التوصيل',
          total: 1299.99,
          items: [
            OrderItem(
              id: '1',
              name: 'iPhone 15 Pro Max',
              image: 'assets/images/VKy5jNI8bXPK.jpg',
              quantity: 1,
              price: 1299.99,
            ),
          ],
        ),
        Order(
          id: '#12344',
          date: DateTime(2024, 12, 10),
          status: 'قيد الشحن',
          total: 849.98,
          items: [
            OrderItem(
                name: 'Samsung Galaxy S24 Ultra',
                id: '2',
                image: 'assets/images/qKQgpMAdtwg6.jpg',
                quantity: 1,
                price: 699.99),
            OrderItem(
                name: 'AirPods Pro',
                id: '3',
                image: 'assets/images/d7xOEiY2GQmU.jpg',
                quantity: 1,
                price: 149.99),
          ],
        ),
        Order(
          id: '#12343',
          date: DateTime(2024, 12, 5),
          status: 'قيد التحضير',
          total: 2199.99,
          items: [
            OrderItem(
                name: 'MacBook Pro 16"',
                id: '4',
                image: 'assets/images/a3RdtOgqMZcB.jpg',
                quantity: 1,
                price: 2199.99)
          ],
        ),
      ];
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredOrders = _orders.where((order) {
        return _selectedStatus == 'الكل' || order.status == _selectedStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: Column(
        children: [
          // فلتر حالة الطلب
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
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
                  _applyFilters();
                });
              },
            ),
          ),

          // قائمة الطلبات
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'لا توجد طلبات',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadOrders,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB71C1C),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('إعادة تحميل'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _loadOrders(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = _filteredOrders[index];
                            return _buildOrderCard(order);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB71C1C),
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
                    side: const BorderSide(color: Color(0xFFB71C1C)),
                  ),
                  child: const Text('تفاصيل الطلب',
                      style: TextStyle(color: Color(0xFFB71C1C))),
                ),
                if (order.status == 'قيد الشحن')
                  ElevatedButton(
                    onPressed: () => _trackOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
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

  Widget _buildOrderItem(OrderItem item) {
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
        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تم التوصيل':
        return Colors.green;
      case 'قيد الشحن':
        return Colors.blue;
      case 'قيد التحضير':
        return Colors.orange;
      case 'ملغي':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OrderDetailsScreen(order: order),
    );
  }

  void _trackOrder(Order order) {
    // تنقل إلى شاشة تتبع الطلب
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
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

  Widget _buildOrderItem(OrderItem item) {
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
      trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
    );
  }
}
