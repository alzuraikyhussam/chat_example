class NotificationConfig {
  // Notification types for local LAN chat app
  static const String messageNotification = 'message';
  static const String connectionNotification = 'connection';
  static const String systemNotification = 'system';
  
  // Notification settings
  static const bool enableSystemNotifications = true;
  static const bool enableInAppNotifications = true;
  static const bool enableSoundNotifications = true;
  static const bool enableVibrationNotifications = true;
  
  // Notification channels
  static const String messagesChannelId = 'messages';
  static const String messagesChannelName = 'Messages';
  static const String messagesChannelDescription = 'New message notifications';
  
  static const String systemChannelId = 'system';
  static const String systemChannelName = 'System';
  static const String systemChannelDescription = 'System notifications (connection status, etc.)';
  
  // Notification priorities
  static const int highPriority = 5;
  static const int normalPriority = 3;
  static const int lowPriority = 1;
  
  // Notification options for different scenarios
  static const Map<String, Map<String, dynamic>> notificationTypes = {
    'new_message': {
      'title': 'New Message',
      'priority': highPriority,
      'sound': true,
      'vibration': true,
      'channel': messagesChannelId,
    },
    'user_online': {
      'title': 'User Online',
      'priority': normalPriority,
      'sound': false,
      'vibration': false,
      'channel': systemChannelId,
    },
    'connection_lost': {
      'title': 'Connection Lost',
      'priority': highPriority,
      'sound': true,
      'vibration': false,
      'channel': systemChannelId,
    },
    'connection_restored': {
      'title': 'Connection Restored',
      'priority': normalPriority,
      'sound': true,
      'vibration': false,
      'channel': systemChannelId,
    },
  };
  
  // Get notification configuration for a specific type
  static Map<String, dynamic>? getNotificationConfig(String type) {
    return notificationTypes[type];
  }
  
  // Check if notifications should be shown based on app state
  static bool shouldShowNotification(String type) {
    if (!enableSystemNotifications) return false;
    
    // Add logic here to check app state, user preferences, etc.
    // For example, don't show message notifications if app is in foreground
    
    return true;
  }
  
  // Format notification title and body
  static Map<String, String> formatNotification({
    required String type,
    required String senderName,
    required String message,
  }) {
    switch (type) {
      case 'new_message':
        return {
          'title': senderName,
          'body': message,
        };
      case 'user_online':
        return {
          'title': '$senderName is online',
          'body': '',
        };
      case 'connection_lost':
        return {
          'title': 'Connection Lost',
          'body': 'Unable to connect to chat server',
        };
      case 'connection_restored':
        return {
          'title': 'Connected',
          'body': 'Connection to chat server restored',
        };
      default:
        return {
          'title': 'Chat App',
          'body': message,
        };
    }
  }
}