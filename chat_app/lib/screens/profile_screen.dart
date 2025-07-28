import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isEditing.value 
                ? controller.updateProfile 
                : controller.toggleEditMode,
            child: Text(
              controller.isEditing.value ? 'Save' : 'Edit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture Section
            Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Obx(() => controller.selectedImagePath.value.isNotEmpty
                            ? ClipOval(
                                child: Image.asset(
                                  controller.selectedImagePath.value,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: controller.pickProfileImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  if (controller.selectedImagePath.value.isNotEmpty)
                    TextButton(
                      onPressed: controller.removeProfileImage,
                      child: Text(
                        'Remove Photo',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(),
            
            SizedBox(height: 32),
            
            // Profile Information
            Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: controller.profileFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Name Field
                      Obx(() => TextFormField(
                        controller: controller.nameController,
                        enabled: controller.isEditing.value,
                        validator: controller.validateName,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ))
                          .animate(delay: 200.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                      
                      SizedBox(height: 20),
                      
                      // Email Field
                      Obx(() => TextFormField(
                        controller: controller.emailController,
                        enabled: controller.isEditing.value,
                        validator: controller.validateEmail,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ))
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: 0.3, end: 0),
                      
                      SizedBox(height: 24),
                      
                      // Cancel Button (only when editing)
                      Obx(() => controller.isEditing.value
                          ? Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: controller.toggleEditMode,
                                    child: Text('Cancel'),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value 
                                        ? null 
                                        : controller.updateProfile,
                                    child: controller.isLoading.value
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : Text('Save Changes'),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink())
                          .animate(delay: 600.ms)
                          .fadeIn(duration: 600.ms),
                    ],
                  ),
                ),
              ),
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            SizedBox(height: 24),
            
            // Change Password Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: controller.passwordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Current Password
                      Obx(() => TextFormField(
                        controller: controller.currentPasswordController,
                        obscureText: !controller.isCurrentPasswordVisible.value,
                        validator: controller.validateCurrentPassword,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isCurrentPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleCurrentPasswordVisibility,
                          ),
                        ),
                      ))
                          .animate(delay: 1000.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                      
                      SizedBox(height: 20),
                      
                      // New Password
                      Obx(() => TextFormField(
                        controller: controller.newPasswordController,
                        obscureText: !controller.isNewPasswordVisible.value,
                        validator: controller.validateNewPassword,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isNewPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleNewPasswordVisibility,
                          ),
                        ),
                      ))
                          .animate(delay: 1200.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: 0.3, end: 0),
                      
                      SizedBox(height: 20),
                      
                      // Confirm New Password
                      Obx(() => TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        validator: controller.validateConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility,
                          ),
                        ),
                      ))
                          .animate(delay: 1400.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                      
                      SizedBox(height: 24),
                      
                      // Change Password Button
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value 
                              ? null 
                              : controller.changePassword,
                          child: controller.isLoading.value
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text('Change Password'),
                        )),
                      )
                          .animate(delay: 1600.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ),
            )
                .animate(delay: 1800.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}