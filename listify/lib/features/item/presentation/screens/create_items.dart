import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listify/core/Models/Item_model.dart';
import 'package:listify/core/services/Item_service.dart';

class CreateItems extends StatefulWidget {
  const CreateItems({Key? key}) : super(key: key);

  @override
  State<CreateItems> createState() => _CreateItemsState();
}

class _CreateItemsState extends State<CreateItems> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final ItemService itemService = ItemService();

  List<String> suggestedUnits = ["kg/g/packet", "l/ml/bottle", "piece"];
  List<String> storeNames = ["Store A", "Store B", "Store C"];
  List<String> categoryNames = ["Category A", "Category B", "Category C"];
  List<String> addedUnits = [];
  List<String> addedStores = [];
  List<String> addedCategories = [];

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
            Stack(
              children: [
                Image.asset(
                  'assets/images/createItem.PNG',
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),

                // Back button
                Positioned(
                  top: 25,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      ); // Navigate back to the previous screen
                    },
                    child: Image.asset(
                      'assets/images/back.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              ],
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 37,
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: const Color(0xFF106A16), // Cursor color
                          selectionColor: const Color(
                            0xFFB2D8B2,
                          ), // Highlight color for selected text
                          selectionHandleColor: const Color(
                            0xFF106A16,
                          ), // Handle color for text selection
                        ),
                        child: TextField(
                          controller: itemNameController,
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

                    const SizedBox(height: 20),

                    // Category Name Field with Dropdown
                    const Text(
                      "Category Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 37,
                            child: DropdownButtonFormField<String>(
                              value:
                                  categoryNames.contains(
                                        categoryNameController.text,
                                      )
                                      ? categoryNameController.text
                                      : null,
                              dropdownColor:
                                  Colors
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
                                                      ), // Cursor color
                                                      selectionColor:
                                                          const Color(
                                                            0xFFB2D8B2,
                                                          ), // Highlight color
                                                      selectionHandleColor:
                                                          const Color(
                                                            0xFF106A16,
                                                          ), // Handle color
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
                                                        labelText:
                                                            "Category Name",
                                                        labelStyle: TextStyle(
                                                          color: Color.fromARGB(
                                                            255,
                                                            112,
                                                            113,
                                                            112,
                                                          ),
                                                          fontSize: 16,
                                                        ),
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                              color:
                                                                  Color.fromARGB(
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
                                                                Radius.circular(
                                                                  10.0,
                                                                ),
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
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
                                                              borderSide:
                                                                  BorderSide(
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
                                                    backgroundColor:
                                                        const Color(0xFFE8F6E9),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(); // Close the dialog
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
                                                    backgroundColor:
                                                        const Color(0xFFE8F6E9),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (newCategoryName
                                                        .isNotEmpty) {
                                                      setState(() {
                                                        categoryNames.add(
                                                          newCategoryName,
                                                        ); // Add new category
                                                        categoryNameController
                                                                .text =
                                                            newCategoryName; // Update the TextField
                                                        addedCategories.add(
                                                          "$newCategoryName",
                                                        );
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
                                    categoryNameController.text =
                                        value; // Update the TextField
                                  });
                                }
                              },
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
                        SizedBox(
                          height: 37,
                          child: ElevatedButton(
                            onPressed: () {
                              if (categoryNameController.text.isNotEmpty) {
                                setState(() {
                                  categoryNames.add(
                                    categoryNameController.text,
                                  );
                                  categoryNameController.clear();
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
                            child: const Text(
                              "Add",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Unit Field with Suggestions
                    const Text(
                      "Unit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 37,
                            child: TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: const Color(
                                  0xFF106A16,
                                ), // Cursor color
                                selectionColor: const Color(
                                  0xFFB2D8B2,
                                ), // Highlight color for selected text
                                selectionHandleColor: const Color(
                                  0xFF106A16,
                                ), // Handle color for text selection
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
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0, // Space between rows
                      children:
                          suggestedUnits.map((unit) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  unitController.text =
                                      unit; // Set the unit in the text field
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  unit,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Store Name Field with Dropdown
                    const Text(
                      "Store Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 37,
                            child: DropdownButtonFormField<String>(
                              value:
                                  storeNames.contains(storeNameController.text)
                                      ? storeNameController.text
                                      : null,
                              dropdownColor:
                                  Colors
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
                                            backgroundColor: Colors.white,
                                            title: Center(
                                              child: const Text(
                                                "Add New Store",
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
                                                      ), // Cursor color
                                                      selectionColor:
                                                          const Color(
                                                            0xFFB2D8B2,
                                                          ), // Highlight color
                                                      selectionHandleColor:
                                                          const Color(
                                                            0xFF106A16,
                                                          ), // Handle color
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
                                                        newStoreName = text;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: "Store Name",
                                                        labelStyle: TextStyle(
                                                          color: Color.fromARGB(
                                                            255,
                                                            112,
                                                            113,
                                                            112,
                                                          ),
                                                          fontSize: 16,
                                                        ),
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                              color:
                                                                  Color.fromARGB(
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
                                                                Radius.circular(
                                                                  10.0,
                                                                ),
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
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
                                                              borderSide:
                                                                  BorderSide(
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
                                                SizedBox(
                                                  height: 37,
                                                  child: TextSelectionTheme(
                                                    data: TextSelectionThemeData(
                                                      cursorColor: const Color(
                                                        0xFF106A16,
                                                      ), // Cursor color
                                                      selectionColor:
                                                          const Color(
                                                            0xFFB2D8B2,
                                                          ), // Highlight color
                                                      selectionHandleColor:
                                                          const Color(
                                                            0xFF106A16,
                                                          ), // Handle color
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
                                                        newStoreLocation = text;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: "Location",
                                                        labelStyle: TextStyle(
                                                          color: Color.fromARGB(
                                                            255,
                                                            112,
                                                            113,
                                                            112,
                                                          ),
                                                          fontSize: 16,
                                                        ),
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                              color:
                                                                  Color.fromARGB(
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
                                                                Radius.circular(
                                                                  10.0,
                                                                ),
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
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
                                                              borderSide:
                                                                  BorderSide(
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
                                              ],
                                            ),
                                            actions: [
                                              SizedBox(
                                                height: 33,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFE8F6E9),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(); // Close the dialog
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
                                                    backgroundColor:
                                                        const Color(0xFFE8F6E9),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (newStoreName
                                                            .isNotEmpty &&
                                                        newStoreLocation
                                                            .isNotEmpty) {
                                                      setState(() {
                                                        storeNames.add(
                                                          newStoreName,
                                                        ); // Add new store
                                                        storeNameController
                                                                .text =
                                                            newStoreName; // Update the TextField
                                                        addedStores.add(
                                                          "$newStoreName - $newStoreLocation",
                                                        );
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
                                ...storeNames.map(
                                  (store) => DropdownMenuItem(
                                    value: store,
                                    child: Text(
                                      store,
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
                                    storeNameController.text =
                                        value; // Update the TextField
                                  });
                                }
                              },
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
                        SizedBox(
                          height: 37,
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
                            child: const Text(
                              "Add",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Create Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 37,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (itemNameController.text.isEmpty ||
                                categoryNameController.text.isEmpty ||
                                (addedUnits.isEmpty &&
                                    unitController.text.isEmpty) ||
                                storeNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill all required fields',
                                  ),
                                ),
                              );
                              return;
                            }

                            // Add last unit if not already added
                            if (unitController.text.isNotEmpty) {
                              addedUnits.add(unitController.text);
                            }

                            final item = Item(
                              docId: null,
                              name: itemNameController.text,
                              units: addedUnits,
                              categoryName: categoryNameController.text,
                              storeName: storeNameController.text,
                            );

                            try {
                              await itemService.addItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Item added successfully!'),
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to add item: $e'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF106A16),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
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
