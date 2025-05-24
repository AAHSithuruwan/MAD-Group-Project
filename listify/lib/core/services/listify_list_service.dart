import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
}