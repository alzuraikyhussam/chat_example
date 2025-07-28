import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class LocalStorageService extends GetxService {
  static LocalStorageService get instance => Get.find<LocalStorageService>();
  
  late Box<UserModel> _usersBox;
  late Box<MessageModel> _messagesBox;
  late Box<Conversation> _conversationsBox;
  late Box<Map<String, dynamic>> _settingsBox;
  late Box<String> _cacheBox;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MessageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(MessageTypeAdapter());
    }

    // Open boxes
    _usersBox = await Hive.openBox<UserModel>('users');
    _messagesBox = await Hive.openBox<MessageModel>('messages');
    _conversationsBox = await Hive.openBox<Conversation>('conversations');
    _settingsBox = await Hive.openBox<Map<String, dynamic>>('settings');
    _cacheBox = await Hive.openBox<String>('cache');
  }

  // User storage
  Future<void> saveUser(UserModel user) async {
    await _usersBox.put(user.id, user);
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final Map<String, UserModel> userMap = {
      for (var user in users) user.id: user
    };
    await _usersBox.putAll(userMap);
  }

  UserModel? getUser(String userId) {
    return _usersBox.get(userId);
  }

  List<UserModel> getAllUsers() {
    return _usersBox.values.toList();
  }

  Future<void> deleteUser(String userId) async {
    await _usersBox.delete(userId);
  }

  // Message storage
  Future<void> saveMessage(MessageModel message) async {
    await _messagesBox.put(message.id, message);
  }

  Future<void> saveMessages(List<MessageModel> messages) async {
    final Map<String, MessageModel> messageMap = {
      for (var message in messages) message.id: message
    };
    await _messagesBox.putAll(messageMap);
  }

  MessageModel? getMessage(String messageId) {
    return _messagesBox.get(messageId);
  }

  List<MessageModel> getMessagesForConversation(String conversationId) {
    return _messagesBox.values
        .where((message) => 
            message.senderId == conversationId || 
            message.receiverId == conversationId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  List<MessageModel> getAllMessages() {
    return _messagesBox.values.toList();
  }

  Future<void> deleteMessage(String messageId) async {
    await _messagesBox.delete(messageId);
  }

  Future<void> deleteMessagesForConversation(String conversationId) async {
    final messagesToDelete = _messagesBox.values
        .where((message) => 
            message.senderId == conversationId || 
            message.receiverId == conversationId)
        .map((message) => message.id)
        .toList();
    
    await _messagesBox.deleteAll(messagesToDelete);
  }

  // Conversation storage
  Future<void> saveConversation(Conversation conversation) async {
    await _conversationsBox.put(conversation.id, conversation);
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    final Map<String, Conversation> conversationMap = {
      for (var conversation in conversations) conversation.id: conversation
    };
    await _conversationsBox.putAll(conversationMap);
  }

  Conversation? getConversation(String conversationId) {
    return _conversationsBox.get(conversationId);
  }

  List<Conversation> getAllConversations() {
    return _conversationsBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> deleteConversation(String conversationId) async {
    await _conversationsBox.delete(conversationId);
    await deleteMessagesForConversation(conversationId);
  }

  // Settings storage
  Future<void> saveSetting(String key, Map<String, dynamic> value) async {
    await _settingsBox.put(key, value);
  }

  Map<String, dynamic>? getSetting(String key) {
    return _settingsBox.get(key);
  }

  Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Cache storage
  Future<void> saveToCache(String key, String value) async {
    await _cacheBox.put(key, value);
  }

  String? getFromCache(String key) {
    return _cacheBox.get(key);
  }

  Future<void> deleteFromCache(String key) async {
    await _cacheBox.delete(key);
  }

  // Utility methods
  Future<void> clearAllData() async {
    await _usersBox.clear();
    await _messagesBox.clear();
    await _conversationsBox.clear();
    await _settingsBox.clear();
    await _cacheBox.clear();
  }

  Future<void> clearUserData() async {
    await _usersBox.clear();
    await _messagesBox.clear();
    await _conversationsBox.clear();
  }

  // Sync methods for offline support
  List<MessageModel> getPendingMessages() {
    return _messagesBox.values
        .where((message) => message.id.startsWith('pending_'))
        .toList();
  }

  Future<void> markMessageAsSynced(String pendingId, String actualId) async {
    final message = _messagesBox.get(pendingId);
    if (message != null) {
      await _messagesBox.delete(pendingId);
      final syncedMessage = message.copyWith(id: actualId);
      await _messagesBox.put(actualId, syncedMessage);
    }
  }

  // Search methods
  List<MessageModel> searchMessages(String query) {
    return _messagesBox.values
        .where((message) => 
            message.content.toLowerCase().contains(query.toLowerCase()))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<UserModel> searchUsers(String query) {
    return _usersBox.values
        .where((user) => 
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Conversation> searchConversations(String query) {
    return _conversationsBox.values
        .where((conversation) => 
            conversation.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Statistics
  int getTotalMessages() => _messagesBox.length;
  int getTotalUsers() => _usersBox.length;
  int getTotalConversations() => _conversationsBox.length;
  
  double getStorageSize() {
    // Approximate storage size in MB
    return (_messagesBox.length + _usersBox.length + _conversationsBox.length) * 0.001;
  }
}

// Hive Adapters (you'll need to generate these using build_runner)
// Run: flutter packages pub run build_runner build

@HiveType(typeId: 0)
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      profilePicture: fields[3] as String?,
      isOnline: fields[4] as bool,
      lastSeen: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.profilePicture)
      ..writeByte(4)
      ..write(obj.isOnline)
      ..writeByte(5)
      ..write(obj.lastSeen);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

@HiveType(typeId: 1)
class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 1;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      id: fields[0] as String,
      senderId: fields[1] as String,
      receiverId: fields[2] as String,
      content: fields[3] as String,
      type: fields[4] as MessageType,
      timestamp: fields[5] as DateTime,
      isRead: fields[6] as bool,
      fileName: fields[7] as String?,
      fileUrl: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.receiverId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.isRead)
      ..writeByte(7)
      ..write(obj.fileName)
      ..writeByte(8)
      ..write(obj.fileUrl);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

@HiveType(typeId: 2)
class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  final int typeId = 2;

  @override
  Conversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conversation(
      id: fields[0] as String,
      name: fields[1] as String,
      avatarUrl: fields[2] as String?,
      lastMessage: fields[3] as MessageModel?,
      unreadCount: fields[4] as int,
      updatedAt: fields[5] as DateTime,
      participants: (fields[6] as List).cast<UserModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatarUrl)
      ..writeByte(3)
      ..write(obj.lastMessage)
      ..writeByte(4)
      ..write(obj.unreadCount)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.participants);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

@HiveType(typeId: 3)
class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 3;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.text;
      case 1:
        return MessageType.image;
      case 2:
        return MessageType.file;
      case 3:
        return MessageType.emoji;
      default:
        return MessageType.text;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.text:
        writer.writeByte(0);
        break;
      case MessageType.image:
        writer.writeByte(1);
        break;
      case MessageType.file:
        writer.writeByte(2);
        break;
      case MessageType.emoji:
        writer.writeByte(3);
        break;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}