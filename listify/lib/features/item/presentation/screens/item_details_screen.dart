import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listify/core/Models/Item.dart';
import 'package:listify/core/services/Item_service.dart';
import 'package:listify/features/pick_location/presentation/screens/pick_location_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;
  const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController storeController;
  late TextEditingController unitController;
  late List<String> units;
  late GeoPoint? pickedLocation;
  String? pickedStoreName;

  List<String> categoryNames = [];
  bool isLoadingCategories = false;

  final ItemService itemService = ItemService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    categoryController = TextEditingController(text: widget.item.categoryName);
    storeController = TextEditingController(text: widget.item.storeName);
    unitController = TextEditingController();
    units = List<String>.from(widget.item.units);
    pickedLocation = widget.item.location;
    pickedStoreName = widget.item.storeName;
    fetchCategories();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    storeController.dispose();
    unitController.dispose();
    super.dispose();
  }

  Future<void> updateItem() async {
    final updatedItem = Item(
      docId: widget.item.docId,
      name: nameController.text,
      units: units,
      categoryName: categoryController.text,
      storeName: pickedStoreName ?? '',
      location: pickedLocation,
      isUserSpecificItem: true,
    );
    await itemService.updateUserItem(updatedItem);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item updated!')));
    Navigator.pop(context, updatedItem);
  }

  Future<void> deleteItem() async {
    await itemService.deleteUserItem(widget.item.docId!);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item deleted!')));
    Navigator.pop(context, null);
  }

  Future<void> fetchCategories() async {
    setState(() => isLoadingCategories = true);
    final snapshot =
        await FirebaseFirestore.instance.collection('ListifyCategories').get();
    setState(() {
      categoryNames =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      isLoadingCategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Item Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return const Color(0xFFB2D8B2); // pressed color
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color(0xFFD6F5DD); // hover color
                }
                return null;
              }),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Delete Item'),
                      content: const Text(
                        'Are you sure you want to delete this item?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
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
                                return const Color(0xFFB2D8B2); // pressed color
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return const Color(0xFFD6F5DD); // hover color
                              }
                              return null;
                            }),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF106A16)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
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
                                return const Color(0xFFB2D8B2); // pressed color
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return const Color(0xFFD6F5DD); // hover color
                              }
                              return null;
                            }),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                await deleteItem();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Name Field
              const Text(
                "Item Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 37,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: const Color(0xFF106A16),
                    selectionColor: const Color(0xFFB2D8B2),
                    selectionHandleColor: const Color(0xFF106A16),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(
                          color: Color(0xFF106A16),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                    ),
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Name Field with Dropdown
              const Text(
                "Category Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 37,
                      child: DropdownButtonFormField<String>(
                        value:
                            categoryNames.contains(categoryController.text)
                                ? categoryController.text
                                : null,
                        dropdownColor: Colors.white,
                        items: [
                          // Add New button at the top of the dropdown menu
                          DropdownMenuItem(
                            enabled: false,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newCategoryName = "";
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Center(
                                        child: const Text(
                                          "Add New Category",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              2,
                                              65,
                                              7,
                                            ),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 37,
                                            child: TextSelectionTheme(
                                              data: TextSelectionThemeData(
                                                cursorColor: const Color(
                                                  0xFF106A16,
                                                ),
                                                selectionColor: const Color(
                                                  0xFFB2D8B2,
                                                ),
                                                selectionHandleColor:
                                                    const Color(0xFF106A16),
                                              ),
                                              child: TextField(
                                                cursorColor: const Color(
                                                  0xFF106A16,
                                                ),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                    255,
                                                    58,
                                                    57,
                                                    57,
                                                  ),
                                                  fontSize: 17,
                                                ),
                                                onChanged: (text) {
                                                  newCategoryName = text;
                                                },
                                                decoration: const InputDecoration(
                                                  labelText: "Category Name",
                                                  labelStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                      255,
                                                      112,
                                                      113,
                                                      112,
                                                    ),
                                                    fontSize: 16,
                                                  ),
                                                  floatingLabelStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                      255,
                                                      2,
                                                      65,
                                                      7,
                                                    ),
                                                    fontSize: 17,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                10.0,
                                                              ),
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Color(
                                                            0xFF106A16,
                                                          ),
                                                          width: 2,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                      actions: [
                                        SizedBox(
                                          height: 33,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFE8F6E9,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Cancel",
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
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFE8F6E9,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (newCategoryName.isNotEmpty) {
                                                final docRef =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                          'ListifyCategories',
                                                        )
                                                        .doc();
                                                await docRef.set({
                                                  'name': newCategoryName,
                                                  'docId': docRef.id,
                                                });

                                                setState(() {
                                                  categoryNames.add(
                                                    newCategoryName,
                                                  );
                                                  categoryController.text =
                                                      newCategoryName;
                                                });
                                              }
                                              Navigator.of(
                                                context,
                                              ).pop(); // Close the dialog
                                              Navigator.of(
                                                context,
                                              ).pop(); // Close the dropdown
                                            },
                                            child: const Text(
                                              "Add",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF106A16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  250,
                                  250,
                                  250,
                                ),
                                foregroundColor: const Color(0xFF106A16),
                              ),
                              child: const Text(
                                "+  Add New",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          // Existing dropdown items
                          ...categoryNames.map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null && value != "Add New") {
                            setState(() {
                              categoryController.text = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.0),
                            ),
                            borderSide: BorderSide(
                              color: Color(0xFF106A16),
                              width: 1,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                            bottom: 10.0,
                            left: 10.0,
                          ),
                        ),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Unit Field
              const Text(
                "Unit",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    units.map((unit) {
                      return Chip(
                        label: Text(
                          unit,
                          style: const TextStyle(color: Color(0xFF106A16)),
                        ),
                        backgroundColor: const Color(0xFFE8F6E9),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFF106A16)),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            units.remove(unit);
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 37,
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: const Color(0xFF106A16),
                          selectionColor: const Color(0xFFB2D8B2),
                          selectionHandleColor: const Color(0xFF106A16),
                        ),
                        child: TextField(
                          controller: unitController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFF106A16),
                                width: 1,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(
                              bottom: 10.0,
                              left: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 37,
                    child: ElevatedButton(
                      onPressed: () {
                        if (unitController.text.isNotEmpty &&
                            !units.contains(unitController.text)) {
                          setState(() {
                            units.add(unitController.text);
                            unitController.clear();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8F6E9),
                        foregroundColor: const Color(0xFF106A16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                          ),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF106A16),
                          width: 1,
                        ),
                      ),
                      child: const Text("Add", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Pick Location Button
              SizedBox(
                height: 37,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickLocationScreen(),
                      ),
                    );
                    if (result != null && result is Map) {
                      setState(() {
                        pickedStoreName = result['storeName'] as String?;
                        final latLng = result['latLng'];
                        if (latLng != null) {
                          pickedLocation = GeoPoint(
                            latLng.latitude,
                            latLng.longitude,
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8F6E9),
                    foregroundColor: const Color(0xFF106A16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    side: const BorderSide(color: Color(0xFF106A16), width: 1),
                  ),
                  child: const Text(
                    "Pick Location",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              if (pickedStoreName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Picked Store: $pickedStoreName',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Update Button
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 37,
                  child: ElevatedButton(
                    onPressed: updateItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF106A16),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text("Update"),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
