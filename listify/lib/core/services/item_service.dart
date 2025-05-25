import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listify/core/Models/Item.dart';
import 'package:listify/core/services/auth_service.dart';

import '../Models/ListifyCategory.dart';
import '../Models/RecentItem.dart';

class ItemService {
  Future<void> addItem(Item item) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Items').doc();
      await docRef.set({
        ...item.toMap(),
        'docId': docRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Firestore error: $e');
      rethrow;
    }
  }

  Future<List<ListifyCategory>> getCategoriesWithItems() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Step 1: Fetch all categories
    QuerySnapshot categorySnapshot =
        await firestore.collection('ListifyCategories').get();

    List<ListifyCategory> categoryList = [];

    for (var categoryDoc in categorySnapshot.docs) {
      String categoryId = categoryDoc.id;
      String categoryName = categoryDoc['name'];

      // Step 2: Fetch items under this category
      QuerySnapshot itemSnapshot =
          await firestore
              .collection('Items')
              .where('categoryName', isEqualTo: categoryName)
              .get();

      List<Item> items =
          itemSnapshot.docs.map((doc) {
            return Item(
              docId: doc.id,
              name: doc['name'],
              units: List<String>.from(doc['units']),
              categoryName: doc['categoryName'],
              storeName: doc['storeName'],
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

  Future<List<Item>> getLatest10RecentItems() async {
    AuthService authService = AuthService();

    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    final snapshot =
        await FirebaseFirestore.instance
            .collection('UserRecentItems')
            .doc(user.uid)
            .collection('RecentItems')
            .orderBy('createdAt', descending: true)
            .get();

    final seen = <String>{}; // to track unique itemIds
    final recentItems = <RecentItem>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final itemId = data['itemId'];

      if (!seen.contains(itemId)) {
        seen.add(itemId);
        recentItems.add(
          RecentItem(
            itemId: itemId,
            name: data['name'],
            categoryName: data['categoryName'],
          ),
        );
      }

      if (recentItems.length == 10) break;
    }
    print("here");
    List<Item> items = [];
    for (var i in recentItems) {
      Item item = await getItemById(i.itemId);
      items.add(item);
    }

    return items;
  }

  Future<Item> getItemById(String itemId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance
              .collection("Items")
              .doc(itemId)
              .get();

      if (!documentSnapshot.exists) {
        throw Exception("Item with ID $itemId does not exist");
      }

      return Item(
        docId: itemId,
        name: documentSnapshot.get("name"),
        units: List<String>.from(documentSnapshot.get("units")),
        categoryName: documentSnapshot.get("categoryName"),
        storeName: documentSnapshot.get("storeName"),
      );
    } catch (e) {
      throw Exception("No item found: $e");
    }
  }
}
