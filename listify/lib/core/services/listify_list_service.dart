import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Item_model.dart';
import '../Models/ListItem.dart';
import '../Models/ListifyList.dart';

class ListifyListService{

  Future<List<ListifyList>> getListsByDateRange({DateTime? startDate, DateTime? endDate}) async {
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    String uid = user.uid;
    List<ListifyList> filteredLists = [];

    QuerySnapshot listQuerySnapshot = await FirebaseFirestore.instance
        .collection('ListifyLists')
        .where('members', arrayContains: uid)
        .get();

    for (var listDoc in listQuerySnapshot.docs) {
      ListifyList listifyList = ListifyList.fromDoc(listDoc);

      QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
          .collection('ListifyLists')
          .doc(listDoc.id)
          .collection('ListItems')
          .get();

      List<ListItem> filteredItems = itemsSnapshot.docs.map((doc) {
        return ListItem.fromDoc(doc);
      }).where((item) {
        try {
          DateTime itemDate = DateFormat('yyyy/MM/dd').parse(item.requiredDate!);
          DateTime itemOnly = DateTime(itemDate.year, itemDate.month, itemDate.day);

          if (startDate != null && itemOnly.isBefore(startDate)) return false;
          if (endDate != null && itemOnly.isAfter(endDate)) return false;
          return true;
        } catch (_) {
          return false;
        }
      }).toList();

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
      return aAllChecked ? 1 : -1; // Fully-checked lists come after partially checked ones
    });

    return filteredLists;
  }

  Future<void> checkItem(bool value, String listItemId, String listId) async{
    try{
      await FirebaseFirestore.instance
          .collection("ListifyLists")
          .doc(listId)
          .collection("ListItems")
          .doc(listItemId)
          .update({'checked': value});
    }
    catch(e){
      print(e);
    }
  }

  Future<bool> addListItem(Item item, String listId, String quantity, String requiredDate) async {
    AuthService authService = AuthService();

    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    try{
      await FirebaseFirestore.instance
          .collection("ListifyLists")
          .doc(listId)
          .collection("ListItems")
          .add({'name': item.name, 'requiredDate': requiredDate, 'category': item.categoryName, 'quantity': quantity, 'addedUserId': user.uid, 'checked': false});

      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }

  Future<void> checkAndAddRecurringItems() async {
    try{
      final today = DateTime.now();
      final recurringDocs = await FirebaseFirestore.instance
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
          shouldAdd = !(lastAdded.year == today.year &&
              lastAdded.month == today.month &&
              lastAdded.day == today.day);
        } else if (recurringType == "weekly") {
          final difference = today.difference(lastAdded).inDays;
          shouldAdd = difference >= 7;
        } else if (recurringType == "monthly") {
          shouldAdd = !(lastAdded.year == today.year &&
              lastAdded.month == today.month);
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
            'checked': false
          });

          await doc.reference.update({
            "lastAdded": today.toIso8601String()
          });

          print("Recurring Item Added Successfully");
        }
      }
      print("Recurring Function Executed Successfully");
    }
    catch(e){
      print(e);
    }
  }

  Future<bool> addRecurringItem({required String itemName, required String targetListId, required String quantity, required String categoryName, required String requiredDate, required String recurringType,}) async{
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
    }
    catch(e){
      print(e);
      return false;
    }
  }



}