import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Form keys
  final profileFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  
  // Observable variables
  var isEditing = false.obs;
  var isLoading = false.obs;
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var selectedImagePath = ''.obs;
  
  // Get AuthController
  final AuthController authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load user data
  void _loadUserData() {
    final user = authController.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    if (isEditing.value) {
      // Cancel editing - reload original data
      _loadUserData();
    }
    isEditing.value = !isEditing.value;
  }

  // Toggle password visibility
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validate name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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

  // Validate current password
  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  // Validate new password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Update profile
  Future<void> updateProfile() async {
    if (profileFormKey.currentState!.validate()) {
      isLoading.value = true;
      
      await authController.updateProfile(
        nameController.text.trim(),
        emailController.text.trim(),
      );
      
      isLoading.value = false;
      isEditing.value = false;
    }
  }

  // Change password
  Future<void> changePassword() async {
    if (passwordFormKey.currentState!.validate()) {
      isLoading.value = true;
      
      // Simulate password change
      await Future.delayed(Duration(seconds: 1));
      
      // Clear password fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      isLoading.value = false;
    }
  }

  // Pick profile image
  Future<void> pickProfileImage() async {
    // This would integrate with image_picker package
    Get.snackbar(
      'Info',
      'Image picker would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Remove profile image
  void removeProfileImage() {
    selectedImagePath.value = '';
    Get.snackbar(
      'Info',
      'Profile image removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}