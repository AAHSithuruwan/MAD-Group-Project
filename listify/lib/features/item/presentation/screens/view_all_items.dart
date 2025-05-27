import 'package:flutter/material.dart';
import 'package:listify/core/services/Item_service.dart';
import 'package:listify/core/Models/Item.dart';
import 'package:listify/features/item/presentation/screens/item_details_screen.dart';

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
      body: Stack(
        children: [
          Column(
            children: [
              // Custom AppBar
              Container(
                height: kToolbarHeight + 20,
                color: Colors.white,
                child: Stack(
                  children: [
                    // Back button
                    Positioned(
                      top: 25,
                      left: 12,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/images/back.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                    // Centered title
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          'My Items',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // List of items
              Expanded(
                child: FutureBuilder<List<Item>>(
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
                      return const Center(child: Text('No items found.'));
                    }

                    final Map<String, List<Item>> itemsByCategory = {};
                    for (final item in items) {
                      itemsByCategory
                          .putIfAbsent(item.categoryName, () => [])
                          .add(item);
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
                                  final isSelected = selectedItemIds.contains(
                                    item.docId,
                                  );
                                  return GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  ItemDetailsScreen(item: item),
                                        ),
                                      );
                                      if (result != null) {
                                        // Item was updated, so refresh the list
                                        setState(() {
                                          _itemsFuture =
                                              itemService.getAllUserItems();
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.08,
                                              ),
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
                                                  color: Color.fromARGB(
                                                    255,
                                                    30,
                                                    55,
                                                    30,
                                                  ),
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
              ),
            ],
          ),
        ],
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
