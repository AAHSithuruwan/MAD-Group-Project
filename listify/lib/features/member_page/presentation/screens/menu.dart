import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SidebarMenu(),
    );
  }
}

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Optional: Removes shadow
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0), // Adjust left spacing
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ),
      ),

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
                  _buildMenuItem("assets/Carrot.png", "Items", "10"),
                  _buildMenuItem("assets/Account.png", "Account", "5"),
                  _buildMenuItem("assets/Categorize.png", "Categories", "5"),
                  _buildMenuItem("assets/To Do List.png", "Lists", "4"),
                  _buildMenuItem("assets/Graph.png", "History", "5"),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
        ),
        child: BottomAppBar(
          height: 60,
          color: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home icon
              IconButton(
                icon: Image.asset(
                  "assets/Home.png",
                  width: 24,
                  height: 24,
                  color: Colors.grey[600],
                ),
                onPressed: () {},
              ),
              
              // Notification/Bell icon
              IconButton(
                icon: Image.asset(
                  "assets/Notification.png",
                  width: 24,
                  height: 24,
                  color: Colors.grey[600],
                ),
                onPressed: () {},
              ),
              
              // Empty space for center button
              SizedBox(width: 24),
              
              // Cart icon
              IconButton(
                icon: Image.asset(
                  "assets/Buy.png",
                  width: 24,
                  height: 24,
                  color: Colors.grey[600],
                ),
                onPressed: () {},
              ),
              
              // Menu icon with light green background
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x201BA424),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Image.asset(
                    "assets/Menu.png",
                    width: 24,
                    height: 24,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Add floating action button in center
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFF1BA424), width: 2.5),
        ),
        child: Icon(
          Icons.add,
          size: 30,
          color: Color(0xFF1BA424),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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