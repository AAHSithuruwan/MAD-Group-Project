import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Item.dart';
import '../Models/ListItem.dart';
import '../Models/ListifyList.dart';

class ListifyListService {
  Future<List<ListifyList>> getListsByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    String uid = user.uid;
    List<ListifyList> filteredLists = [];

    QuerySnapshot listQuerySnapshot =
        await FirebaseFirestore.instance
            .collection('ListifyLists')
            .where('members', arrayContains: uid)
            .get();

    for (var listDoc in listQuerySnapshot.docs) {
      ListifyList listifyList = ListifyList.fromDoc(listDoc);

      QuerySnapshot itemsSnapshot =
          await FirebaseFirestore.instance
              .collection('ListifyLists')
              .doc(listDoc.id)
              .collection('ListItems')
              .get();

      List<ListItem> filteredItems =
          itemsSnapshot.docs
              .map((doc) {
                return ListItem.fromDoc(doc);
              })
              .where((item) {
                try {
                  DateTime itemDate = DateFormat(
                    'yyyy/MM/dd',
                  ).parse(item.requiredDate!);
                  DateTime itemOnly = DateTime(
                    itemDate.year,
                    itemDate.month,
                    itemDate.day,
                  );

                  if (startDate != null && itemOnly.isBefore(startDate))
                    return false;
                  if (endDate != null && itemOnly.isAfter(endDate))
                    return false;
                  return true;
                } catch (_) {
                  return false;
                }
              })
              .toList();

      if (filteredItems.isNotEmpty) {
        listifyList.items = filteredItems;
        filteredLists.add(listifyList);
      }
    }

    // Sort: Lists with all items checked go to the bottom
    filteredLists.sort((a, b) {
      bool aAllChecked = a.items.every((item) => item.checked == true);
      bool bAllChecked = b.items.every((item) => item.checked == true);

      if (aAllChecked == bAllChecked) return 0;
      return aAllChecked
          ? 1
          : -1; // Fully-checked lists come after partially checked ones
    });

