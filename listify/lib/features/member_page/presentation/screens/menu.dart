import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/Ellipse 30.png",
                  ),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hiruni Ishara",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "hiruniishara@gmail.com",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(left: 16), // Add left padding for space
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Divider(),
                  ),
                  _buildMenuItem("assets/images/Carrot.png", "Items", "10"),
                  _buildMenuItem("assets/images/Account.png", "Account", "5"),
                  _buildMenuItem("assets/images/Categorize.png", "Categories", "5"),
                  _buildMenuItem("assets/images/To Do List.png", "Lists", "4"),
                  _buildMenuItem("assets/images/Graph.png", "History", "5"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menu Item Widget
  Widget _buildMenuItem(String imagePath, String title, String count) {
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
      trailing: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey[300],
        child: Text(
          count,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {},
    );
  }
}