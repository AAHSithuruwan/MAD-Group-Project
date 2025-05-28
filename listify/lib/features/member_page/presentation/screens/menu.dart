import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 25, color: Colors.black),
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
                  backgroundImage: AssetImage("assets/images/Ellipse 30.png"),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hiruni Ishara", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("hiruniishara@gmail.com", style: TextStyle(color: Colors.black)),
                  ],
                )
              ],
            ),
          ),

          // Firestore Menu List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data?.docs ?? [];

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final data = items[index].data() as Map<String, dynamic>;
                    return _buildMenuItem(
                      "assets/images/${data['icon']}",
                      data['title'],
                      data['count'].toString(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom navigation + FAB (same as before)
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMenuItem(String imagePath, String title, String count) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          child: Image.asset(imagePath, width: 24, height: 24),
        ),
      ),
      title: Text(title),
      trailing: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey[300],
        child: Text(count, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
      onTap: () {},
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: BottomAppBar(
        height: 60,
        color: Colors.white,
        elevation: 0,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Image.asset("assets/images/Home.png", width: 24, height: 24, color: Colors.grey[600]), onPressed: () {}),
            IconButton(icon: Image.asset("assets/images/Notification.png", width: 24, height: 24, color: Colors.grey[600]), onPressed: () {}),
            SizedBox(width: 24),
            IconButton(icon: Image.asset("assets/images/Buy.png", width: 24, height: 24, color: Colors.grey[600]), onPressed: () {}),
            Container(
              decoration: BoxDecoration(color: const Color(0x201BA424), shape: BoxShape.circle),
              child: IconButton(
                icon: Image.asset("assets/images/Menu.png", width: 24, height: 24, color: Colors.grey[600]),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF1BA424), width: 2.5),
      ),
      child: Icon(Icons.add, size: 30, color: Color(0xFF1BA424)),
    );
  }
}
