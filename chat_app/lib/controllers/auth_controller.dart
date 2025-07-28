import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  // Observable variables
  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var currentUser = Rxn<UserModel>();
  
  // Keys for SharedPreferences
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userDataKey = 'userData';

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn.value = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn.value) {
        // Load user data from preferences
        final userDataString = prefs.getString(_userDataKey);
        if (userDataString != null) {
          // In a real app, you would parse JSON here
          // For demo purposes, we'll create a sample user
          currentUser.value = UserModel(
            id: '1',
            name: 'John Doe',
            email: 'john.doe@example.com',
            isOnline: true,
          );
        }
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  // Login function
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));
      
      // Demo login logic - accept any email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        // Create user model
        currentUser.value = UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: email.split('@')[0].capitalize ?? 'User',
          email: email,
          isOnline: true,
        );
        
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userDataKey, currentUser.value!.toJson().toString());
        
        isLoggedIn.value = true;
        isLoading.value = false;
        
        return true;
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Please enter valid email and password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Login failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Signup function
  Future<bool> signup(String name, String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));
      
      // Demo signup logic
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // Create user model
        currentUser.value = UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          email: email,
          isOnline: true,
        );
        
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userDataKey, currentUser.value!.toJson().toString());
        
        isLoggedIn.value = true;
        isLoading.value = false;
        
        return true;
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Signup failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userDataKey);
      
      isLoggedIn.value = false;
      currentUser.value = null;
      
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile(String name, String email) async {
    try {
      if (currentUser.value != null) {
        currentUser.value = currentUser.value!.copyWith(
          name: name,
          email: email,
        );
        
        // Save updated user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userDataKey, currentUser.value!.toJson().toString());
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}