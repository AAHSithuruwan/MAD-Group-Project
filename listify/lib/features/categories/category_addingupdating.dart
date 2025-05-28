import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listify/features/categories/category_view.dart';
import 'package:listify/features/menu/presentation/screens/menu_screen.dart';

class Categoryaddup extends StatelessWidget {
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
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    var snapshot = await FirebaseFirestore.instance.collection('categories').get();
    List<Map<String, dynamic>> fetched = snapshot.docs
        .map((doc) => {'id': doc.id, 'name': doc['name']})
        .toList();

    setState(() {
      categories = fetched;
    });
  }

  Future<void> addCategory() async {
    String? newCategory = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text("Add New Category"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter category name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text("Add"),
            ),
          ],
        );
      },
    );

    if (newCategory != null && newCategory.trim().isNotEmpty) {
      var docRef = await FirebaseFirestore.instance.collection('categories').add({
        'name': newCategory.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        categories.add({'id': docRef.id, 'name': newCategory.trim()});
      });
    }
  }

  Future<void> updateCategory(String docId, String currentName, int index) async {
    TextEditingController controller = TextEditingController(text: currentName);

    String? updatedName = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Category"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text("Update"),
            ),
          ],
        );
      },
    );

    if (updatedName != null && updatedName.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('categories').doc(docId).update({
        'name': updatedName.trim(),
      });

      setState(() {
        categories[index]['name'] = updatedName.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF1BA424),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesView()));
          },
        ),
        title: Center(
          child: Text(
            'Category adding, Viewing,\nupdating',
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: addCategory,
              icon: Icon(Icons.add_circle_outline),
              label: Text("Add Categories"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5FFF5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                ),
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    String name = categories[index]['name'];
                    String id = categories[index]['id'];

                    return Column(
                      children: [
                        ListTile(
                          title: Text(name),
                          trailing: ElevatedButton(
                            onPressed: () => updateCategory(id, name, index),
                            child: Text("Update"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: Size(20, 30),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        if (index < categories.length - 1)
                          Divider(thickness: 1, indent: 10, endIndent: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
