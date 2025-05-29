import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listify/core/Models/ListifyCategory.dart';
import 'package:listify/features/categories/categories_view.dart';
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
  List<ListifyCategory> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    var snapshot = await FirebaseFirestore.instance.collection('ListifyCategories').get();
    List<ListifyCategory> fetched = snapshot.docs
        .map((doc) => ListifyCategory.fromDoc(doc))
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
    //  Create doc reference to get ID before saving
    final docRef = FirebaseFirestore.instance.collection("ListifyCategories").doc();

    // Include the generated doc ID in the object
    final category = ListifyCategory(docId: docRef.id, name: newCategory.trim());

    //  Convert to map and add docId manually to Firestore
    final data = category.toMap();
    data['docId'] = docRef.id; // this saves the docId inside Firestore

    await docRef.set(data); // set instead of add

    // Add to local state
    setState(() {
      categories.add(category);
    });
  }
}


  Future<void> updateCategory(ListifyCategory category, int index) async {
    TextEditingController controller = TextEditingController(text: category.name);

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
      await FirebaseFirestore.instance
          .collection("ListifyCategories")
          .doc(category.docId)
          .update({'name': updatedName.trim()});

      setState(() {
        categories[index] = ListifyCategory(docId: category.docId, name: updatedName.trim());
      });
    }
  }

  Future<void> deleteCategory(String docId, int index) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Category"),
        content: Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection("ListifyCategories").doc(docId).delete();
      setState(() {
        categories.removeAt(index);
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesViewPage()));
            },// Back to previous screen
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
                    final category = categories[index];

                    return Column(
                      children: [
                        ListTile(
                          title: Text(category.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () => updateCategory(category, index),
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
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => deleteCategory(category.docId!, index),
                                child: Icon(Icons.delete, size: 18),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: Size(20, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
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
