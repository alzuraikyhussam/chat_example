class ApiConfig {
  // Base URLs - Update these with your actual API endpoints
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  static const String websocketUrl = 'wss://your-api-domain.com/ws';
  static const String fileUploadUrl = 'https://your-api-domain.com/api/v1/files';
  
  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';
  static const String searchUsers = '/user/search';
  
  // Chat endpoints
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/messages';
  static const String sendMessage = '/chat/send';
  static const String markAsRead = '/chat/mark-read';
  static const String deleteMessage = '/chat/delete';
  static const String editMessage = '/chat/edit';
  
  // File endpoints
  static const String uploadFile = '/files/upload';
  static const String downloadFile = '/files/download';
  static const String deleteFile = '/files/delete';
  
  // Settings
  static const String updateSettings = '/user/settings';
  static const String getSettings = '/user/settings';
  
  // Push notifications
  static const String registerDevice = '/notifications/register-device';
  static const String unregisterDevice = '/notifications/unregister-device';
  
  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  
  // WebSocket events
  static const String wsConnect = 'connect';
  static const String wsDisconnect = 'disconnect';
  static const String wsNewMessage = 'new_message';
  static const String wsMessageRead = 'message_read';
  static const String wsUserOnline = 'user_online';
  static const String wsUserOffline = 'user_offline';
  static const String wsTyping = 'typing';
  static const String wsStopTyping = 'stop_typing';
  static const String wsJoinRoom = 'join_room';
  static const String wsLeaveRoom = 'leave_room';
  
  // File upload limits
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx', 'txt', 'zip', 'rar'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}