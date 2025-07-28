import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8,
                  shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Back Button
                          Row(
                            children: [
                              IconButton(
                                onPressed: controller.goToLogin,
                                icon: Icon(Icons.arrow_back),
                              ),
                              Spacer(),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms),
                          
                          // Logo and Title
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.person_add_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                              .animate(delay: 200.ms)
                              .scale(duration: 600.ms, curve: Curves.elasticOut)
                              .fadeIn(),
                          
                          SizedBox(height: 24),
                          
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              .animate(delay: 400.ms)
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.3, end: 0),
                          
                          SizedBox(height: 8),
                          
                          Text(
                            'Join the conversation today',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          )
                              .animate(delay: 600.ms)
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.3, end: 0),
                          
                          SizedBox(height: 32),
                          
                          // Full Name Field
                          TextFormField(
                            controller: controller.nameController,
                            validator: controller.validateName,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          )
                              .animate(delay: 800.ms)
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: -0.3, end: 0),
                          
                          SizedBox(height: 20),
                          
                          // Email Field
                          TextFormField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: controller.validateEmail,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          )
                              .animate(delay: 1000.ms)
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: 0.3, end: 0),
                          
                          SizedBox(height: 20),
                          
                          // Password Field
                          Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible.value,
                            validator: controller.validatePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                          ))
                              .animate(delay: 1200.ms)
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: -0.3, end: 0),
                          
                          SizedBox(height: 20),
                          
                          // Confirm Password Field
                          Obx(() => TextFormField(
                            controller: controller.confirmPasswordController,
                            obscureText: !controller.isConfirmPasswordVisible.value,
                            validator: controller.validateConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your password',
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
                              .slideX(begin: 0.3, end: 0),
                          
                          SizedBox(height: 20),
                          
                          // Terms and Conditions
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                value: controller.acceptTerms.value,
                                onChanged: controller.toggleAcceptTerms,
                              )),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: Theme.of(context).textTheme.bodySmall,
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                              .animate(delay: 1600.ms)
                              .fadeIn(duration: 600.ms),
                          
                          SizedBox(height: 32),
                          
                          // Signup Button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value 
                                  ? null 
                                  : controller.signup,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
                                  : Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ))
                              .animate(delay: 1800.ms)
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.3, end: 0),
                          
                          SizedBox(height: 24),
                          
                          // Already have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: controller.goToLogin,
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                              .animate(delay: 2000.ms)
                              .fadeIn(duration: 600.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}