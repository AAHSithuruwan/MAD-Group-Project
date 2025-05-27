import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Item.dart';

class StoreNotificationService{
  Future<void> storeAddItemNotifications({
    required String listId,
    required String changedUserId,
    required Item item,
  }) async {
    try {

      final listDoc = await FirebaseFirestore.instance.collection('ListifyLists').doc(listId).get();
      if (!listDoc.exists) {
        throw Exception("List not found");
      }

      final listData = listDoc.data();
      if (listData == null || !listData.containsKey('members')) {
        throw Exception("Members array not found in list");
      }

      final notification = {
        'title': "New Item Added",
        'body': "${item.name} has been added to the ${listData['name']}",
        'data': {},
        'createdAt': DateTime.now().toIso8601String(),
      };

      final members = List<Map<String, dynamic>>.from(listData['members']);
      for (final member in members) {
        final userId = member['userId'];
        if (userId != changedUserId) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('Notifications')
              .add(notification);
        }
      }
    } catch (e) {
      print("Error storing notifications: $e");
      throw Exception("Failed to store notifications");
    }
  }


  Future<void> storeCheckItemNotifications({
    required String listId,
    required String changedUserId,
    required String listItemId,
  }) async {
    try {
      final listDoc = await FirebaseFirestore.instance.collection('ListifyLists').doc(listId).get();
      if (!listDoc.exists) throw Exception("List not found");

      final listData = listDoc.data();
      if (listData == null || !listData.containsKey('members')) {
        throw Exception("Members array not found in list");
      }

      final listItemDoc = await FirebaseFirestore.instance
          .collection('ListifyLists')
          .doc(listId)
          .collection('ListItems')
          .doc(listItemId)
          .get();
      if (!listItemDoc.exists) throw Exception("List item not found");

      final itemData = listItemDoc.data();
      final itemName = itemData?['name'] ?? 'Item';

      final notification = {
        'title': "Item Checked",
        'body': "$itemName has been marked as checked in ${listData['name']}",
        'data': {},
        'createdAt': DateTime.now().toIso8601String(),
      };

      final members = List<Map<String, dynamic>>.from(listData['members']);
      for (final member in members) {
        final userId = member['userId'];
        if (userId != changedUserId) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('Notifications')
              .add(notification);
        }
      }
    } catch (e) {
      print("Error storing notifications: $e");
      throw Exception("Failed to store notifications");
    }
  }


}



