import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../controllers/chat_controller.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final AuthController authController = Get.find();
    
    return Scaffold(
      backgroundColor: const Color(0xFFE5DDD5), // WhatsApp background
      body: Row(
        children: [
          // Left Sidebar - Contacts Panel
          Container(
            width: 400,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(
                right: BorderSide(
                  color: Color(0xFFD1D7DB),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Sidebar Header
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEDED),
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFD1D7DB),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // User Avatar
                      Obx(() => CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF00A884),
                        child: Text(
                          authController.currentUser.value?.name[0].toUpperCase() ?? 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )),
                      
                      const Spacer(),
                      
                      // Header Actions
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.donut_large, color: Color(0xFF54656F)),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat, color: Color(0xFF54656F)),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Color(0xFF54656F)),
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
                          const PopupMenuItem(
                            value: 'profile',
                            child: Text('Profile'),
                          ),
                          const PopupMenuItem(
                            value: 'settings',
                            child: Text('Settings'),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Text('Logout', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Search Bar
                Container(
                  padding: const EdgeInsets.all(8),
                  color: const Color(0xFFF0F2F5),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: chatController.searchController,
                      onChanged: chatController.searchContacts,
                      decoration: const InputDecoration(
                        hintText: 'Search or start new chat',
                        hintStyle: TextStyle(color: Color(0xFF667781), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF667781), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ),
                
                // Contacts List
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Obx(() => ListView.builder(
                      itemCount: chatController.filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = chatController.filteredContacts[index];
                        final isSelected = chatController.selectedContact.value?.id == contact.id;
                        
                        return Container(
                          color: isSelected ? const Color(0xFFE7F3FF) : Colors.transparent,
                          child: InkWell(
                            onTap: () => chatController.selectContact(contact),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  // Profile Picture
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color(0xFFDDD4C0),
                                    child: Text(
                                      contact.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF41525D),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 12),
                                  
                                  // Contact info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                contact.name,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF111B21),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '12:00 PM', // Demo time
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF667781),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 2),
                                        
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                chatController.getLastMessage(contact.id),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF667781),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            // Unread count
                                            if (chatController.getUnreadCount(contact.id) > 0)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF00A884),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                                child: Text(
                                                  '${chatController.getUnreadCount(contact.id)}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                  ),
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
      color: const Color(0xFFF0F2F5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 120,
                color: Color(0xFF54656F),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'WhatsApp Web',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: Color(0xFF41525D),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Send and receive messages without keeping your phone online.\nUse WhatsApp on up to 4 linked devices and 1 phone at the same time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF667781),
                height: 1.4,
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
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFEDEDED),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFD1D7DB),
                width: 1,
              ),
            ),
          ),
          child: Obx(() => Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFDDD4C0),
                child: Text(
                  chatController.selectedContact.value!.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF41525D),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      chatController.selectedContact.value!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF111B21),
                      ),
                    ),
                    Text(
                      chatController.selectedContact.value!.isOnline 
                          ? 'online' 
                          : 'last seen recently',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF667781),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Color(0xFF54656F)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Color(0xFF54656F)),
              ),
            ],
          )),
        ),
        
        // Messages Area with WhatsApp background
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE5DDD5),
              image: DecorationImage(
                image: AssetImage('assets/images/whatsapp_bg.png'), // Optional background pattern
                fit: BoxFit.cover,
                opacity: 0.06,
              ),
            ),
            child: Obx(() => ListView.builder(
              controller: chatController.messagesScrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                final isCurrentUser = message.senderId == 'currentUser';
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(
                    mainAxisAlignment: isCurrentUser 
                        ? MainAxisAlignment.end 
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? const Color(0xFFD9FDD3) // Sent message color
                              : Colors.white, // Received message color
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111B21),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF667781),
                                  ),
                                ),
                                if (isCurrentUser) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    message.isRead 
                                        ? Icons.done_all 
                                        : Icons.done,
                                    size: 16,
                                    color: message.isRead
                                        ? const Color(0xFF53BDEB)
                                        : const Color(0xFF667781),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
          ),
        ),
        
        // Emoji Picker
        Obx(() => chatController.isEmojiPickerVisible.value
            ? SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    chatController.addEmoji(emoji.emoji);
                  },
                  config: const Config(
                    height: 250,
                    checkPlatformCompatibility: true,
                  ),
                ),
              )
            : const SizedBox.shrink()),
        
        // Message Input Area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFEDEDED),
            border: Border(
              top: BorderSide(
                color: Color(0xFFD1D7DB),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: chatController.toggleEmojiPicker,
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xFF54656F),
                ),
              ),
              IconButton(
                onPressed: chatController.attachFile,
                icon: const Icon(
                  Icons.attach_file,
                  color: Color(0xFF54656F),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: chatController.messageController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Color(0xFF667781)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => chatController.sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF00A884),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: chatController.sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}