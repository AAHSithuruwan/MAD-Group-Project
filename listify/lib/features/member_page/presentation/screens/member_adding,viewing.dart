import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Members Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const MembersScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Member {
  final String name;
  final String email;
  final String role;
  final String avatarAsset;

  Member({
    required this.name,
    required this.email,
    required this.role,
    required this.avatarAsset,
  });
}

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final List<Member> _members = [
    Member(
      name: 'Hiruni Ishara',
      email: 'hiruniishara@gmail.com',
      role: 'Admin',
      avatarAsset: 'assets/Ellipse 30.png',
    ),
    Member(
      name: 'Sanduni Perera',
      email: 'sanduni@gmail.com',
      role: 'Admin',
      avatarAsset: 'assets/Ellipse 31 (1).png',
    ),
    Member(
      name: 'Kasun Thiwanka',
      email: 'kasun@gmail.com',
      role: 'Viewer',
      avatarAsset: 'assets/Ellipse 31.png',
    ),
    Member(
      name: 'Dewmini Mendis',
      email: 'dewmini@gmail.com',
      role: 'Viewer',
      avatarAsset: 'assets/Ellipse 28.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildMembersList()),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1BA424), width: 2.5),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, size: 30, color: Color(0xFF1BA424)),
          onPressed: _showAddMemberDialog,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Back button pressed')),
              );
            },
          ),
          const Expanded(
            child: Text(
              'Members',
              textAlign: TextAlign.center, // Center the text
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0A3B0D),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(member.avatarAsset),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF424141),
                            )),
                        const SizedBox(height: 2),
                        Text(member.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF424141),
                            )),
                        const SizedBox(height: 2),
                        Text(member.role,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF424141),
                            )),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    offset: const Offset(0, 40),
                    color: Colors.white,
                    onSelected: (value) => _handleMenuAction(value, member),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'make_viewer',
                        child:
                            Text('Make viewer', style: TextStyle(fontSize: 14)),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
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
    );
  }

  void _handleMenuAction(String action, Member member) {
    switch (action) {
      case 'make_viewer':
        setState(() {
          // just simulate role change
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${member.name} is now a viewer')),
        );
        break;
      case 'remove':
        setState(() {
          _members.removeWhere((m) => m.email == member.email);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${member.name} has been removed')),
        );
        break;
    }
  }

  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String role = 'Viewer';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Viewer', child: Text('Viewer')),
                ],
                onChanged: (value) => role = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                setState(() {
                  _members.add(Member(
                    name: nameController.text,
                    email: emailController.text,
                    role: role,
                    avatarAsset: 'assets/Ellipse 28.png',
                  ));
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('${nameController.text} has been added')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
