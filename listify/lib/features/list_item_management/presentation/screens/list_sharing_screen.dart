import 'package:flutter/material.dart';
import 'package:listify/core/services/listify_list_service.dart';

class ListSharingScreen extends StatefulWidget {
  final String listId;
  final String? listName;
  const ListSharingScreen({Key? key, required this.listId, this.listName})
      : super(key: key);

  @override
  State<ListSharingScreen> createState() => _ListSharingScreenState();
}

class _ListSharingScreenState extends State<ListSharingScreen> {
  final ListifyListService _listService = ListifyListService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  List<Map<String, dynamic>> _members = [];
  String _searchText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
    _fetchAllUsers();
    _fetchMembers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllUsers() async {
    final users = await _listService.getAllUsers();
    setState(() {
      _allUsers = users;
      _filteredUsers = users;
    });
  }

  Future<void> _fetchMembers() async {
    setState(() => _isLoading = true);
    final members = await _listService.getListMembers(widget.listId);
    setState(() {
      _members = members;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
      _filteredUsers = _allUsers
          .where((user) => user['email']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showRoleDialogAndAddMember(Map<String, dynamic> user) async {
    String selectedRole = 'viewer';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Role for ${user['email']}'),
        content: DropdownButton<String>(
          value: selectedRole,
          items: const [
            DropdownMenuItem(
              value: 'viewer',
              child: Text('Viewer'),
            ),
            DropdownMenuItem(
              value: 'editor',
              child: Text('Editor'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedRole = value;
              });
              Navigator.of(context).pop(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(selectedRole),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      await _addMember(user['userId'], result);
    }
  }

  Future<void> _addMember(String userId, String role) async {
    await _listService.addMemberToList(widget.listId, userId, role);
    await _fetchMembers();
    setState(() {
      _searchText = '';
      _searchController.clear();
      _filteredUsers = _allUsers;
    });
  }

  Future<void> _changeRole(String userId, String newRole) async {
    await _listService.changeMemberRole(widget.listId, userId, newRole);
    await _fetchMembers();
  }

  Future<void> _removeMember(String userId) async {
    await _listService.removeMemberFromList(widget.listId, userId);
    await _fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share List'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search users by email',
                    prefixIcon: Icon(Icons.search),
                  ),
                  controller: _searchController,
                ),
                if (_searchText.isNotEmpty && _filteredUsers.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return ListTile(
                          title: Text(user['email']),
                          onTap: () {
                            _showRoleDialogAndAddMember(user);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          // Members List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
                      final member = _members[index];
                      // Skip rendering if the member's role is 'owner'
                      if (member['role'] == 'owner') {
                        return const SizedBox.shrink();
                      }
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(member['email'] ?? 'No email'),
                          subtitle: Text('Role: ${member['role']}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'change_role') {
                                final newRole = member['role'] == 'editor'
                                    ? 'viewer'
                                    : 'editor';
                                _changeRole(member['userId'], newRole);
                              } else if (value == 'remove') {
                                _removeMember(member['userId']);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'change_role',
                                child: Text(
                                  member['role'] == 'editor'
                                      ? 'Change to Viewer'
                                      : 'Change to Editor',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Text('Remove Member'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}