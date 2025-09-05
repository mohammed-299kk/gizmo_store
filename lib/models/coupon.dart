// lib/models/coupon.dart
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

enum CouponType {
  percentage,  // نسبة مئوية
  fixed,       // مبلغ ثابت
  freeShipping, // شحن مجاني
}

enum CouponStatus {
  active,      // نشط
  expired,     // منتهي الصلاحية
  used,        // مستخدم
  disabled,    // معطل
}

class Coupon {
  /// Safe conversion to double with error handling
  static double _safeToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }
  
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType type;
  final double value;
  final double minOrderAmount;
  final double maxDiscount;
  final DateTime startDate;
  final DateTime endDate;
  final int usageLimit;
  final int usedCount;
  final List<String> applicableCategories;
  final List<String> applicableProducts;
  final List<String> excludedProducts;
  final bool isFirstTimeOnly;
  final CouponStatus status;

  Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.minOrderAmount = 0,
    this.maxDiscount = double.infinity,
    required this.startDate,
    required this.endDate,
    this.usageLimit = -1, // -1 = unlimited
    this.usedCount = 0,
    this.applicableCategories = const [],
    this.applicableProducts = const [],
    this.excludedProducts = const [],
    this.isFirstTimeOnly = false,
    this.status = CouponStatus.active,
  });

  // تحويل إلى Map للحفظ في Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'type': type.name,
      'value': value,
      'minOrderAmount': minOrderAmount,
      'maxDiscount': maxDiscount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'applicableCategories': applicableCategories,
      'applicableProducts': applicableProducts,
      'excludedProducts': excludedProducts,
      'isFirstTimeOnly': isFirstTimeOnly,
      'status': status.name,
    };
  }

  // إنشاء من Map
  factory Coupon.fromMap(Map<String, dynamic> map, String id) {
    return Coupon(
      id: id,
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: CouponType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => CouponType.percentage,
      ),
      value: _safeToDouble(map['value']),
      minOrderAmount: _safeToDouble(map['minOrderAmount']),
      maxDiscount: map['maxDiscount'] != null 
          ? _safeToDouble(map['maxDiscount'])
          : double.infinity,
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(map['endDate'] ?? DateTime.now().add(const Duration(days: 30)).toIso8601String()),
      usageLimit: map['usageLimit'] ?? -1,
      usedCount: map['usedCount'] ?? 0,
      applicableCategories: List<String>.from(map['applicableCategories'] ?? []),
      applicableProducts: List<String>.from(map['applicableProducts'] ?? []),
      excludedProducts: List<String>.from(map['excludedProducts'] ?? []),
      isFirstTimeOnly: map['isFirstTimeOnly'] ?? false,
      status: CouponStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => CouponStatus.active,
      ),
    );
  }

  // التحقق من صحة الكوبون
  bool get isValid {
    final now = DateTime.now();
    return status == CouponStatus.active &&
           now.isAfter(startDate) &&
           now.isBefore(endDate) &&
           (usageLimit == -1 || usedCount < usageLimit);
  }

  // التحقق من انتهاء الصلاحية
  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  // التحقق من استنفاد الاستخدامات
  bool get isUsedUp {
    return usageLimit != -1 && usedCount >= usageLimit;
  }

  // الحصول على نص نوع الكوبون
  String getTypeText(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (type) {
      case CouponType.percentage:
        return localizations.couponTypePercentage(value.toInt());
      case CouponType.fixed:
        return localizations.couponTypeFixed(value.toStringAsFixed(0));
      case CouponType.freeShipping:
        return localizations.couponTypeFreeShipping;
    }
  }

  // الحصول على نص الحالة
  String getStatusText(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (status) {
      case CouponStatus.active:
        return localizations.couponStatusActive;
      case CouponStatus.expired:
        return localizations.couponStatusExpired;
      case CouponStatus.used:
        return localizations.couponStatusUsed;
      case CouponStatus.disabled:
        return localizations.couponStatusDisabled;
    }
  }

  // الحصول على لون الحالة
  int get statusColor {
    switch (status) {
      case CouponStatus.active:
        return 0xFF4CAF50; // أخضر
      case CouponStatus.expired:
        return 0xFFF44336; // أحمر
      case CouponStatus.used:
        return 0xFF9E9E9E; // رمادي
      case CouponStatus.disabled:
        return 0xFF795548; // بني
    }
  }
}
