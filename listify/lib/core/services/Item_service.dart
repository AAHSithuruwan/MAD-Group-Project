import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Item.dart';
import '../Models/ListItem.dart';
import '../Models/ListifyCategory.dart';
import '../Models/ListifyList.dart';

class ItemService{

  Future<List<ListifyCategory>> getCategoriesWithItems() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Step 1: Fetch all categories
    QuerySnapshot categorySnapshot = await firestore.collection('ListifyCategories').get();

    List<ListifyCategory> categoryList = [];

    for (var categoryDoc in categorySnapshot.docs) {
      String categoryId = categoryDoc.id;
      String categoryName = categoryDoc['name'];

      // Step 2: Fetch items under this category
      QuerySnapshot itemSnapshot = await firestore
          .collection('Items')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      List<Item> items = itemSnapshot.docs.map((doc) {
        return Item(
          docId: doc.id,
          name: doc['name'],
          units: List<String>.from(doc['units']),
          categoryId: doc['categoryId'],
        );
      }).toList();

      // Step 3: Create the category with its items
      ListifyCategory category = ListifyCategory(
        docId: categoryId,
        name: categoryName,
        items: items,
      );

      categoryList.add(category);
    }

    return categoryList;
  }
}