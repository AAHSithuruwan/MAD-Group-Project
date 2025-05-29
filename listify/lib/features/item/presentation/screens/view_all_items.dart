import 'package:flutter/material.dart';
import 'package:listify/core/services/Item_service.dart';
import 'package:listify/core/Models/Item.dart';
import 'package:listify/features/item/presentation/screens/item_details_screen.dart';
import 'package:go_router/go_router.dart';

class ViewAllItemsScreen extends StatefulWidget {
  const ViewAllItemsScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllItemsScreen> createState() => _UserItemsPageState();
}

class _UserItemsPageState extends State<ViewAllItemsScreen> {
  final ItemService itemService = ItemService();
  late Future<List<Item>> _itemsFuture;

  Set<String> selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    _itemsFuture = itemService.getAllUserItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Items'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/back.png', width: 22, height: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Tooltip(
              message: 'Create Item',
              child: IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                  size: 26,
                ),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return const Color.fromARGB(255, 120, 219, 120);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return const Color.fromARGB(255, 228, 241, 231);
                    }
                    return null;
                  }),
                ),
                onPressed: null,
              ),
            ),
            onSelected: (value) async {
              if (value == 0) {
                final result = await context.push('/create_items_user');
                if (result == true) {
                  setState(() {
                    _itemsFuture = itemService.getAllUserItems();
                  });
                }
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                        style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color.fromARGB(255, 162, 216, 162);
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return const Color.fromARGB(255, 228, 241, 231);
                              }
                              return null;
                            },
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context); // Close the menu
                          final result = await context.push(
                            '/create_items_user',
                          );
                          if (result == true) {
                            setState(() {
                              _itemsFuture = itemService.getAllUserItems();
                            });
                          }
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Create Item',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),

      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No items found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await context.push('/create_items_user');
                      if (result == true) {
                        setState(() {
                          _itemsFuture = itemService.getAllUserItems();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F6E9),
                      foregroundColor: const Color(0xFF106A16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF106A16),
                        width: 1,
                      ),
                    ),
                    child: const Text('Create Item'),
                  ),
                ],
              ),
            );
          }

          final Map<String, List<Item>> itemsByCategory = {};
          for (final item in items) {
            itemsByCategory.putIfAbsent(item.categoryName, () => []).add(item);
          }
          return ListView(
            children:
                itemsByCategory.entries.map((entry) {
                  final category = entry.key;
                  final categoryItems = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ...categoryItems.map((item) {
                        final isSelected = selectedItemIds.contains(item.docId);
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ItemDetailsScreen(item: item),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _itemsFuture = itemService.getAllUserItems();
                              });
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              if (isSelected) {
                                selectedItemIds.remove(item.docId);
                              } else {
                                selectedItemIds.add(item.docId!);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFE8F6E9)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFF106A16)
                                          : const Color(
                                            0xFF1BA424,
                                          ).withOpacity(0.15),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 30, 55, 30),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF106A16),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
          );
        },
      ),
      floatingActionButton:
          selectedItemIds.isNotEmpty
              ? FloatingActionButton(
                backgroundColor: const Color(0xFF106A16),
                foregroundColor: Colors.white,
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Delete Items'),
                          content: const Text(
                            'Are you sure you want to delete the selected items?',
                          ),
                          actions: [
                            SizedBox(
                              height: 33,
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  overlayColor: WidgetStateProperty.resolveWith<
                                    Color?
                                  >((states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(
                                        0xFFB2D8B2,
                                      ); // pressed color
                                    }
                                    if (states.contains(WidgetState.hovered)) {
                                      return const Color(
                                        0xFFD6F5DD,
                                      ); // hover color
                                    }
                                    return null;
                                  }),
                                ),
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF106A16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 33,
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  overlayColor: WidgetStateProperty.resolveWith<
                                    Color?
                                  >((states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(
                                        0xFFB2D8B2,
                                      ); // pressed color
                                    }
                                    if (states.contains(WidgetState.hovered)) {
                                      return const Color(
                                        0xFFD6F5DD,
                                      ); // hover color
                                    }
                                    return null;
                                  }),
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    for (final id in selectedItemIds) {
                      await itemService.deleteUserItem(id);
                    }
                    setState(() {
                      _itemsFuture = itemService.getAllUserItems();
                      selectedItemIds.clear();
                    });
                  }
                },
                child: const Icon(Icons.delete),
              )
              : null,
    );
  }
}