    return filteredLists;
  }

  Future<void> checkItem(bool value, String listItemId, String listId) async {
    try {
      await FirebaseFirestore.instance
          .collection("ListifyLists")
          .doc(listId)
          .collection("ListItems")
          .doc(listItemId)
          .update({'checked': value});
    } catch (e) {
      print(e);
    }
  }


  Future<List<ListifyList>> getSelectionLists() async {
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    String uid = user.uid;
    List<ListifyList> lists = [];

    QuerySnapshot listQuerySnapshot = await FirebaseFirestore.instance
        .collection('ListifyLists')
        .where('members', arrayContains: uid)
        .get();

    for (var listDoc in listQuerySnapshot.docs) {
      ListifyList listifyList = ListifyList.fromDoc(listDoc);
      lists.add(listifyList);
    }
    return lists;
  }



  Future<bool> addListItem(
    Item item,
    String listId,
    String quantity,
    String requiredDate,
  ) async {
    AuthService authService = AuthService();

    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    try {
      await FirebaseFirestore.instance
          .collection("ListifyLists")
          .doc(listId)
          .collection("ListItems")
          .add({
            'name': item.name,
            'requiredDate': requiredDate,
            'category': item.categoryName,
            'quantity': quantity,
            'addedUserId': user.uid,
            'checked': false,
          });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> checkAndAddRecurringItems() async {
    try {
      final today = DateTime.now();
      final recurringDocs =
          await FirebaseFirestore.instance
              .collection("RecurringItems")
              .get(); // Fetch all frequencies

      for (var doc in recurringDocs.docs) {
        final data = doc.data();
        final recurringType = data["recurring"]; // daily / weekly / monthly
        final lastAdded = DateTime.parse(data["lastAdded"]);
        final targetListId = data["targetListId"];
        final itemName = data["itemName"];
        final quantity = data["quantity"];
        final categoryName = data["categoryName"];
        final requiredDate = data["requiredDate"];

        bool shouldAdd = false;

        if (recurringType == "daily") {
          shouldAdd =
              !(lastAdded.year == today.year &&
                  lastAdded.month == today.month &&
                  lastAdded.day == today.day);
        } else if (recurringType == "weekly") {
          final difference = today.difference(lastAdded).inDays;
          shouldAdd = difference >= 7;
        } else if (recurringType == "monthly") {
          shouldAdd =
              !(lastAdded.year == today.year && lastAdded.month == today.month);
        }

        if (shouldAdd) {
          await FirebaseFirestore.instance
              .collection("ListifyLists")
              .doc(targetListId)
              .collection("ListItems")
              .add({
                'name': itemName,
                'requiredDate': requiredDate,
                'category': categoryName,
                'quantity': quantity,
                'addedUserId': 'Recurring',
                'checked': false,
              });

          await doc.reference.update({"lastAdded": today.toIso8601String()});

          print("Recurring Item Added Successfully");
        }
      }
      print("Recurring Function Executed Successfully");
    } catch (e) {
      print(e);
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

  // sample JSON structure for a list with members and roles
  // {
  //     "listId": "12155",
  //     "userId": "45882",
  //     "members": [
  //         {
  //             "userId": "451651",
  //             "role": "editor"
  //         },
  //         {
  //             "userId": "258965",
  //             "role": "viewer"
  //         }
  //     ]
  // }

  // 


  // function to get all users from the Users collection to use search bar
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.map((doc) {
        return {
          'userId': doc.id,
          'email': doc['email'] ?? '',
        };
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // function to get all members of a list (params: listId) this should return a list of users with (userId, username, email, role)
  Future<List<Map<String, dynamic>>> getListMembers(String listId) async {
  print("Fetching members for list: $listId");
  try {
    DocumentReference listRef = FirebaseFirestore.instance
        .collection('ListifyLists')
        .doc(listId);

    // Check if the list exists
    DocumentSnapshot listSnapshot = await listRef.get();
    if (!listSnapshot.exists) {
      throw Exception("List does not exist");
    }

    // Fetch members from the list
    final data = listSnapshot.data() as Map<String, dynamic>?;
    List<dynamic> members = data?['members'] ?? [];
    List<Map<String, dynamic>> memberDetails = [];

    for (var member in members) {
      String userId = member['userId'];
      String role = member['role'];

      // Fetch user details from Users collection using userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String email = 'No email';
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        email = userData?['email'] ?? 'No email';
      }

      memberDetails.add({
        'userId': userId,
        'email': email,
        'role': role,
      });
    }
    return memberDetails;

  } catch (e) {
    print(e);
    return [];
  }
}


  // function to add a member to a list (params: listId, userId, role)
  Future<void> addMemberToList(String listId, String userId, String role) async {
    print("Adding member: $userId with role: $role to list: $listId");
    try {
      DocumentReference listRef = FirebaseFirestore.instance
          .collection('ListifyLists')
          .doc(listId);

      // Check if the list exists
      DocumentSnapshot listSnapshot = await listRef.get();
      if (!listSnapshot.exists) {
        throw Exception("List does not exist");
      }

      // Add the member to the list
      await listRef.update({
        'members': FieldValue.arrayUnion([
          {'userId': userId, 'role': role},
        ]),
      });

    } catch (e) {
      print(e);
    }
  }
 
 
  // function to change the role of a member in a list. Roles must be either "editor" or "viewer"
 Future<void> changeMemberRole(String listId, String userId, String newRole) async {
  print("Changing role for user: $userId in list: $listId to role: $newRole");
  try {
    DocumentReference listRef = FirebaseFirestore.instance
        .collection('ListifyLists')
        .doc(listId);

    // Check if the list exists
    DocumentSnapshot listSnapshot = await listRef.get();
    if (!listSnapshot.exists) {
      throw Exception("List does not exist");
    }

    // Fetch current members
    final data = listSnapshot.data() as Map<String, dynamic>?;
    List<dynamic> members = data?['members'] ?? [];

    // Find the member object to remove
    final oldMember = members.firstWhere(
      (m) => m['userId'] == userId,
      orElse: () => null,
    );

    if (oldMember == null) {
      throw Exception("Member not found");
    }

    // Remove the old member object, add the new one with updated role
    await listRef.update({
      'members': FieldValue.arrayRemove([oldMember]),
    });

    await listRef.update({
      'members': FieldValue.arrayUnion([
        {'userId': userId, 'role': newRole},
      ]),
    });

  } catch (e) {
    print(e);
  }
}

  // function to remove a member from a list
Future<void> removeMemberFromList(String listId, String userId) async {
  print("Removing member: $userId from list: $listId");
  try {
    DocumentReference listRef = FirebaseFirestore.instance
        .collection('ListifyLists')
        .doc(listId);

    // Check if the list exists
    DocumentSnapshot listSnapshot = await listRef.get();
    if (!listSnapshot.exists) {
      throw Exception("List does not exist");
    }

    // Fetch current members
    final data = listSnapshot.data() as Map<String, dynamic>?;
    List<dynamic> members = data?['members'] ?? [];

    // Find the member object to remove
    final memberToRemove = members.firstWhere(
      (m) => m['userId'] == userId,
      orElse: () => null,
    );

    if (memberToRemove == null) {
      throw Exception("Member not found");
    }

    // Remove the exact member object
    await listRef.update({
      'members': FieldValue.arrayRemove([memberToRemove]),
    });

  } catch (e) {
    print(e);
  }
}
}