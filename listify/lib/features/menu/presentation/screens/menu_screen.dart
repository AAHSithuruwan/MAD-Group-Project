import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:listify/features/auth/presentation/widgets/logout_button.dart';
import 'package:listify/core/services/item_service.dart';

final ItemService itemService = ItemService();

class MenuScreen extends StatefulWidget {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  const MenuScreen({super.key, this.title, this.body, this.data});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ItemService itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Profile Section using Firestore profile
          FutureBuilder<Map<String, dynamic>?>(
            future: authService.getCurrentUserProfile(),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final photoURL = profile?['photoURL'] as String? ?? '';
              final displayName =
                  profile?['displayName'] as String? ?? 'No Name';
              final email = profile?['email'] as String? ?? 'No Email';

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 50,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          photoURL.isNotEmpty
                              ? NetworkImage(photoURL)
                              : const AssetImage(
                                    "assets/images/placeholder.png",
                                  )
                                  as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    // Add the logout button here
                    LogoutButton(),
                  ],
                ),
              );
            },
          ),

          // Menu List
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 16,
              ), // Add left padding for space
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Divider(),
                  ),

                  FutureBuilder<int>(
                    future: itemService.getItemCount(),
                    builder: (context, snapshot) {
                      final count =
                          snapshot.hasData ? snapshot.data.toString() : '';
                      return _buildMenuItem(
                        context,
                        "assets/images/Carrot.png",
                        "Items",
                        count,
                        "/view_all_items",
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    "assets/images/Account.png",
                    "Account",
                    "5",
                    "/account",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/images/Categorize.png",
                    "Categories",
                    "5",
                    "/categories",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/images/To Do List.png",
                    "Lists",
                    "4",
                    "/lists",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/images/Graph.png",
                    "History",
                    "5",
                    "/history",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/images/settings.png",
                    "Settings",
                    "5",
                    "/setting",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menu Item Widget with GoRouter navigation
  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String title,
    String count,
    String route,
  ) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // Light shadow color
              blurRadius: 4, // Blur radius for the shadow
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white, // White highlight inside CircleAvatar
          radius: 20, // Adjust size of the CircleAvatar
          child: Image.asset(
            imagePath, // Image instead of Icon
            width: 24,
            height: 24,
          ),
        ),
      ),
      title: Text(title),
      trailing:
          (count.trim().isNotEmpty)
              ? CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[300],
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
      onTap: () async {
        await context.push(route);
        setState(() {});
      },
    );
  }
}
