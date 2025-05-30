import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/services/listify_list_service.dart';
import '../../../../core/Models/Item.dart';
import '../../../../core/Models/ListItem.dart';

class QuantityUpdate extends StatefulWidget {

  final String listId;
  final ListItem listItem;

  const QuantityUpdate({super.key, required this.listItem, required this.listId});

  @override
  _QuantityUpdateState createState() => _QuantityUpdateState();
}

class _QuantityUpdateState extends State<QuantityUpdate> {
  final TextEditingController quantityController = TextEditingController();
  ListifyListService listifyListService = ListifyListService();

  String? selectedMetric; // State variable for the selected metric
  final List<String> metrics = ["kg", "g", "mg", "l", "ml", "packet", "unit"]; // Available metrics

  @override
  void initState() {
    super.initState();
    final numericValue = widget.listItem.quantity.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final metricValue = widget.listItem.quantity.replaceAll(
      RegExp(r'[0-9]'),
      '',
    );
    quantityController.text = numericValue;
    selectedMetric =
        metricValue;
  }

  @override
  Widget build(BuildContext context) {
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
                  'assets/images/quantity.png',
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),

                // Back button
                Positioned(
                  top: 50,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );// Navigate back to the previous screen
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
                    // Quantity selection text
                    const Text(
                      "Quantity",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Quantity TextField
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 35,
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
                                controller: quantityController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7.0),
                                      bottomLeft: Radius.circular(7.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7.0),
                                      bottomLeft: Radius.circular(7.0),
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
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),

                        // Metric Dropdown
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 35,
                            child: Container(
                              color: const Color(0xFFE8F6E9),
                              child: DropdownButtonFormField<String>(
                                value: selectedMetric,
                                dropdownColor: Colors.white,
                                items:
                                metrics.map((metric) {
                                  return DropdownMenuItem<String>(
                                    value: metric,
                                    child: Text(
                                      metric,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF106A16),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMetric = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(7.0),
                                      bottomRight: Radius.circular(7.0),
                                    ),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF106A16),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(7.0),
                                      bottomRight: Radius.circular(7.0),
                                    ),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF106A16),
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () async {
                            if(quantityController.text == ''){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text('Please Select a Quantity')),
                                  duration: Duration(seconds: 2), // Optional
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,// Optional
                                ),
                              );
                            }
                            else{
                              print("${quantityController.text}$selectedMetric");
                              String message = "Quantity Updating Unsuccessful";
                              if(await listifyListService.updateListItemQuantity(widget.listItem, widget.listId, "${quantityController.text}$selectedMetric")){
                                message = "Quantity Updated Successfully";
                              }
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(message)),
                                  duration: Duration(seconds: 2), // Optional
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,// Optional
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF106A16),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 14),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text("Update"),
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