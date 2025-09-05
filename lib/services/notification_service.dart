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

  // Initialize notifications
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();
  }

  // Initialize local notifications
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

  // Initialize Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Request notification permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ Notification permission granted');
    } else {
      debugPrint('❌ Notification permission denied');
    }

    // Get FCM Token
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notifications when opening app from notification
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // Handle foreground notifications
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground notification: ${message.notification?.title}');
    
    // Show local notification
    _showLocalNotification(
      title: message.notification?.title ?? 'Gizmo Store',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.notification?.title}');
    // Navigation logic can be added here
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    // Navigation logic can be added here
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'gizmo_store_channel',
      'Gizmo Store Notifications',
      channelDescription: 'Gizmo Store Notifications',
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

  // New order notification
  Future<void> showOrderNotification({
    required String orderId,
    required String status,
  }) async {
    String title = 'Order Update';
    String body = '';

    switch (status) {
      case 'preparing':
        body = 'Your order #$orderId is being prepared';
        break;
      case 'shipping':
        body = 'Your order #$orderId is on its way to you';
        break;
      case 'delivered':
        body = 'Your order #$orderId has been delivered successfully';
        break;
      default:
        body = 'Update on your order #$orderId';
    }

    await _showLocalNotification(
      title: title,
      body: body,
      payload: 'order:$orderId',
    );
  }

  // Special offer notification
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

  // New product notification
  Future<void> showNewProductNotification({
    required String productName,
    required String productId,
  }) async {
    await _showLocalNotification(
      title: 'New Product!',
      body: '$productName has been added to the store',
      payload: 'product:$productId',
    );
  }

  // Cart reminder notification
  Future<void> showCartReminderNotification() async {
    await _showLocalNotification(
      title: 'Don\'t forget your cart!',
      body: 'You have items in your cart waiting to be purchased',
      payload: 'cart_reminder',
    );
  }

  // Out of stock notification
  Future<void> showStockNotification({
    required String productName,
    required String productId,
  }) async {
    await _showLocalNotification(
      title: 'Product now available!',
      body: '$productName is now available in stock',
      payload: 'product:$productId',
    );
  }

  // Schedule notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Scheduling can be implemented here using timezone package
    // For now we'll leave it as placeholder
    debugPrint('Notification scheduled: $title at $scheduledTime');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Get FCM Token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}
