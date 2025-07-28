import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/settings_controller.dart';
import '../controllers/theme_controller.dart';
import '../utils/network_test.dart';
import '../services/local_notification_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final ThemeController themeController = Get.find();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Appearance Settings
            _buildSettingsCard(
              context,
              title: 'Appearance',
              icon: Icons.palette_outlined,
              children: [
                Obx(() => SwitchListTile(
                  title: Text('Dark Mode'),
                  subtitle: Text('Switch between light and dark theme'),
                  value: themeController.isDarkMode.value,
                  onChanged: (_) => controller.toggleDarkMode(),
                  secondary: Icon(
                    themeController.isDarkMode.value 
                        ? Icons.dark_mode 
                        : Icons.light_mode,
                  ),
                )),
                
                Divider(),
                
                Obx(() => ListTile(
                  title: Text('Chat Bubble Style'),
                  subtitle: Text(controller.chatBubbleStyleName),
                  leading: Icon(Icons.chat_bubble_outline),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showChatBubbleStyleDialog(context, controller),
                )),
              ],
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 16),
            
            // Chat Settings
            _buildSettingsCard(
              context,
              title: 'Chat',
              icon: Icons.chat_outlined,
              children: [
                Obx(() => SwitchListTile(
                  title: Text('Notifications'),
                  subtitle: Text('Receive message notifications'),
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                  secondary: Icon(Icons.notifications_outlined),
                )),
                
                Divider(),
                
                Obx(() => SwitchListTile(
                  title: Text('Sound'),
                  subtitle: Text('Play sound for new messages'),
                  value: controller.soundEnabled.value,
                  onChanged: controller.toggleSound,
                  secondary: Icon(Icons.volume_up_outlined),
                )),
                
                Divider(),
                
                Obx(() => SwitchListTile(
                  title: Text('Auto Download Images'),
                  subtitle: Text('Automatically download images'),
                  value: controller.autoDownloadImages.value,
                  onChanged: controller.toggleAutoDownload,
                  secondary: Icon(Icons.download_outlined),
                )),
              ],
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 16),
            
            // Language Settings
            _buildSettingsCard(
              context,
              title: 'Language & Region',
              icon: Icons.language_outlined,
              children: [
                Obx(() => ListTile(
                  title: Text('Language'),
                  subtitle: Text(controller.currentLanguageName),
                  leading: Icon(Icons.translate),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showLanguageDialog(context, controller),
                )),
              ],
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 16),
            
            // About Settings
            _buildSettingsCard(
              context,
              title: 'About',
              icon: Icons.info_outline,
              children: [
                ListTile(
                  title: Text('App Version'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.app_settings_alt),
                ),
                
                Divider(),
                
                ListTile(
                  title: Text('Privacy Policy'),
                  leading: Icon(Icons.privacy_tip_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Privacy Policy would open here',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                
                Divider(),
                
                ListTile(
                  title: Text('Terms of Service'),
                  leading: Icon(Icons.description_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Terms of Service would open here',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 16),
            
            // Data & Storage
            _buildSettingsCard(
              context,
              title: 'Data & Storage',
              icon: Icons.storage_outlined,
              children: [
                ListTile(
                  title: Text('Clear App Data'),
                  subtitle: Text('Delete all app data and settings'),
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  onTap: controller.clearAppData,
                ),
              ],
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 16),
            
            // Network & Development
            _buildSettingsCard(
              context,
              title: 'Network & Development',
              icon: Icons.network_check_outlined,
              children: [
                ListTile(
                  title: Text('Test Connection'),
                  subtitle: Text('Test connection to local server'),
                  leading: Icon(Icons.wifi_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => NetworkTest.testConnection(),
                ),
                
                Divider(),
                
                ListTile(
                  title: Text('Find Server'),
                  subtitle: Text('Auto-discover server on network'),
                  leading: Icon(Icons.search_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => NetworkTest.findServerUrl(3000),
                ),
                
                Divider(),
                
                ListTile(
                  title: Text('Network Config'),
                  subtitle: Text('View current network settings'),
                  leading: Icon(Icons.settings_ethernet_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => NetworkTest.showNetworkConfigDialog(),
                ),
                
                Divider(),
                
                ListTile(
                  title: Text('Test Notification'),
                  subtitle: Text('Test local notifications'),
                  leading: Icon(Icons.notifications_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    try {
                      final notificationService = Get.find<LocalNotificationService>();
                      notificationService.showTestNotification();
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Notification service not available',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ],
            )
                .animate(delay: 900.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 24),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.logout,
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
                .animate(delay: 1100.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showChatBubbleStyleDialog(BuildContext context, SettingsController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Chat Bubble Style'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ChatBubbleStyle.values.map((style) {
            return Obx(() => RadioListTile<ChatBubbleStyle>(
              title: Text(style == ChatBubbleStyle.classic ? 'Classic' : 'Modern'),
              value: style,
              groupValue: controller.chatBubbleStyle.value,
              onChanged: (value) {
                if (value != null) {
                  controller.setChatBubbleStyle(value);
                  Get.back();
                }
              },
            ));
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsController controller) {
    final languages = {
      AppLanguage.english: 'English',
      AppLanguage.spanish: 'Español',
      AppLanguage.french: 'Français',
      AppLanguage.german: 'Deutsch',
    };

    Get.dialog(
      AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.entries.map((entry) {
            return Obx(() => RadioListTile<AppLanguage>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: controller.selectedLanguage.value,
              onChanged: (value) {
                if (value != null) {
                  controller.setLanguage(value);
                  Get.back();
                }
              },
            ));
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}