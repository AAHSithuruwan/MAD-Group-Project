import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            SizedBox(height: 30),

            // Your Name
            Text(
              'Your name',
              style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
            ),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Email
            Text('Email', style: TextStyle(fontSize: 18, fontFamily: 'Inter')),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password
            Text(
              'Password',
              style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
            ),
            SizedBox(height: 5),
            TextField(
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
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Confirm Password
            Text(
              'Confirm Password',
              style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
            ),
            SizedBox(height: 5),
            TextField(
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),

            // Register Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Sign in link
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distribute space evenly
              children: [
                Text("Don't have an account?", style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    // Add your registration logic here
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
    );
  }
}
