import 'package:flutter/material.dart';



class CategoriesViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categories = [
    "Vegetables", "Fruits", "Rice", "Snacks & Confectionery",
    "Baby Products", "Food Cupboard", "Bakery", "Dairy",
    "Frozen Food", "Desserts & Ingredients", "Sea Food",
    "Tea & Coffee", "Meats", "Cooking Essentials"
  ];

  void _addCategory() async {
    String? newCategory = await showDialog<String>(
      context: context,
      builder: (context) {
        String categoryInput = '';
        return AlertDialog(
          title: Text('Add Category'),
          content: TextField(
            onChanged: (value) {
              categoryInput = value;
            },
            decoration: InputDecoration(hintText: "Enter category name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(categoryInput),
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newCategory != null && newCategory.trim().isNotEmpty) {
      setState(() {
        categories.add(newCategory.trim());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Banner with buttons
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/category.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Close Button
                Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        print("Close button pressed");
                      },
                    ),
                  ),
                ),
                // Menu Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        print("Menu button pressed");
                      },
                    ),
                  ),
                ),
                // Edit Button
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        print("Edit image button pressed");
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Category Name Title (Tappable to add)
            GestureDetector(
              onTap: _addCategory,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      "Category name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.edit, size: 20),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Category Buttons (Non-tappable)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    return ElevatedButton(
                      onPressed: null, // Disabled
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _addCategory,
        child: Icon(Icons.add),
      ),
    );
  }
}