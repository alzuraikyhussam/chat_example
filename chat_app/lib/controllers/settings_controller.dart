import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_controller.dart';
import 'auth_controller.dart';

enum ChatBubbleStyle {
  classic,
  modern,
}

enum AppLanguage {
  english,
  spanish,
  french,
  german,
}

class SettingsController extends GetxController {
  // Observable variables
  var chatBubbleStyle = ChatBubbleStyle.modern.obs;
  var selectedLanguage = AppLanguage.english.obs;
  var notificationsEnabled = true.obs;
  var soundEnabled = true.obs;
  var autoDownloadImages = true.obs;
  
  // Controllers
  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();
  
  // Keys for SharedPreferences
  static const String _chatBubbleStyleKey = 'chatBubbleStyle';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications';
  static const String _soundKey = 'sound';
  static const String _autoDownloadKey = 'autoDownload';

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load chat bubble style
      final bubbleStyleIndex = prefs.getInt(_chatBubbleStyleKey) ?? 1;
      chatBubbleStyle.value = ChatBubbleStyle.values[bubbleStyleIndex];
      
      // Load language
      final languageIndex = prefs.getInt(_languageKey) ?? 0;
      selectedLanguage.value = AppLanguage.values[languageIndex];
      
      // Load other settings
      notificationsEnabled.value = prefs.getBool(_notificationsKey) ?? true;
      soundEnabled.value = prefs.getBool(_soundKey) ?? true;
      autoDownloadImages.value = prefs.getBool(_autoDownloadKey) ?? true;
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  // Save setting to SharedPreferences
  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      print('Error saving setting: $e');
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    await themeController.toggleTheme();
  }

  // Set chat bubble style
  Future<void> setChatBubbleStyle(ChatBubbleStyle style) async {
    chatBubbleStyle.value = style;
    await _saveSetting(_chatBubbleStyleKey, style.index);
  }

  // Set language
  Future<void> setLanguage(AppLanguage language) async {
    selectedLanguage.value = language;
    await _saveSetting(_languageKey, language.index);
    
    // In a real app, you would update the app's locale here
    Get.snackbar(
      'Language Changed',
      'Language changed to ${_getLanguageName(language)}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Toggle notifications
  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await _saveSetting(_notificationsKey, value);
  }

  // Toggle sound
  Future<void> toggleSound(bool value) async {
    soundEnabled.value = value;
    await _saveSetting(_soundKey, value);
  }

  // Toggle auto download images
  Future<void> toggleAutoDownload(bool value) async {
    autoDownloadImages.value = value;
    await _saveSetting(_autoDownloadKey, value);
  }

  // Get language name
  String _getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.german:
        return 'Deutsch';
    }
  }

  // Get current language name
  String get currentLanguageName => _getLanguageName(selectedLanguage.value);

  // Get chat bubble style name
  String get chatBubbleStyleName {
    switch (chatBubbleStyle.value) {
      case ChatBubbleStyle.classic:
        return 'Classic';
      case ChatBubbleStyle.modern:
        return 'Modern';
    }
  }

  // Logout
  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Clear app data
  Future<void> clearAppData() async {
    Get.dialog(
      AlertDialog(
        title: Text('Clear App Data'),
        content: Text('This will clear all app data including messages and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              
              // Clear SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              // Reset settings to default
              chatBubbleStyle.value = ChatBubbleStyle.modern;
              selectedLanguage.value = AppLanguage.english;
              notificationsEnabled.value = true;
              soundEnabled.value = true;
              autoDownloadImages.value = true;
              
              // Reset theme
              await themeController.setTheme(false);
              
              Get.snackbar(
                'Success',
                'App data cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Clear Data'),
          ),
        ],
      ),
    );
  }
}