import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';
import 'controllers/theme_controller.dart';
import 'controllers/auth_controller.dart';
import 'services/api_service.dart';
import 'services/websocket_service.dart';
import 'services/local_storage_service.dart';
import 'services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await _initializeServices();
  
  runApp(ChatApp());
}

Future<void> _initializeServices() async {
  // Initialize API service
  final apiService = ApiService();
  apiService.initialize();
  await apiService.loadTokens();
  
  // Initialize and register services with GetX
  await Get.putAsync(() => LocalStorageService().onInit().then((_) => LocalStorageService()));
  await Get.putAsync(() => LocalNotificationService().onInit().then((_) => LocalNotificationService()));
  Get.put(WebSocketService());
}

class ChatApp extends StatelessWidget {
  ChatApp({super.key});

  // Initialize controllers
  final ThemeController themeController = Get.put(ThemeController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.isDarkMode.value 
          ? ThemeMode.dark 
          : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ));
  }
}
