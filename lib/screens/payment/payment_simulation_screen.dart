import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/order.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';
import '../../services/firebase_auth_service.dart';
import '../../l10n/app_localizations.dart';

class PaymentSimulationScreen extends StatefulWidget {
  final double totalAmount;
  final String? shippingAddress;
  final String? phoneNumber;
  final List<CartItem> cartItems;

  const PaymentSimulationScreen({
    super.key,
    required this.totalAmount,
    this.shippingAddress,
    this.phoneNumber,
    required this.cartItems,
  });

  @override
  State<PaymentSimulationScreen> createState() =>
      _PaymentSimulationScreenState();
}

class _PaymentSimulationScreenState extends State<PaymentSimulationScreen> {
  bool _isLoading = false;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> _savedCards = [];
  String? _selectedSavedCard;

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getStringList('saved_cards') ?? [];
    setState(() {
      _savedCards = cardsJson
          .map((cardJson) => Map<String, String>.from(json.decode(cardJson)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار طريقة الدفع'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ملخص الطلب
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ملخص الطلب',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('المجموع الإجمالي:'),
                              Text(
                                '${widget.totalAmount.toStringAsFixed(0)} جنيه',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // خيارات الدفع
                  const Text(
                    'اختر طريقة الدفع:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // زر الدفع بالبطاقة
                  ElevatedButton.icon(
                    onPressed: () => _showCardPaymentDialog(),
                    icon: const Icon(Icons.credit_card),
                    label: const Text('الدفع بالبطاقة (فيزا/ماستركارد)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // زر الدفع نقداً
                  ElevatedButton.icon(
                    onPressed: () => _processCashPayment(),
                    icon: const Icon(Icons.money),
                    label: const Text('الدفع نقداً عند الاستلام'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // زر الإلغاء
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel),
                    label: const Text('إلغاء'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ملاحظة المحاكاة
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFB71C1C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFB71C1C)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: Color(0xFFB71C1C)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'هذا نظام محاكاة لمشروع التخرج. لا يتم خصم أموال حقيقية.',
                            style: TextStyle(color: Color(0xFFB71C1C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showCardPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الدفع بالبطاقة'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // البطاقات المحفوظة
                if (_savedCards.isNotEmpty) ...[
                  const Text(
                    'البطاقات المحفوظة:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._savedCards.asMap().entries.map((entry) {
                    final index = entry.key;
                    final card = entry.value;
                    return RadioListTile<String>(
                      title: Text(
                          '${card['type']} **** ${card['number']!.substring(card['number']!.length - 4)}'),
                      subtitle: Text('${card['holder']} - ${card['expiry']}'),
                      value: index.toString(),
                      groupValue: _selectedSavedCard,
                      onChanged: (value) {
                        setState(() {
                          _selectedSavedCard = value;
                          if (value != null) {
                            final selectedCard = _savedCards[int.parse(value)];
                            _cardHolderController.text =
                                selectedCard['holder']!;
                            _cardNumberController.text =
                                selectedCard['number']!;
                            _expiryController.text = selectedCard['expiry']!;
                            _cvvController.text = selectedCard['cvv']!;
                          }
                        });
                        Navigator.pop(context);
                        _showCardPaymentDialog();
                      },
                    );
                  }).toList(),
                  const Divider(),
                  const Text(
                    'أو أدخل بطاقة جديدة:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(
                    labelText: 'اسم حامل البطاقة',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم حامل البطاقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم البطاقة',
                    border: OutlineInputBorder(),
                    hintText: '1234 5678 9012 3456',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم البطاقة';
                    }
                    if (value.length < 16) {
                      return 'رقم البطاقة يجب أن يكون 16 رقم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: const InputDecoration(
                          labelText: 'تاريخ الانتهاء',
                          border: OutlineInputBorder(),
                          hintText: 'MM/YY',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'مطلوب';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                          hintText: '123',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'مطلوب';
                          }
                          if (value.length != 3) {
                            return '3 أرقام';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'محاكاة: لا يتم خصم أموال حقيقية',
                    style: TextStyle(color: Color(0xFFB71C1C), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                _processCardPayment();
              }
            },
            child: const Text('ادفع الآن (وهمياً)'),
          ),
        ],
      ),
    );
  }

  Future<void> _processCardPayment() async {
    await _createOrder('credit_card', 'paid');
  }

  Future<void> _processCashPayment() async {
    // عرض تأكيد للدفع نقداً
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الدفع نقداً'),
        content: const Text(
          'سيتم توصيل طلبك وستدفع نقداً عند الاستلام.\n\nهل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _createOrder('cash_on_delivery', 'pending');
    }
  }

  Future<void> _createOrder(String paymentMethod, String status) async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // If user is not logged in, sign them in anonymously as guest
      if (user == null) {
        try {
          final credential =
              await FirebaseAuthService.signInAnonymously(context);
          user = credential?.user;
          if (user == null) {
            throw Exception('فشل في تسجيل الدخول كضيف');
          }
        } catch (e) {
          throw Exception('غير قادر على معالجة الطلب: ${e.toString()}');
        }
      }

      // تحويل CartItem إلى OrderItem
      final orderItems = widget.cartItems
          .map((cartItem) => OrderItem.fromCartItem(cartItem))
          .toList();

      // إنشاء الطلب
      final order = Order(
        id: '', // سيتم تعيينه من Firestore
        userId: user.uid,
        items: orderItems,
        date: DateTime.now(),
        total: widget.totalAmount,
        status: status,
        paymentMethod: paymentMethod,
        shippingAddress: widget.shippingAddress,
        phoneNumber: widget.phoneNumber,
      );

      // حفظ الطلب في Firestore
      final docRef = await firestore.FirebaseFirestore.instance
          .collection('orders')
          .add(order.toMap());

      // تحديث معرف الطلب
      await docRef.update({'id': docRef.id});

      // خصم المنتجات من المخزون
      await _updateProductStock(widget.cartItems);

      // مسح السلة
      CartService.clear();

      // عرض رسالة نجاح
      if (mounted) {
        _showSuccessDialog(paymentMethod, docRef.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// دالة لخصم المنتجات من المخزون بعد إتمام الطلب
  Future<void> _updateProductStock(List<CartItem> cartItems) async {
    try {
      final db = firestore.FirebaseFirestore.instance;

      // معالجة كل منتج في السلة
      for (final cartItem in cartItems) {
        final productId = cartItem.product.id;
        final purchasedQuantity = cartItem.quantity;

        // الحصول على المنتج من Firestore
        final productDoc = await db.collection('products').doc(productId).get();

        if (!productDoc.exists) {
          print('⚠️ المنتج $productId غير موجود في قاعدة البيانات');
          continue;
        }

        final productData = productDoc.data()!;
        final currentStock =
            productData['stock'] ?? productData['stockQuantity'] ?? 0;

        // التحقق من توفر الكمية الكافية
        if (currentStock < purchasedQuantity) {
          print('⚠️ تحذير: المخزون غير كافٍ للمنتج ${cartItem.product.name}');
          print(
              '   المخزون الحالي: $currentStock، الكمية المطلوبة: $purchasedQuantity');
          // يمكن إضافة معالجة إضافية هنا (مثل إرسال إشعار للأدمن)
        }

        // حساب المخزون الجديد
        final newStock = (currentStock - purchasedQuantity)
            .clamp(0, double.infinity)
            .toInt();

        // تحديث المخزون في Firestore
        await db.collection('products').doc(productId).update({
          'stock': newStock,
          'stockQuantity': newStock, // للتوافق مع الحقول القديمة
          'isAvailable': newStock > 0, // تحديث حالة التوفر
          'inStock': newStock > 0, // للتوافق
          'updatedAt': firestore.FieldValue.serverTimestamp(),
        });

        print(
            '✅ تم تحديث مخزون ${cartItem.product.name}: $currentStock → $newStock');
      }

      print('🎉 تم تحديث المخزون بنجاح لجميع المنتجات');
    } catch (e) {
      print('❌ خطأ في تحديث المخزون: $e');
      // لا نرمي الخطأ لأننا لا نريد إيقاف عملية الطلب
      // يمكن إضافة معالجة إضافية هنا (مثل إرسال تنبيه للأدمن)
    }
  }

  void _showSuccessDialog(String paymentMethod, String orderId) {
    final isCardPayment = paymentMethod == 'credit_card';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: Text(isCardPayment ? 'تم الدفع بنجاح!' : 'تم تأكيد الطلب!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCardPayment
                  ? 'تم دفع ${widget.totalAmount.toStringAsFixed(0)} جنيه بنجاح'
                  : 'تم تأكيد طلبك. ستدفع ${widget.totalAmount.toStringAsFixed(0)} جنيه عند الاستلام',
            ),
            const SizedBox(height: 8),
            Text(
              'رقم الطلب: ${orderId.substring(0, 8)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'محاكاة: لا توجد معاملات مالية حقيقية',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الحوار
              Navigator.pop(context); // العودة للشاشة السابقة
              Navigator.pop(context); // العودة لشاشة الخروج
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
