import 'package:flutter/material.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onLoggedOut;

  const LogoutButton({Key? key, this.onLoggedOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: () async {
        await AuthService().signOut();
        if (onLoggedOut != null) {
          onLoggedOut!();
        } else {
          // Default: navigate to login or root
          context.go('/auth-selection');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully')),
        );
      },
    );
  }
}