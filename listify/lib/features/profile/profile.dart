import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/Models/UserModel.dart';

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(); // ✅ Removed MaterialApp to fix black screen issue
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  UserModel? currentUserData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
      if (doc.exists) {
        setState(() {
          currentUserData = UserModel.fromMap(doc.data()!);
        });
      }
    }
  }

  Future<void> updateUserField(String field, String newValue) async {
    final uid = user?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        field: newValue,
      });

      if (field == "email") {
        await user!.updateEmail(newValue);
      }

      if (field == "displayName") {
        await user!.updateDisplayName(newValue);
      }

      if (field == "password") {
        await user!.updatePassword(newValue);
      }

      fetchUserData(); // Refresh profile data
    }
  }

  void showEditDialog(
    BuildContext context,
    String title,
    String field,
    String currentValue,
  ) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            obscureText: field == "password",
            decoration: InputDecoration(hintText: 'Enter new $title'),
          ),
          actions: [
            TextButton(
              onPressed:
                  () =>
                      Navigator.of(dialogContext).pop(), // ✅ Use dialogContext
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await updateUserField(field, controller.text);
                Navigator.of(dialogContext).pop(); // ✅ Close dialog properly
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = user?.uid ?? '';
    final email = user?.email ?? 'example@email.com';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          currentUserData == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile.jpeg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      currentUserData!.email,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    _buildButton(
                      context,
                      'Edit Name',
                      onTap: () {
                        showEditDialog(
                          context,
                          'Name',
                          'displayName',
                          currentUserData!.displayName,
                        );
                      },
                    ),
                    _buildButton(
                      context,
                      'Change Email',
                      onTap: () {
                        showEditDialog(
                          context,
                          'Email',
                          'email',
                          currentUserData!.email,
                        );
                      },
                    ),
                    _buildButton(
                      context,
                      'Change Password',
                      onTap: () {
                        context.push("/change-password");
                      },
                    ),
                    _buildButton(
                      context,
                      'Log out',
                      icon: Icons.logout,
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                    ),
                    _buildButton(
                      context,
                      'Delete Account',
                      textColor: Colors.black,
                      centerText: false,
                      onTap: () {
                        context.push('/delete-account');
                      },
                    ),
                    SizedBox(height: 80),
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
    required VoidCallback onTap,
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
            alignment: centerText ? Alignment.center : Alignment.centerLeft,
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
          onTap: onTap,
        ),
      ),
    );
  }
}
