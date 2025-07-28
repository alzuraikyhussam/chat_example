import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Observable for dark mode
  var isDarkMode = false.obs;
  
  // Key for storing theme preference
  static const String _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool(_themeKey) ?? false;
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  // Toggle theme and save to SharedPreferences
  Future<void> toggleTheme() async {
    try {
      isDarkMode.value = !isDarkMode.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDarkMode.value);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  // Set specific theme
  Future<void> setTheme(bool isDark) async {
    try {
      isDarkMode.value = isDark;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDarkMode.value);
    } catch (e) {
      print('Error setting theme: $e');
    }
  }
}