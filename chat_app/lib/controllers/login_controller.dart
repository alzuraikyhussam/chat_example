import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Observable variables
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;
  
  // Get AuthController
  final AuthController authController = Get.find();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Login function
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      
      final success = await authController.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (success) {
        // Clear form
        emailController.clear();
        passwordController.clear();
        
        // Navigate to chat screen
        Get.offAllNamed(AppRoutes.chat);
      }
      
      isLoading.value = false;
    }
  }

  // Navigate to signup
  void goToSignup() {
    Get.toNamed(AppRoutes.signup);
  }

  // Forgot password
  void forgotPassword() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Info',
        'Please enter your email address first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    Get.snackbar(
      'Password Reset',
      'Password reset link sent to ${emailController.text.trim()}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}