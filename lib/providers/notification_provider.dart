// lib/providers/notification_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  // إعدادات الإشعارات
  bool _orderNotifications = true;
  bool _offerNotifications = true;
  bool _newProductNotifications = true;
  bool _cartReminderNotifications = true;
  bool _stockNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  
  // Getters
  bool get orderNotifications => _orderNotifications;
  bool get offerNotifications => _offerNotifications;
  bool get newProductNotifications => _newProductNotifications;
  bool get cartReminderNotifications => _cartReminderNotifications;
  bool get stockNotifications => _stockNotifications;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  // تهيئة الإعدادات
  Future<void> initialize() async {
    await _loadSettings();
    await _notificationService.initialize();
    await _subscribeToTopics();
  }

  // تحميل الإعدادات من SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _orderNotifications = prefs.getBool('order_notifications') ?? true;
    _offerNotifications = prefs.getBool('offer_notifications') ?? true;
    _newProductNotifications = prefs.getBool('new_product_notifications') ?? true;
    _cartReminderNotifications = prefs.getBool('cart_reminder_notifications') ?? true;
    _stockNotifications = prefs.getBool('stock_notifications') ?? true;
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    
    notifyListeners();
  }

  // حفظ الإعدادات في SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('order_notifications', _orderNotifications);
    await prefs.setBool('offer_notifications', _offerNotifications);
    await prefs.setBool('new_product_notifications', _newProductNotifications);
    await prefs.setBool('cart_reminder_notifications', _cartReminderNotifications);
    await prefs.setBool('stock_notifications', _stockNotifications);
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
  }

  // الاشتراك في المواضيع حسب الإعدادات
  Future<void> _subscribeToTopics() async {
    if (_orderNotifications) {
      await _notificationService.subscribeToTopic('orders');
    } else {
      await _notificationService.unsubscribeFromTopic('orders');
    }

    if (_offerNotifications) {
      await _notificationService.subscribeToTopic('offers');
    } else {
      await _notificationService.unsubscribeFromTopic('offers');
    }

    if (_newProductNotifications) {
      await _notificationService.subscribeToTopic('new_products');
    } else {
      await _notificationService.unsubscribeFromTopic('new_products');
    }

    if (_stockNotifications) {
      await _notificationService.subscribeToTopic('stock_updates');
    } else {
      await _notificationService.unsubscribeFromTopic('stock_updates');
    }
  }

  // تبديل إشعارات الطلبات
  Future<void> toggleOrderNotifications(bool value) async {
    _orderNotifications = value;
    await _saveSettings();
    await _subscribeToTopics();
    notifyListeners();
  }

  // تبديل إشعارات العروض
  Future<void> toggleOfferNotifications(bool value) async {
    _offerNotifications = value;
    await _saveSettings();
    await _subscribeToTopics();
    notifyListeners();
  }

  // تبديل إشعارات المنتجات الجديدة
  Future<void> toggleNewProductNotifications(bool value) async {
    _newProductNotifications = value;
    await _saveSettings();
    await _subscribeToTopics();
    notifyListeners();
  }

  // تبديل تذكير السلة
  Future<void> toggleCartReminderNotifications(bool value) async {
    _cartReminderNotifications = value;
    await _saveSettings();
    notifyListeners();
  }

  // تبديل إشعارات المخزون
  Future<void> toggleStockNotifications(bool value) async {
    _stockNotifications = value;
    await _saveSettings();
    await _subscribeToTopics();
    notifyListeners();
  }

  // تبديل الصوت
  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  // تبديل الاهتزاز
  Future<void> toggleVibration(bool value) async {
    _vibrationEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  // إرسال إشعار طلب
  Future<void> sendOrderNotification({
    required String orderId,
    required String status,
  }) async {
    if (_orderNotifications) {
      await _notificationService.showOrderNotification(
        orderId: orderId,
        status: status,
      );
    }
  }

  // إرسال إشعار عرض
  Future<void> sendOfferNotification({
    required String title,
    required String description,
    String? productId,
  }) async {
    if (_offerNotifications) {
      await _notificationService.showOfferNotification(
        title: title,
        description: description,
        productId: productId,
      );
    }
  }

  // إرسال إشعار منتج جديد
  Future<void> sendNewProductNotification({
    required String productName,
    required String productId,
  }) async {
    if (_newProductNotifications) {
      await _notificationService.showNewProductNotification(
        productName: productName,
        productId: productId,
      );
    }
  }

  // إرسال تذكير السلة
  Future<void> sendCartReminder() async {
    if (_cartReminderNotifications) {
      await _notificationService.showCartReminderNotification();
    }
  }

  // إرسال إشعار المخزون
  Future<void> sendStockNotification({
    required String productName,
    required String productId,
  }) async {
    if (_stockNotifications) {
      await _notificationService.showStockNotification(
        productName: productName,
        productId: productId,
      );
    }
  }

  // اختبار الإشعارات
  Future<void> testNotification() async {
    await _notificationService.showOfferNotification(
      title: 'اختبار الإشعارات',
      description: 'هذا إشعار تجريبي للتأكد من عمل النظام',
    );
  }

  // الحصول على FCM Token
  Future<String?> getFCMToken() async {
    return await _notificationService.getFCMToken();
  }

  // إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }
}
