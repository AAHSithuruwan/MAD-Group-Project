import 'package:flutter/material.dart';

class QuantitySelection extends StatefulWidget {
  const QuantitySelection({Key? key}) : super(key: key);

  @override
  _QuantitySelectionState createState() => _QuantitySelectionState();
}

class _QuantitySelectionState extends State<QuantitySelection> {
  final TextEditingController quantityController = TextEditingController();

  String? selectedMetric; // State variable for the selected metric
  final List<String> metrics = ["kg", "g", " packet"]; // Available metrics

  @override
  void initState() {
    super.initState();
    selectedMetric =
        metrics.first; // Set the default value to the first item in the list
  }

  List<String> suggestedQuantities = [
    "1kg",
    "2kg",
    "5kg",
    "10kg",
    "200g",
    "500g",
    "100g",
    "50g",
    "1 packet",
    "2 packet"
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = 300; // Height of the image

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image at the top
                Image.asset(
                  'assets/images/quantity.png',
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
                        // Quantity selection text
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Quantity TextField
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 40,
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
                                        bottom: 10.0, left: 10.0),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            // Metric Dropdown
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 40,
                                child: Container(
                                  color: const Color(0xFFE8F6E9),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedMetric,
                                    dropdownColor: Colors.white,
                                    items: metrics.map((metric) {
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: suggestedQuantities.map((unit) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  final numericValue =
                                      unit.replaceAll(RegExp(r'[^0-9]'), '');
                                  final metricValue =
                                      unit.replaceAll(RegExp(r'[0-9]'), '');
                                  quantityController.text = numericValue;
                                  selectedMetric = metricValue;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  unit,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                    "Item Created: ${quantityController.text}");
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
                              child: const Text("Add"),
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

          // Back button
          Positioned(
            top: 25, // Adjust the position as needed
            left: 12, // Adjust the position as needed
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: Image.asset(
                'assets/images/back.png', // Replace with your back button image path
                width: 25, // Adjust the size as needed
                height: 25, // Adjust the size as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
