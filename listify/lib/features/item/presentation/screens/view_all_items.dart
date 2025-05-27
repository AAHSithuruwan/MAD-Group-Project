import 'package:flutter/material.dart';
import 'package:listify/core/services/Item_service.dart';
import 'package:listify/core/Models/Item.dart';
import 'package:listify/features/item/presentation/screens/item_detail_screen.dart';

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
                            // fontWeight: FontWeight.bold,
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
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = selectedItemIds.contains(item.docId);

                        return GestureDetector(
                          // onTap: () {
                          //   // Navigate to details page
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder:
                          //           (context) => ItemDetailScreen(item: item),
                          //     ),
                          //   );
                          // },
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
                              vertical: 8,
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
                      },
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
                backgroundColor: Color(0xFF106A16),
                foregroundColor: Colors.white,
                onPressed: () async {
                  for (final id in selectedItemIds) {
                    await itemService.deleteUserItem(id);
                  }
                  setState(() {
                    _itemsFuture = itemService.getAllUserItems();
                    selectedItemIds.clear();
                  });
                },
                child: const Icon(Icons.delete),
              )
              : null,
    );
  }
}
