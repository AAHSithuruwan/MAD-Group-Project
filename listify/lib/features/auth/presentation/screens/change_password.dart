import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 40),

              // New Password Field
              Text(
                'New Password',
                style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 380,
                height: 55,
                child: TextField(
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    hintText: '***************',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Confirm Password Field
              Text(
                'Confirm Password',
                style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 380,
                height: 55,
                child: TextField(
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Text(
                'Enter the One-Time-Password that was sent to your email.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                ),
              ),

              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Resend OTP logic here
                  },
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle verify/change password logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
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
