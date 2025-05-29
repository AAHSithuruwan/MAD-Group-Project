import 'package:flutter/material.dart';
import 'package:listify/features/profile/setting.dart';

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile UI',
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpeg'),
            ),
            SizedBox(height: 10),
            Text(
              'umeshakavindi2000@gmail.com',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 20),
            _buildButton(context, 'Edit name'),
            _buildButton(context, 'Change email'),
            _buildButton(context, 'Change password'),
            _buildButton(context, 'Log out', icon: Icons.logout),
            _buildButton(
              context,
              'Delete account',
              textColor: Colors.black, // Set text color to black
              centerText: false, // Align text to the left
            ),
            SizedBox(height: 80), // Space for bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label, {
    IconData? icon,
    Color? textColor,
    bool centerText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Align(
            alignment:
                centerText
                    ? Alignment.center
                    : Alignment
                        .centerLeft, // Align to the left for "Delete account"
            child: Text(
              label,
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          trailing:
              icon != null
                  ? Icon(icon, color: textColor ?? Colors.black)
                  : (!centerText
                      ? Icon(Icons.arrow_forward_ios, size: 16)
                      : null),
          onTap: () {
            // Add logic
          },
        ),
      ),
    );
  }
}
