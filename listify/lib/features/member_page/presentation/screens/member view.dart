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
      home: MembersPage(),
    );
  }
}

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample member data
    final List<Map<String, String>> members = [
      {
        "name": "Hiruni Ishara",
        "email": "hiruniishara@gmail.com",
        "role": "Admin",
      },
      {
        "name": "Sanduni Perera",
        "email": "sanduni@gmail.com",
        "role": "Admin",
      },
      {
        "name": "Kasun Thiwanka",
        "email": "kasun@gmail.com",
        "role": "Viewer",
      },
      {
        "name": "Dewmini Mendis",
        "email": "dewmini@gmail.com",
        "role": "Viewer",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Members",
          style: TextStyle(
            color: Color(0xFF0A3B0D),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {},
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return buildMemberListItem(
            name: member["name"]!,
            email: member["email"]!,
            role: member["role"]!,
            index: index,
          );
        },
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

  Widget buildMemberListItem({
    required String name,
    required String email,
    required String role,
    required int index,
  }) {
    // List of placeholder avatar images
    List<String> avatarAssets = [
      "assets/Ellipse 30.png",
      "assets/Ellipse 31 (1).png",
      "assets/Ellipse 31.png",
      "assets/Ellipse 28.png",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: index < avatarAssets.length
                ? AssetImage(avatarAssets[index])
                : null,
            child: index < avatarAssets.length
                ? null // Don't show the fallback icon when we have an image
                : Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey[600],
                  ),
          ),

          const SizedBox(width: 16),

          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424141),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF424141),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF424141),
                  ),
                ),
              ],
            ),
          ),

          // Three-dot menu
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
