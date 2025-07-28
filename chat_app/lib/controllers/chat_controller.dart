import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class ChatController extends GetxController {
  // Observable variables
  var selectedContact = Rxn<UserModel>();
  var contacts = <UserModel>[].obs;
  var messages = <MessageModel>[].obs;
  var isEmojiPickerVisible = false.obs;
  var searchQuery = ''.obs;
  
  // Text controllers
  final messageController = TextEditingController();
  final searchController = TextEditingController();
  
  // Scroll controller for messages
  final ScrollController messagesScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadDemoData();
  }

  @override
  void onClose() {
    messageController.dispose();
    searchController.dispose();
    messagesScrollController.dispose();
    super.onClose();
  }

  // Load demo data
  void _loadDemoData() {
    // Demo contacts
    contacts.addAll([
      UserModel(
        id: '1',
        name: 'Alice Johnson',
        email: 'alice@example.com',
        isOnline: true,
      ),
      UserModel(
        id: '2',
        name: 'Bob Smith',
        email: 'bob@example.com',
        isOnline: false,
        lastSeen: DateTime.now().subtract(Duration(hours: 2)),
      ),
      UserModel(
        id: '3',
        name: 'Carol Davis',
        email: 'carol@example.com',
        isOnline: true,
      ),
      UserModel(
        id: '4',
        name: 'David Wilson',
        email: 'david@example.com',
        isOnline: false,
        lastSeen: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      UserModel(
        id: '5',
        name: 'Emma Brown',
        email: 'emma@example.com',
        isOnline: true,
      ),
      UserModel(
        id: '6',
        name: 'Frank Miller',
        email: 'frank@example.com',
        isOnline: false,
        lastSeen: DateTime.now().subtract(Duration(days: 1)),
      ),
    ]);
  }

  // Select a contact to chat with
  void selectContact(UserModel contact) {
    selectedContact.value = contact;
    _loadMessagesForContact(contact.id);
  }

  // Load messages for selected contact
  void _loadMessagesForContact(String contactId) {
    // Demo messages
    messages.clear();
    messages.addAll([
      MessageModel(
        id: '1',
        senderId: contactId,
        receiverId: 'currentUser',
        content: 'Hey there! How are you doing?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: true,
      ),
      MessageModel(
        id: '2',
        senderId: 'currentUser',
        receiverId: contactId,
        content: 'Hi! I\'m doing great, thanks for asking!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      MessageModel(
        id: '3',
        senderId: contactId,
        receiverId: 'currentUser',
        content: 'That\'s wonderful to hear! 😊',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      MessageModel(
        id: '4',
        senderId: 'currentUser',
        receiverId: contactId,
        content: 'What are you up to today?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        isRead: true,
      ),
      MessageModel(
        id: '5',
        senderId: contactId,
        receiverId: 'currentUser',
        content: 'Just working on some projects. How about you?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        isRead: false,
      ),
    ]);
    
    // Scroll to bottom after loading messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messagesScrollController.hasClients) {
        messagesScrollController.animateTo(
          messagesScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Send a message
  void sendMessage() {
    if (messageController.text.trim().isEmpty || selectedContact.value == null) {
      return;
    }

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'currentUser',
      receiverId: selectedContact.value!.id,
      content: messageController.text.trim(),
      type: MessageType.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    messages.add(message);
    messageController.clear();
    
    // Hide emoji picker if visible
    if (isEmojiPickerVisible.value) {
      toggleEmojiPicker();
    }

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messagesScrollController.hasClients) {
        messagesScrollController.animateTo(
          messagesScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Toggle emoji picker visibility
  void toggleEmojiPicker() {
    isEmojiPickerVisible.value = !isEmojiPickerVisible.value;
  }

  // Add emoji to message
  void addEmoji(String emoji) {
    messageController.text += emoji;
  }

  // Search contacts
  void searchContacts(String query) {
    searchQuery.value = query;
  }

  // Get filtered contacts based on search
  List<UserModel> get filteredContacts {
    if (searchQuery.value.isEmpty) {
      return contacts;
    }
    return contacts.where((contact) =>
        contact.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        contact.email.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  // Get last message for a contact
  String getLastMessage(String contactId) {
    final contactMessages = messages.where((message) =>
        message.senderId == contactId || message.receiverId == contactId
    ).toList();
    
    if (contactMessages.isEmpty) {
      return 'No messages yet';
    }
    
    contactMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return contactMessages.first.content;
  }

  // Get unread message count for a contact
  int getUnreadCount(String contactId) {
    return messages.where((message) =>
        message.senderId == contactId && !message.isRead
    ).length;
  }

  // Mark messages as read
  void markMessagesAsRead(String contactId) {
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].senderId == contactId && !messages[i].isRead) {
        messages[i] = messages[i].copyWith(isRead: true);
      }
    }
  }

  // Handle file attachment
  Future<void> attachFile() async {
    // This would integrate with file_picker package
    Get.snackbar(
      'Info',
      'File attachment feature would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Handle image attachment
  Future<void> attachImage() async {
    // This would integrate with image_picker package
    Get.snackbar(
      'Info',
      'Image attachment feature would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}