import 'dart:ui';

import 'package:flutter/material.dart';

class CreateItems extends StatefulWidget {
  const CreateItems({Key? key}) : super(key: key);

  @override
  State<CreateItems> createState() => _CreateItemsState();
}

class _CreateItemsState extends State<CreateItems> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();

  List<String> suggestedUnits = ["kg", "g", "liters", "pcs"];
  List<String> storeNames = ["Store A", "Store B", "Store C"];
  List<String> addedUnits = [];
  List<String> addedStores = [];

  @override
  Widget build(BuildContext context) {
    // Calculate the available height dynamically
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = 300; // Height of the image

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Image.asset(
              'assets/images/createItem.PNG',
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
            ),

            // Container wrapping the content
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                height: screenHeight + 48, // Full height minus image height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name Field
                    const Text(
                      "Item Name",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: itemNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(
                                color: Color(0xFF106A16),
                                width: 1,
                              )),
                          contentPadding:
                              EdgeInsets.only(bottom: 10.0, left: 10.0),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Unit Field with Suggestions
                    const Text(
                      "Unit",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: unitController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      bottomLeft: Radius.circular(7)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      bottomLeft: Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF106A16),
                                    width: 1,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10.0, left: 10.0),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (unitController.text.isNotEmpty) {
                                setState(() {
                                  addedUnits.add(unitController.text);
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
                            child: const Text("Add"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 0.0,
                      children: addedUnits
                          .map((unit) => Chip(
                                label: Text(unit),
                                onDeleted: () {
                                  setState(() {
                                    addedUnits.remove(unit);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Store Name Field with Dropdown
                    const Text(
                      "Store Name",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: DropdownButtonFormField<String>(
                              value:
                                  storeNames.contains(storeNameController.text)
                                      ? storeNameController.text
                                      : null,
                              dropdownColor: Colors
                                  .white, // Set the background color of the dropdown menu
                              items: [
                                // Add New button at the top of the dropdown menu
                                DropdownMenuItem(
                                  enabled:
                                      false, // Disable selection for this item
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Show a dialog to add a new store
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String newStoreName = "";
                                          String newStoreLocation = "";
                                          return AlertDialog(
                                            title: const Text("Add New Store"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  onChanged: (text) {
                                                    newStoreName = text;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Store Name",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                TextField(
                                                  onChanged: (text) {
                                                    newStoreLocation = text;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Location",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (newStoreName.isNotEmpty &&
                                                      newStoreLocation
                                                          .isNotEmpty) {
                                                    setState(() {
                                                      storeNames.add(
                                                          newStoreName); // Add new store
                                                      storeNameController.text =
                                                          newStoreName; // Update the TextField
                                                      addedStores.add(
                                                          "$newStoreName - $newStoreLocation");
                                                    });
                                                  }
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text("Add"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE8F6E9),
                                      foregroundColor: const Color(0xFF106A16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                    child: const Text("Add New"),
                                  ),
                                ),
                                // Existing dropdown items
                                ...storeNames.map((store) => DropdownMenuItem(
                                      value: store,
                                      child: Text(store),
                                    )),
                              ],
                              onChanged: (value) {
                                if (value != null && value != "Add New") {
                                  setState(() {
                                    storeNameController.text =
                                        value; // Update the TextField
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      bottomLeft: Radius.circular(7)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      bottomLeft: Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF106A16),
                                    width: 1,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10.0, left: 10.0),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (storeNameController.text.isNotEmpty) {
                                setState(() {
                                  storeNames.add(storeNameController.text);
                                  storeNameController.clear();
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
                            child: const Text("Add"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Create Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle create item logic here
                            print("Item Created: ${itemNameController.text}");
                            print("Units: $addedUnits");
                            print("Store: ${storeNameController.text}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF106A16),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text("Create"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
