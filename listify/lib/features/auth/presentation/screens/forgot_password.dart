import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listify/core/providers/auth_provider.dart';

// StateProvider to manage error messages
final forgotPasswordErrorProvider = StateProvider<String?>((ref) => null);

class ForgotPasswordScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final errorMessage = ref.watch(forgotPasswordErrorProvider); // Watch the error message state

    void _resetPassword() async {
      // Clear the error message before validation
      ref.read(forgotPasswordErrorProvider.notifier).state = null;

      String email = _emailController.text.trim();

      if (email.isNotEmpty) {
        try {
          await authService.sendPasswordResetEmail(email);
          ref.read(forgotPasswordErrorProvider.notifier).state =
              "Password reset email sent. Check your inbox.";
        } catch (e) {
          ref.read(forgotPasswordErrorProvider.notifier).state =
              "Error: ${e.toString()}";
        }
      } else {
        ref.read(forgotPasswordErrorProvider.notifier).state =
            "Please enter your email.";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Display error message
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: errorMessage.contains("sent")
                          ? Colors.green // Success message color
                          : Colors.red, // Error message color
                      fontSize: 14,
                    ),
                  ),
                ),

              // Email TextField
              Text('Email'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Reset Password Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1BA424),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}