import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listify/core/services/listify_list_service.dart';

class ListSharingScreen extends StatefulWidget {
  final String? listId;
  final String? listName;

  const ListSharingScreen({super.key, this.listId, this.listName});

  @override
  State<ListSharingScreen> createState() => _ListSharingScreenState();
}

class SharedUser {
  final String userId;
  final String username;
  final String email;
  String role;

  SharedUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
  });
}

class AppUser {
  final String userId;
  final String username;
  final String email;

  AppUser({
    required this.userId,
    required this.username,
    required this.email,
  });
}

class _ListSharingScreenState extends State<ListSharingScreen> {
  final ListifyListService _listService = ListifyListService();
  String searchQuery = '';
  List<SharedUser> sharedUsers = [];
  List<AppUser> allUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllUsersAndMembers();
  }

  Future<void> _fetchAllUsersAndMembers() async {
    setState(() {
      isLoading = true;
    });

    // Fetch all users (for search)
    final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    allUsers = usersSnapshot.docs
        .map((doc) => AppUser(
              userId: doc.id,
              username: doc['username'] ?? '',
              email: doc['email'] ?? '',
            ))
        .toList();

    // Fetch shared users (members) for this list using the service
    sharedUsers = [];
    if (widget.listId != null) {
      final memberMaps = await _listService.getListMembers(widget.listId!);
      sharedUsers = memberMaps.map((member) {
        final userId = member['userId'] ?? '';
        final role = member['role'] ?? 'viewer';
        final username = member['username'] ?? 'Unknown';
        final email = member['email'] ?? 'No email';
        return SharedUser(
          userId: userId,
          username: username,
          email: email,
          role: _capitalize(role),
        );
      }).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  List<AppUser> get filteredUsers {
    final sharedIds = sharedUsers.map((u) => u.userId).toSet();
    return allUsers
        .where((user) =>
            !sharedIds.contains(user.userId) &&
            (user.username.toLowerCase().contains(searchQuery.toLowerCase()) ||
                user.email.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();
  }

  Future<void> _changeRole(SharedUser user, String newRole) async {
    if (widget.listId == null) return;
    await _listService.changeMemberRole(widget.listId!, user.userId, newRole.toLowerCase());
    await _fetchAllUsersAndMembers();
  }

  Future<void> _deleteUser(SharedUser user) async {
    if (widget.listId == null) return;
    await _listService.removeMemberFromList(widget.listId!, user.userId);
    await _fetchAllUsersAndMembers();
  }

  Future<void> _addSharedUser(AppUser user) async {
    String? selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select Role for ${user.username}'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Editor'),
            child: Text('Editor'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Viewer'),
            child: Text('Viewer'),
          ),
        ],
      ),
    );
    if (selectedRole != null && widget.listId != null) {
      await _listService.addMemberToList(widget.listId!, user.userId, selectedRole.toLowerCase());
      await _fetchAllUsersAndMembers();
      setState(() {
        searchQuery = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text('List Sharing'))),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _SearchBar(),
                      if (searchQuery.isNotEmpty && filteredUsers.isNotEmpty)
                        Column(
                          children: [
                            ...filteredUsers.map(
                              (user) => SearchUserCard(
                                user: user,
                                onTap: () => _addSharedUser(user),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      SizedBox(height: 10),
                      ...sharedUsers.map((user) => SharedUserCard(
                            user: user,
                            onChangeRole: (role) => _changeRole(user, role),
                            onDelete: () => _deleteUser(user),
                          )),
                      SizedBox(height: 20),
                      if (sharedUsers.isEmpty)
                        Text('No users shared with this list.'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _SearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search members to share with',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class SearchUserCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;

  const SearchUserCard({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(Icons.person_add),
        title: Text(user.username),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}

class SharedUserCard extends StatelessWidget {
  final SharedUser user;
  final void Function(String) onChangeRole;
  final VoidCallback onDelete;

  const SharedUserCard({
    super.key,
    required this.user,
    required this.onChangeRole,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(user.username),
        subtitle: Text(user.email),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Delete') {
              onDelete();
            } else {
              onChangeRole(value);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: user.role == 'Editor' ? 'Viewer' : 'Editor',
              child: Text('Change to ${user.role == 'Editor' ? 'Viewer' : 'Editor'}'),
            ),
            PopupMenuItem(
              value: 'Delete',
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.role,
                style: TextStyle(
                  color: user.role == 'Editor' ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.more_vert),
            ],
          ),
        ),
      ),
    );
  }
}

String _capitalize(String s) =>
    s.isNotEmpty ? s[0].toUpperCase() + s.substring(1).toLowerCase() : s;