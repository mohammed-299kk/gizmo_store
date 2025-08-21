// lib/screens/coupons/coupons_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/coupon_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/coupon.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _couponCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final couponProvider =
          Provider.of<CouponProvider>(context, listen: false);
      couponProvider.loadAvailableCoupons();
      couponProvider.loadUserCoupons();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _couponCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('الكوبونات والعروض'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'الكوبونات المتاحة'),
            Tab(text: 'كوبوناتي'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildCouponCodeInput(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableCoupons(),
                _buildUserCoupons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCodeInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2A2A2A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لديك كود كوبون؟',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponCodeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'أدخل كود الكوبون',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 12),
              Consumer2<CouponProvider, CartProvider>(
                builder: (context, couponProvider, cartProvider, child) {
                  return ElevatedButton(
                    onPressed: couponProvider.isLoading
                        ? null
                        : () => _applyCouponCode(couponProvider, cartProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: couponProvider.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('تطبيق'),
                  );
                },
              ),
            ],
          ),
          Consumer<CouponProvider>(
            builder: (context, couponProvider, child) {
              if (couponProvider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    couponProvider.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                );
              }
              if (couponProvider.hasCouponApplied) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'تم تطبيق الكوبون: ${couponProvider.appliedCoupon!.code}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          couponProvider.removeCoupon();
                          _couponCodeController.clear();
                        },
                        child: const Text(
                          'إزالة',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCoupons() {
    return Consumer<CouponProvider>(
      builder: (context, couponProvider, child) {
        if (couponProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB71C1C),
            ),
          );
        }

        if (couponProvider.availableCoupons.isEmpty) {
          return _buildEmptyState('لا توجد كوبونات متاحة حالياً');
        }

        return RefreshIndicator(
          onRefresh: () => couponProvider.loadAvailableCoupons(),
          color: const Color(0xFFB71C1C),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: couponProvider.availableCoupons.length,
            itemBuilder: (context, index) {
              final coupon = couponProvider.availableCoupons[index];
              return _buildCouponCard(coupon, isUserCoupon: false);
            },
          ),
        );
      },
    );
  }

  Widget _buildUserCoupons() {
    return Consumer<CouponProvider>(
      builder: (context, couponProvider, child) {
        if (couponProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB71C1C),
            ),
          );
        }

        if (couponProvider.userCoupons.isEmpty) {
          return _buildEmptyState('لا توجد كوبونات في محفظتك');
        }

        return RefreshIndicator(
          onRefresh: () => couponProvider.loadUserCoupons(),
          color: const Color(0xFFB71C1C),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: couponProvider.userCoupons.length,
            itemBuilder: (context, index) {
              final coupon = couponProvider.userCoupons[index];
              return _buildCouponCard(coupon, isUserCoupon: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(coupon, {required bool isUserCoupon}) {
    final isExpired = coupon.isExpired;
    final isValid = coupon.isValid;

    return Card(
      color: const Color(0xFF2A2A2A),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isValid ? const Color(0xFFB71C1C) : Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coupon.title,
                            style: TextStyle(
                              color: isValid ? Colors.white : Colors.grey[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coupon.typeText,
                            style: TextStyle(
                              color: isValid
                                  ? const Color(0xFFB71C1C)
                                  : Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(coupon.statusColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        coupon.statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  coupon.description,
                  style: TextStyle(
                    color: isValid ? Colors.grey[300] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),

                // معلومات إضافية
                if (coupon.minOrderAmount > 0) ...[
                  _buildCouponInfo(
                    'الحد الأدنى للطلب',
                    '${coupon.minOrderAmount.toStringAsFixed(0)} جنيه',
                    isValid,
                  ),
                ],
                if (coupon.maxDiscount != double.infinity) ...[
                  _buildCouponInfo(
                    'الحد الأقصى للخصم',
                    '${coupon.maxDiscount.toStringAsFixed(0)} جنيه',
                    isValid,
                  ),
                ],
                _buildCouponInfo(
                  'صالح حتى',
                  _formatDate(coupon.endDate),
                  isValid,
                ),

                const SizedBox(height: 16),

                // كود الكوبون وأزرار العمل
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[700]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                coupon.code,
                                style: TextStyle(
                                  color:
                                      isValid ? Colors.white : Colors.grey[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: coupon.code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ الكود'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (isValid) ...[
                      Consumer2<CouponProvider, CartProvider>(
                        builder:
                            (context, couponProvider, cartProvider, child) {
                          return ElevatedButton(
                            onPressed: () => _applyCoupon(
                                coupon, couponProvider, cartProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB71C1C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('استخدم'),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // علامة انتهاء الصلاحية
          if (!isValid)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  isExpired ? 'منتهي الصلاحية' : 'غير متاح',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCouponInfo(String label, String value, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isValid ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isValid ? Colors.white : Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _applyCouponCode(
      CouponProvider couponProvider, CartProvider cartProvider) {
    final code = _couponCodeController.text.trim();
    if (code.isEmpty) return;

    couponProvider.applyCouponByCode(code, cartProvider.items).then((success) {
      if (success && mounted) {
        _couponCodeController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تطبيق الكوبون بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _applyCoupon(
      coupon, CouponProvider couponProvider, CartProvider cartProvider) {
    couponProvider.applyCoupon(coupon, cartProvider.items).then((success) {
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تطبيق الكوبون بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
