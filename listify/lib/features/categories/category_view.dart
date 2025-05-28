import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:listify/features/categories/categories_view.dart';
import 'package:listify/features/categories/category_addingupdating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  List<bool> _categorySelections = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1BA424),
       leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed : () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesViewPage()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'View Categories',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed : () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesViewPage()),
            );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
               onPressed : () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Categoryaddup()),
            );
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey),
                ),
              ),

              child: Text(
                'Add Categories',
                style: TextStyle(color: Colors.black),


                
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category ${index + 1}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Checkbox(
                            value: _categorySelections[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _categorySelections[index] = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
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