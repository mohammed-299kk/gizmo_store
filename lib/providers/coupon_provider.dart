// lib/providers/coupon_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/coupon.dart';
import '../models/cart_item.dart';

class CouponProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Coupon> _availableCoupons = [];
  List<Coupon> _userCoupons = [];
  Coupon? _appliedCoupon;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Coupon> get availableCoupons => [..._availableCoupons];
  List<Coupon> get userCoupons => [..._userCoupons];
  Coupon? get appliedCoupon => _appliedCoupon;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCouponApplied => _appliedCoupon != null;

  // تحميل الكوبونات المتاحة
  Future<void> loadAvailableCoupons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // إنشاء كوبونات تجريبية إذا لم تكن موجودة
      await createSampleCoupons();

      final snapshot = await _firestore
          .collection('coupons')
          .where('status', isEqualTo: 'active')
          .get();

      _availableCoupons = snapshot.docs
          .map((doc) => Coupon.fromMap(doc.data(), doc.id))
          .where((coupon) => coupon.isValid)
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل الكوبونات: $e';
      notifyListeners();
    }
  }

  // تحميل كوبونات المستخدم
  Future<void> loadUserCoupons() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coupons')
          .get();

      _userCoupons = snapshot.docs
          .map((doc) => Coupon.fromMap(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل كوبوناتك: $e';
      notifyListeners();
    }
  }

  // تطبيق كوبون بالكود
  Future<bool> applyCouponByCode(String code, List<CartItem> cartItems) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('coupons')
          .where('code', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        _errorMessage = 'كود الكوبون غير صحيح';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final coupon =
          Coupon.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);

      return await _applyCoupon(coupon, cartItems);
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'خطأ في تطبيق الكوبون: $e';
      notifyListeners();
      return false;
    }
  }

  // تطبيق كوبون
  Future<bool> applyCoupon(Coupon coupon, List<CartItem> cartItems) async {
    return await _applyCoupon(coupon, cartItems);
  }

  Future<bool> _applyCoupon(Coupon coupon, List<CartItem> cartItems) async {
    // التحقق من صحة الكوبون
    if (!coupon.isValid) {
      _errorMessage = 'الكوبون غير صالح أو منتهي الصلاحية';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // حساب قيمة الطلب
    final orderAmount = cartItems.fold<double>(
      0,
      (total, item) => total + item.totalPrice,
    );

    // التحقق من الحد الأدنى للطلب
    if (orderAmount < coupon.minOrderAmount) {
      _errorMessage =
          'الحد الأدنى للطلب ${coupon.minOrderAmount.toStringAsFixed(0)} جنيه';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _appliedCoupon = coupon;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  // إزالة الكوبون المطبق
  void removeCoupon() {
    _appliedCoupon = null;
    _errorMessage = null;
    notifyListeners();
  }

  // حساب قيمة الخصم للطلب الحالي
  double calculateDiscount(List<CartItem> cartItems) {
    if (_appliedCoupon == null) return 0;

    final orderAmount = cartItems.fold<double>(
      0,
      (total, item) => total + item.totalPrice,
    );

    switch (_appliedCoupon!.type) {
      case CouponType.percentage:
        return orderAmount * (_appliedCoupon!.value / 100);
      case CouponType.fixed:
        return _appliedCoupon!.value;
      case CouponType.freeShipping:
        return 0; // يتم التعامل مع هذا في منطق الشحن
    }
  }

  // التحقق من الشحن المجاني
  bool isFreeShippingApplied() {
    return _appliedCoupon?.type == CouponType.freeShipping;
  }

  // إنشاء كوبونات تجريبية
  Future<void> createSampleCoupons() async {
    final sampleCoupons = [
      Coupon(
        id: 'welcome10',
        code: 'WELCOME10',
        title: 'خصم ترحيبي',
        description: 'خصم 10% للمستخدمين الجدد',
        type: CouponType.percentage,
        value: 10,
        minOrderAmount: 100,
        maxDiscount: 50,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isFirstTimeOnly: true,
      ),
      Coupon(
        id: 'save50',
        code: 'SAVE50',
        title: 'وفر 50 جنيه',
        description: 'خصم 50 جنيه على الطلبات أكثر من 500 جنيه',
        type: CouponType.fixed,
        value: 50,
        minOrderAmount: 500,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 15)),
      ),
      Coupon(
        id: 'freeship',
        code: 'FREESHIP',
        title: 'شحن مجاني',
        description: 'شحن مجاني على جميع الطلبات',
        type: CouponType.freeShipping,
        value: 0,
        minOrderAmount: 200,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      ),
    ];

    for (var coupon in sampleCoupons) {
      try {
        final doc = await _firestore.collection('coupons').doc(coupon.id).get();

        if (!doc.exists) {
          await _firestore
              .collection('coupons')
              .doc(coupon.id)
              .set(coupon.toMap());
        }
      } catch (e) {
        debugPrint('خطأ في إنشاء الكوبون ${coupon.code}: $e');
      }
    }
  }

  // مسح الأخطاء
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // إعادة تعيين الحالة
  void reset() {
    _appliedCoupon = null;
    _errorMessage = null;
    notifyListeners();
  }
}
