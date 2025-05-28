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
  List<String> categories = ['Category 1', 'Category 2', 'Category 3', 'Category 4', 'Category 5'];
  List<bool> isChecked = List.filled(5, false);




@override
void initState() {
  super.initState();
  fetchCategories();
}

void fetchCategories() async {
  var snapshot = await FirebaseFirestore.instance.collection('categories').get();
  List<String> fetched = snapshot.docs.map((doc) => doc['name'] as String).toList();

  setState(() {
    categories = fetched;
    isChecked = List.filled(fetched.length, false);
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF1BA424),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed : () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesView()),
            );
          },
        ),
        title: Center(
          child: Text(
            'Category adding, Viewing,\nupdating',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
             onPressed : () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
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
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );

  if (newCategory != null && newCategory.trim().isNotEmpty) {
    await FirebaseFirestore.instance.collection('categories').add({
      'name': newCategory.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      categories.add(newCategory.trim());
      isChecked.add(false);
    });
  }
},

              icon: Icon(Icons.add_circle_outline),
              label: Text("Add /Update Categories"),
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
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5FFF5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(categories[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Edit"),
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
                            Checkbox(
                              value: isChecked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked[index] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (index < categories.length - 1)
                        Divider(
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),

    
      
    );
  }
}