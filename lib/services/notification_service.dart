// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // تهيئة الإشعارات
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();
  }

  // تهيئة الإشعارات المحلية
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // تهيئة Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // طلب الإذن للإشعارات
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ تم منح إذن الإشعارات');
    } else {
      debugPrint('❌ تم رفض إذن الإشعارات');
    }

    // الحصول على FCM Token
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // الاستماع للإشعارات في المقدمة
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // الاستماع للإشعارات عند النقر عليها
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // التعامل مع الإشعارات عند فتح التطبيق من إشعار
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // التعامل مع الإشعارات في المقدمة
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('تم استلام إشعار في المقدمة: ${message.notification?.title}');
    
    // عرض الإشعار المحلي
    _showLocalNotification(
      title: message.notification?.title ?? 'Gizmo Store',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  // التعامل مع النقر على الإشعار
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('تم النقر على إشعار: ${message.notification?.title}');
    // يمكن إضافة منطق التنقل هنا
  }

  // التعامل مع النقر على الإشعار المحلي
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('تم النقر على إشعار محلي: ${response.payload}');
    // يمكن إضافة منطق التنقل هنا
  }

  // عرض إشعار محلي
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'gizmo_store_channel',
      'Gizmo Store Notifications',
      channelDescription: 'إشعارات متجر Gizmo Store',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // إشعار طلب جديد
  Future<void> showOrderNotification({
    required String orderId,
    required String status,
  }) async {
    String title = 'تحديث الطلب';
    String body = '';

    switch (status) {
      case 'قيد التحضير':
        body = 'طلبك #$orderId قيد التحضير';
        break;
      case 'قيد الشحن':
        body = 'طلبك #$orderId في الطريق إليك';
        break;
      case 'تم التوصيل':
        body = 'تم توصيل طلبك #$orderId بنجاح';
        break;
      default:
        body = 'تحديث على طلبك #$orderId';
    }

    await _showLocalNotification(
      title: title,
      body: body,
      payload: 'order:$orderId',
    );
  }

  // إشعار عرض خاص
  Future<void> showOfferNotification({
    required String title,
    required String description,
    String? productId,
  }) async {
    await _showLocalNotification(
      title: title,
      body: description,
      payload: productId != null ? 'product:$productId' : null,
    );
  }

  // إشعار منتج جديد
  Future<void> showNewProductNotification({
    required String productName,
    required String productId,
  }) async {
    await _showLocalNotification(
      title: 'منتج جديد!',
      body: 'تم إضافة $productName إلى المتجر',
      payload: 'product:$productId',
    );
  }

  // إشعار تذكير السلة
  Future<void> showCartReminderNotification() async {
    await _showLocalNotification(
      title: 'لا تنس سلة التسوق!',
      body: 'لديك منتجات في السلة في انتظار الشراء',
      payload: 'cart_reminder',
    );
  }

  // إشعار نفاد المخزون
  Future<void> showStockNotification({
    required String productName,
    required String productId,
  }) async {
    await _showLocalNotification(
      title: 'المنتج متوفر الآن!',
      body: '$productName أصبح متوفراً في المخزون',
      payload: 'product:$productId',
    );
  }

  // جدولة إشعار
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // يمكن تنفيذ الجدولة هنا باستخدام timezone package
    // للآن سنتركه كـ placeholder
    debugPrint('تم جدولة إشعار: $title في $scheduledTime');
  }

  // إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // إلغاء إشعار محدد
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // الحصول على FCM Token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // الاشتراك في موضوع
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('تم الاشتراك في موضوع: $topic');
  }

  // إلغاء الاشتراك في موضوع
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('تم إلغاء الاشتراك في موضوع: $topic');
  }
}
