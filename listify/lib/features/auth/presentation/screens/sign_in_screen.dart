import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/providers/auth_provider.dart';

// StateProvider to manage error messages
final signInErrorProvider = StateProvider<String?>((ref) => null);

class SignInScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final errorMessage = ref.watch(
      signInErrorProvider,
    ); // Watch the error message state

    void _signIn() async {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        try {
          User? user = await authService.signInWithEmailAndPassword(
            email,
            password,
          );
          if (user != null) {
            print("Signed in as: ${user.email}");
            context.go('/'); // Redirect to home
          } else {
            ref.read(signInErrorProvider.notifier).state =
                "Failed to sign in. Please try again.";
          }
        } catch (e) {
          ref.read(signInErrorProvider.notifier).state =
              "Error: ${e.toString()}";
        }
      } else {
        ref.read(signInErrorProvider.notifier).state =
            "Please enter both email and password.";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
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
                  'Sign in',
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
                      color: Colors.red, // Error message color
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

              // Password TextField
              Text('Password'),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _isPasswordVisible = !_isPasswordVisible;
                    },
                  ),
                ),
              ),

              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push(
                      '/forgot-password',
                    ); // Navigate to Forgot Password screen
                  },
                  child: Text(
                    'Forgot password ?',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1BA424),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/sign-up'); // Navigate to sign-up screen
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
