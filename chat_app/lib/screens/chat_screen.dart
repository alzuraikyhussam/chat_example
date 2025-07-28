import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../controllers/chat_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/contact_list_item.dart';
import '../widgets/message_bubble.dart';
import '../routes/app_routes.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final AuthController authController = Get.find();
    
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Sidebar Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // User Avatar
                      Obx(() => CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          authController.currentUser.value?.name[0].toUpperCase() ?? 'U',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                      
                      SizedBox(width: 12),
                      
                      Expanded(
                        child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.currentUser.value?.name ?? 'User',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )),
                      ),
                      
                      // Header Actions
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          switch (value) {
                            case 'profile':
                              Get.toNamed(AppRoutes.profile);
                              break;
                            case 'settings':
                              Get.toNamed(AppRoutes.settings);
                              break;
                            case 'logout':
                              authController.logout();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 8),
                                Text('Profile'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'settings',
                            child: Row(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(width: 8),
                                Text('Settings'),
                              ],
                            ),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Logout', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Search Bar
                Container(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    controller: chatController.searchController,
                    onChanged: chatController.searchContacts,
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                
                // Contacts List
                Expanded(
                  child: Obx(() => ListView.builder(
                    itemCount: chatController.filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = chatController.filteredContacts[index];
                      return ContactListItem(
                        contact: contact,
                        lastMessage: chatController.getLastMessage(contact.id),
                        unreadCount: chatController.getUnreadCount(contact.id),
                        isSelected: chatController.selectedContact.value?.id == contact.id,
                        onTap: () => chatController.selectContact(contact),
                        lastMessageTime: DateTime.now().subtract(Duration(minutes: index * 30)),
                      );
                    },
                  )),
                ),
              ],
            ),
          ),
          
          // Main Chat Area
          Expanded(
            child: Obx(() {
              if (chatController.selectedContact.value == null) {
                return _buildWelcomeScreen(context);
              }
              return _buildChatArea(context, chatController);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Welcome to ChatApp',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select a contact to start chatting',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea(BuildContext context, ChatController chatController) {
    return Column(
      children: [
        // Chat Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Obx(() => Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  chatController.selectedContact.value!.name[0].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatController.selectedContact.value!.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      chatController.selectedContact.value!.isOnline 
                          ? 'Online' 
                          : 'Last seen recently',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: chatController.selectedContact.value!.isOnline
                            ? Colors.green
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.videocam),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          )),
        ),
        
        // Messages Area
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Obx(() => ListView.builder(
              controller: chatController.messagesScrollController,
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return MessageBubble(
                  message: message,
                  isCurrentUser: message.senderId == 'currentUser',
                );
              },
            )),
          ),
        ),
        
        // Emoji Picker
        Obx(() => chatController.isEmojiPickerVisible.value
            ? Container(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    chatController.addEmoji(emoji.emoji);
                  },
                  config: Config(
                    height: 250,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink()),
        
        // Message Input
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: chatController.attachFile,
                icon: Icon(Icons.attach_file),
              ),
              Expanded(
                child: TextField(
                  controller: chatController.messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => chatController.sendMessage(),
                ),
              ),
              IconButton(
                onPressed: chatController.toggleEmojiPicker,
                icon: Icon(Icons.emoji_emotions_outlined),
              ),
              IconButton(
                onPressed: chatController.sendMessage,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}