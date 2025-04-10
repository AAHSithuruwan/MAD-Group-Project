import 'package:flutter/material.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.normal ,fontFamily: 'Inter'),
                  ),
                ),
                SizedBox(height: 40),
        
                // Email TextField
                Text('Email'),
        
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                ),
        
                SizedBox(height: 20),
        
                // Password TextField
                Text('Password'),
                TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
        
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot password ?', style: TextStyle(fontWeight:FontWeight.normal, color: Colors.black, decoration: TextDecoration.underline),),
                  ),
                ),
        
                SizedBox(height: 20),
        
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1BA424),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
        
                SizedBox(height: 20),
        
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add your registration logic here
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 16, fontWeight:FontWeight.normal, color: Colors.black, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }}