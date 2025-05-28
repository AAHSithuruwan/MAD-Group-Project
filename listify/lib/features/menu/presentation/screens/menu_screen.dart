import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  const MenuScreen({super.key, this.title, this.body, this.data});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                      ? NetworkImage(user.photoURL!)
                      : const AssetImage("assets/Ellipse 30.png") as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "No Name",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user?.email ?? "No Email",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
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
                  _buildMenuItem(
                    context,
                    "assets/Carrot.png",
                    "Items",
                    "",
                    "/items",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/Account.png",
                    "Account",
                    "5",
                    "/account",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/Categorize.png",
                    "Categories",
                    "5",
                    "/categories",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/To Do List.png",
                    "Lists",
                    "4",
                    "/lists",
                  ),
                  _buildMenuItem(
                    context,
                    "assets/Graph.png",
                    "History",
                    "5",
                    "/history",
                  ),

                  _buildMenuItem(
                    context,
                    "assets/Categorize.png",
                    "Categories",
                    "5",
                    "/categories",
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
      trailing: (count != null && count.trim().isNotEmpty)
          ? CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey[300],
              child: Text(
                count,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      onTap: () {
        context.push(route);
      },
    );
  }
}