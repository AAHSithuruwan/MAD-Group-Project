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

  Future<void> addItembyUser(Item item) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }
      final docRef =
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('UserSpecificItems')
              .doc();

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

  Future<List<Item>> getAllUserItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user logged in');
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('UserSpecificItems')
            .get();
    return snapshot.docs.map((doc) => Item.fromDoc(doc)).toList();
  }

  Future<void> deleteUserItem(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user logged in');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('UserSpecificItems')
        .doc(docId)
        .delete();
  }

  Future<void> updateUserItem(Item item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user logged in');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('UserSpecificItems')
        .doc(item.docId)
        .update(item.toMap());
  }

  Future<int> getItemCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user logged in');
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('UserSpecificItems')
            .get();
    return snapshot.docs.length;
  }

  Future<List<ListifyCategory>> getCategoriesWithItems() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    AuthService authService = AuthService();

    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

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
            final data = doc.data() as Map<String, dynamic>;

            GeoPoint? location;
            if (data.containsKey('location') && data['location'] is GeoPoint) {
              location = data['location'] as GeoPoint;
            }

            return Item(
              docId: doc.id,
              name: data['name'] ?? '',
              units: List<String>.from(data['units'] ?? []),
              categoryName: data['categoryName'] ?? '',
              storeName: data['storeName'] ?? '',
              location: location,
              isUserSpecificItem: data['isUserSpecificItem'] ?? false,
            );
          }).toList();

      QuerySnapshot userItemSnapshot =
          await firestore
              .collection('users')
              .doc(user.uid)
              .collection('UserSpecificItems')
              .where('categoryName', isEqualTo: categoryName)
              .get();

      List<Item> userItems =
          userItemSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            GeoPoint? location;
            if (data.containsKey('location') && data['location'] is GeoPoint) {
              location = data['location'] as GeoPoint;
            }

            return Item(
              docId: doc.id,
              name: data['name'] ?? '',
              units: List<String>.from(data['units'] ?? []),
              categoryName: data['categoryName'] ?? '',
              storeName: data['storeName'] ?? '',
              location: location,
              isUserSpecificItem: true,
            );
          }).toList();

      items.addAll(userItems);

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
            .collection('users')
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
            isUserSpecificItem: data['isUserSpecificItem'],
          ),
        );
      }

      if (recentItems.length == 10) break;
    }
    List<Item> items = [];
    for (var i in recentItems) {
      if (i.isUserSpecificItem == false) {
        Item item = await getItemById(i.itemId);
        items.add(item);
      } else {
        Item item = await getUserSpecificItemById(i.itemId);
        items.add(item);
        print(item.isUserSpecificItem);
      }
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

      final data = documentSnapshot.data() as Map<String, dynamic>;

      GeoPoint? location;
      if (data.containsKey('location') && data['location'] is GeoPoint) {
        location = data['location'] as GeoPoint;
      }

      return Item(
        docId: itemId,
        name: data['name'] ?? '',
        units: List<String>.from(data['units'] ?? []),
        categoryName: data['categoryName'] ?? '',
        storeName: data['storeName'] ?? '',
        location: location,
      );
    } catch (e) {
      throw Exception("No item found: $e");
    }
  }

  Future<Item> getUserSpecificItemById(String itemId) async {
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("UserSpecificItems")
              .doc(itemId)
              .get();

      if (!documentSnapshot.exists) {
        throw Exception("User Specific Item with ID $itemId does not exist");
      }

      final data = documentSnapshot.data() as Map<String, dynamic>;

      GeoPoint? location;
      if (data.containsKey('location') && data['location'] is GeoPoint) {
        location = data['location'] as GeoPoint;
      }

      return Item(
        docId: itemId,
        name: data['name'] ?? '',
        units: List<String>.from(data['units'] ?? []),
        categoryName: data['categoryName'] ?? '',
        storeName: data['storeName'] ?? '',
        location: location,
        isUserSpecificItem: true,
      );
    } catch (e) {
      throw Exception("No item found: $e");
    }
  }

  Future<bool> addRecurringItem({
    required String itemName,
    required String targetListId,
    required String quantity,
    required String categoryName,
    required String requiredDate,
    required String recurringType,
  }) async {
    final now = DateTime.now();
    try {
      await FirebaseFirestore.instance.collection("RecurringItems").add({
        "itemName": itemName,
        "targetListId": targetListId,
        "quantity": quantity,
        "categoryName": categoryName,
        "requiredDate": requiredDate,
        "recurring": recurringType, // "daily", "weekly", or "monthly"
        "lastAdded": now.toIso8601String(),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> addRecentItem({
    required String itemId,
    required String name,
    required String categoryName,
    required bool isUserSpecificItem,
  }) async {
    try {
      AuthService authService = AuthService();

      User? user = await authService.getCurrentUserinstance();
      if (user == null) throw Exception("No logged-in user found");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("RecentItems")
          .add({
            'itemId': itemId,
            'name': name,
            'categoryName': categoryName,
            'createdAt': DateTime.now().toIso8601String(),
            'isUserSpecificItem': isUserSpecificItem,
          });
      print("Recent item added successfully.");
    } catch (e) {
      print("Failed to add recent item: $e");
    }
  }
}
