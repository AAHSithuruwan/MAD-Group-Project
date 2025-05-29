import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/services/auth_service.dart'; // Import your AuthService

class SignInSelectionScreen extends StatefulWidget {
  const SignInSelectionScreen({super.key});

  @override
  State<SignInSelectionScreen> createState() => _SignInSelectionScreenState();
}

class _SignInSelectionScreenState extends State<SignInSelectionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(25.0, 50, 25, 25),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, size: 30),
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    constraints: BoxConstraints(maxWidth: 380),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose your preferred method to sign in",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildSignInButton(
                    context,
                    "Sign In with Google    ",
                    "assets/images/googleIcon.png",
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      final user = await AuthService().signInWithGoogle();
                      setState(() => _isLoading = false);
                      if (user != null) {
                        // Navigate to home or your main screen
                        context.go('/');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Google sign-in failed')),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  _buildSignInButton(
                    context,
                    "Sign In with Facebook",
                    "assets/images/fbIcon.png",
                  ),
                  SizedBox(height: 15),
                  _buildSignInButton(
                    context,
                    "Sign In with Microsoft",
                    "assets/images/microsoftIcon.png",
                  ),
                  SizedBox(height: 30),
                  _buildDividerWithText("Or"),
                  SizedBox(height: 30),
                  _buildUsernamePasswordButton(context),
                  SizedBox(height: 30),
                  if (_isLoading) CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton(
      BuildContext context, String text, String iconPath, {VoidCallback? onPressed}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 380, minHeight: 50),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0x33000000)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(width: 35, height: 35, image: AssetImage(iconPath)),
            SizedBox(width: 15),
            Text(text, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Container(
      constraints: BoxConstraints(maxWidth: 380),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.grey.shade300, thickness: 3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 24,
                fontFamily: "Inter",
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey.shade300, thickness: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernamePasswordButton(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 380, minHeight: 50),
      child: MaterialButton(
        color: Colors.black,
        onPressed: () {
          context.push('/sign-in');
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0x33000000)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Using Username and Password",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}