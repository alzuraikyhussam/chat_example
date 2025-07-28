import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class LocalNotificationService extends GetxService {
  static LocalNotificationService get instance => Get.find<LocalNotificationService>();
  
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  final RxBool _notificationsEnabled = true.obs;
  final RxBool _soundEnabled = true.obs;
  final RxBool _vibrationEnabled = true.obs;
  
  bool get notificationsEnabled => _notificationsEnabled.value;
  bool get soundEnabled => _soundEnabled.value;
  bool get vibrationEnabled => _vibrationEnabled.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
    await _loadSettings();
  }

  Future<void> _initializeNotifications() async {
    // Initialize local notifications
    await _initializeLocalNotifications();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const LinuxInitializationSettings linuxSettings = 
        LinuxInitializationSettings(
          defaultActionName: 'Open notification',
        );

    const InitializationSettings initializationSettings = 
        InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
          linux: linuxSettings,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel messageChannel = AndroidNotificationChannel(
      'messages',
      'Messages',
      description: 'Notifications for new messages',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
      'calls',
      'Calls',
      description: 'Notifications for incoming calls',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('ringtone'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(messageChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(callChannel);
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'messages',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'messages' ? 'Messages' : 'Calls',
      channelDescription: channelId == 'messages' 
          ? 'Notifications for new messages'
          : 'Notifications for incoming calls',
      importance: Importance.high,
      priority: Priority.high,
      sound: _soundEnabled.value 
          ? const RawResourceAndroidNotificationSound('notification')
          : null,
      enableVibration: _vibrationEnabled.value,
      playSound: _soundEnabled.value,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const linuxDetails = LinuxNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _navigateToChat(data);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  // Navigate to chat
  void _navigateToChat(Map<String, dynamic> data) {
    final conversationId = data['conversation_id'];
    if (conversationId != null) {
      Get.toNamed(AppRoutes.chat, arguments: {'conversation_id': conversationId});
    }
  }

  // Show message notification
  Future<void> showMessageNotification({
    required String senderName,
    required String message,
    required String conversationId,
    String? avatarUrl,
  }) async {
    if (!_notificationsEnabled.value) return;

    await _showLocalNotification(
      title: senderName,
      body: message,
      payload: jsonEncode({
        'type': 'message',
        'conversation_id': conversationId,
        'sender_name': senderName,
      }),
    );
  }

  // Show call notification (for future use)
  Future<void> showCallNotification({
    required String callerName,
    required String callId,
    required bool isVideoCall,
  }) async {
    if (!_notificationsEnabled.value) return;

    await _showLocalNotification(
      title: isVideoCall ? 'Incoming Video Call' : 'Incoming Call',
      body: 'From $callerName',
      channelId: 'calls',
      payload: jsonEncode({
        'type': 'call',
        'call_id': callId,
        'caller_name': callerName,
        'is_video': isVideoCall,
      }),
    );
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Clear specific notification
  Future<void> clearNotification(int notificationId) async {
    await _localNotifications.cancel(notificationId);
  }

  // Settings management
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled.value = prefs.getBool('notifications_enabled') ?? true;
      _soundEnabled.value = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled.value = prefs.getBool('vibration_enabled') ?? true;
    } catch (e) {
      print('Error loading notification settings: $e');
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      _notificationsEnabled.value = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', enabled);
      
      if (!enabled) {
        await clearAllNotifications();
      }
    } catch (e) {
      print('Error setting notifications enabled: $e');
    }
  }

  Future<void> setSoundEnabled(bool enabled) async {
    try {
      _soundEnabled.value = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_enabled', enabled);
    } catch (e) {
      print('Error setting sound enabled: $e');
    }
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    try {
      _vibrationEnabled.value = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('vibration_enabled', enabled);
    } catch (e) {
      print('Error setting vibration enabled: $e');
    }
  }

  // Badge management (desktop doesn't typically use badges)
  Future<void> updateBadgeCount(int count) async {
    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(badge: true);
    }
    // For desktop platforms, you might want to update the taskbar/dock icon
  }

  Future<void> clearBadge() async {
    await updateBadgeCount(0);
  }

  // Test notification
  Future<void> showTestNotification() async {
    await _showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from ChatApp',
    );
  }

  // Get notification permission status
  Future<bool> hasNotificationPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // Assume permissions are granted for other platforms
  }

  // Request notification permission
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestPermission() ?? false;
    }
    return true; // Assume permissions are granted for other platforms
  }

  // Schedule notification (for reminders, etc.)
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await _localNotifications.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled',
          'Scheduled Notifications',
          channelDescription: 'Scheduled notifications',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Cancel scheduled notification
  Future<void> cancelScheduledNotification(int notificationId) async {
    await _localNotifications.cancel(notificationId);
  }

  // Show system notification when app receives message via WebSocket
  Future<void> showIncomingMessageNotification(MessageModel message, String senderName) async {
    if (!_notificationsEnabled.value) return;
    
    // Don't show notification for messages from current user
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    
    if (message.senderId != currentUser?.id) {
      await showMessageNotification(
        senderName: senderName,
        message: message.content,
        conversationId: message.receiverId, // or conversation ID if available
      );
    }
  }
}