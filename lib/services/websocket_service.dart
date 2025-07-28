import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:get/get.dart';
import '../config/api_config.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../controllers/chat_controller.dart';
import '../controllers/auth_controller.dart';
import 'api_service.dart';

class WebSocketService extends GetxService {
  static WebSocketService get instance => Get.find<WebSocketService>();
  
  io.Socket? _socket;
  final RxBool _isConnected = false.obs;
  final RxString _connectionStatus = 'Disconnected'.obs;
  final RxMap<String, bool> _typingUsers = <String, bool>{}.obs;
  
  bool get isConnected => _isConnected.value;
  String get connectionStatus => _connectionStatus.value;
  Map<String, bool> get typingUsers => _typingUsers;

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  @override
  void onClose() {
    _disconnect();
    super.onClose();
  }

  void _initializeSocket() {
    final apiService = ApiService();
    
    _socket = io.io(
      ApiConfig.websocketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setExtraHeaders({
            'Authorization': 'Bearer ${apiService._accessToken}',
          })
          .build(),
    );

    _setupEventListeners();
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      print('WebSocket connected');
      _isConnected.value = true;
      _connectionStatus.value = 'Connected';
      _joinUserRoom();
    });

    _socket!.onDisconnect((_) {
      print('WebSocket disconnected');
      _isConnected.value = false;
      _connectionStatus.value = 'Disconnected';
    });

    _socket!.onConnectError((error) {
      print('WebSocket connection error: $error');
      _connectionStatus.value = 'Connection Error';
    });

    _socket!.onReconnect((_) {
      print('WebSocket reconnected');
      _connectionStatus.value = 'Reconnected';
      _joinUserRoom();
    });

    // Message events
    _socket!.on(ApiConfig.wsNewMessage, _handleNewMessage);
    _socket!.on(ApiConfig.wsMessageRead, _handleMessageRead);
    
    // User status events
    _socket!.on(ApiConfig.wsUserOnline, _handleUserOnline);
    _socket!.on(ApiConfig.wsUserOffline, _handleUserOffline);
    
    // Typing events
    _socket!.on(ApiConfig.wsTyping, _handleTyping);
    _socket!.on(ApiConfig.wsStopTyping, _handleStopTyping);
  }

  void connect() {
    if (_socket?.connected != true) {
      _socket?.connect();
    }
  }

  void _disconnect() {
    if (_socket?.connected == true) {
      _socket?.disconnect();
    }
    _isConnected.value = false;
    _connectionStatus.value = 'Disconnected';
  }

  void _joinUserRoom() {
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    
    if (currentUser != null) {
      _socket?.emit(ApiConfig.wsJoinRoom, {
        'room': 'user_${currentUser.id}',
        'user_id': currentUser.id,
      });
    }
  }

  // Message handling
  void _handleNewMessage(dynamic data) {
    try {
      final messageData = data as Map<String, dynamic>;
      final message = MessageModel.fromJson(messageData);
      
      // Update chat controller with new message
      final chatController = Get.find<ChatController>();
      chatController.addNewMessage(message);
      
      // Show notification if app is in background
      _showMessageNotification(message);
    } catch (e) {
      print('Error handling new message: $e');
    }
  }

  void _handleMessageRead(dynamic data) {
    try {
      final readData = data as Map<String, dynamic>;
      final messageIds = List<String>.from(readData['message_ids']);
      final conversationId = readData['conversation_id'] as String;
      
      final chatController = Get.find<ChatController>();
      chatController.markMessagesAsRead(conversationId, messageIds);
    } catch (e) {
      print('Error handling message read: $e');
    }
  }

  // User status handling
  void _handleUserOnline(dynamic data) {
    try {
      final userData = data as Map<String, dynamic>;
      final userId = userData['user_id'] as String;
      
      final chatController = Get.find<ChatController>();
      chatController.updateUserOnlineStatus(userId, true);
    } catch (e) {
      print('Error handling user online: $e');
    }
  }

  void _handleUserOffline(dynamic data) {
    try {
      final userData = data as Map<String, dynamic>;
      final userId = userData['user_id'] as String;
      final lastSeen = DateTime.parse(userData['last_seen']);
      
      final chatController = Get.find<ChatController>();
      chatController.updateUserOnlineStatus(userId, false, lastSeen);
    } catch (e) {
      print('Error handling user offline: $e');
    }
  }

  // Typing indicators
  void _handleTyping(dynamic data) {
    try {
      final typingData = data as Map<String, dynamic>;
      final userId = typingData['user_id'] as String;
      final conversationId = typingData['conversation_id'] as String;
      
      _typingUsers['${conversationId}_$userId'] = true;
      
      final chatController = Get.find<ChatController>();
      chatController.setUserTyping(conversationId, userId, true);
    } catch (e) {
      print('Error handling typing: $e');
    }
  }

  void _handleStopTyping(dynamic data) {
    try {
      final typingData = data as Map<String, dynamic>;
      final userId = typingData['user_id'] as String;
      final conversationId = typingData['conversation_id'] as String;
      
      _typingUsers.remove('${conversationId}_$userId');
      
      final chatController = Get.find<ChatController>();
      chatController.setUserTyping(conversationId, userId, false);
    } catch (e) {
      print('Error handling stop typing: $e');
    }
  }

  // Send events
  void sendMessage(MessageModel message) {
    if (_socket?.connected == true) {
      _socket?.emit(ApiConfig.wsNewMessage, message.toJson());
    }
  }

  void markAsRead(String conversationId, List<String> messageIds) {
    if (_socket?.connected == true) {
      _socket?.emit(ApiConfig.wsMessageRead, {
        'conversation_id': conversationId,
        'message_ids': messageIds,
      });
    }
  }

  void joinConversation(String conversationId) {
    if (_socket?.connected == true) {
      _socket?.emit(ApiConfig.wsJoinRoom, {
        'room': 'conversation_$conversationId',
        'conversation_id': conversationId,
      });
    }
  }

  void leaveConversation(String conversationId) {
    if (_socket?.connected == true) {
      _socket?.emit(ApiConfig.wsLeaveRoom, {
        'room': 'conversation_$conversationId',
        'conversation_id': conversationId,
      });
    }
  }

  void startTyping(String conversationId) {
    if (_socket?.connected == true) {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;
      
      if (currentUser != null) {
        _socket?.emit(ApiConfig.wsTyping, {
          'conversation_id': conversationId,
          'user_id': currentUser.id,
        });
      }
    }
  }

  void stopTyping(String conversationId) {
    if (_socket?.connected == true) {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;
      
      if (currentUser != null) {
        _socket?.emit(ApiConfig.wsStopTyping, {
          'conversation_id': conversationId,
          'user_id': currentUser.id,
        });
      }
    }
  }

  void updateOnlineStatus(bool isOnline) {
    if (_socket?.connected == true) {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;
      
      if (currentUser != null) {
        _socket?.emit(isOnline ? ApiConfig.wsUserOnline : ApiConfig.wsUserOffline, {
          'user_id': currentUser.id,
          'last_seen': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  void _showMessageNotification(MessageModel message) {
    // This would integrate with your notification service
    // For now, we'll use GetX snackbar as a placeholder
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    
    if (message.senderId != currentUser?.id) {
      Get.snackbar(
        'New Message',
        message.content,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Connection management
  void reconnect() {
    _disconnect();
    Future.delayed(Duration(seconds: 1), () {
      _initializeSocket();
      connect();
    });
  }

  void updateAuthToken(String newToken) {
    if (_socket != null) {
      _socket!.io.options?['extraHeaders'] = {
        'Authorization': 'Bearer $newToken',
      };
      
      // Reconnect with new token
      reconnect();
    }
  }
}