import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:listify/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/ListItem.dart';
import '../Models/ListifyList.dart';

class ListifyListService{

  Future<List<ListifyList>> getAllLists() async {

    // Get current user
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();

    if (user == null) {
      throw Exception("No logged-in user found");
    }

    String uid = user.uid;

    // Query all ListifyLists where members array contains this uid
    QuerySnapshot listQuerySnapshot = await FirebaseFirestore.instance
        .collection('ListifyLists')
        .where('members', arrayContains: uid)
        .get();

    // For each list document, fetch its items subcollection and create ListifyList instances
    List<ListifyList> lists = [];

    for (var listDoc in listQuerySnapshot.docs) {
      ListifyList listifyList = ListifyList.fromDoc(listDoc);

      QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
          .collection('ListifyLists')
          .doc(listDoc.id)
          .collection('ListItems')
          .get();

      listifyList.items = itemsSnapshot.docs
          .map((doc) => ListItem.fromDoc(doc))
          .toList();

      lists.add(listifyList);
    }
    print(lists);
    return lists;

  }

  Future<List<ListifyList>> getTodayLists() async {
    // Get current user
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();

    if (user == null) {
      throw Exception("No logged-in user found");
    }

    String uid = user.uid;
    DateTime today = DateTime.now();
    DateTime todayOnly = DateTime(today.year, today.month, today.day); // Remove time part
    List<ListifyList> filteredLists = [];

    // Fetch all lists the user is a member of
    QuerySnapshot listQuerySnapshot = await FirebaseFirestore.instance
        .collection('ListifyLists')
        .where('members', arrayContains: uid)
        .get();

    for (var listDoc in listQuerySnapshot.docs) {
      ListifyList listifyList = ListifyList.fromDoc(listDoc);

      // Fetch all items in this list
      QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
          .collection('ListifyLists')
          .doc(listDoc.id)
          .collection('ListItems')
          .get();

      // Filter items where requiredDate is today or before today
      List<ListItem> filteredItems = itemsSnapshot.docs.map((doc) {
        return ListItem.fromDoc(doc);
      }).where((item) {

        // Parse string to DateTime
        DateTime itemDate = DateFormat('yyyy/MM/dd').parse(item.requiredDate!);
        DateTime itemOnly = DateTime(itemDate.year, itemDate.month, itemDate.day);

        return itemOnly.isAtSameMomentAs(todayOnly);
      }).toList();

      // Add only lists that have filtered items
      if (filteredItems.isNotEmpty) {
        listifyList.items = filteredItems;
        filteredLists.add(listifyList);
      }
    }

    return filteredLists;
  }

  Future<List<ListifyList>> getTomorrowLists() async {
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    String uid = user.uid;
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));

    List<ListifyList> tomorrowLists = [];

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

          return itemOnly.isAtSameMomentAs(tomorrow);
        } catch (_) {
          return false;
        }
      }).toList();

      if (filteredItems.isNotEmpty) {
        listifyList.items = filteredItems;
        tomorrowLists.add(listifyList);
      }
    }

    return tomorrowLists;
  }

  Future<List<ListifyList>> getLaterLists() async {
    AuthService authService = AuthService();
    User? user = await authService.getCurrentUserinstance();
    if (user == null) throw Exception("No logged-in user found");

    String uid = user.uid;
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));

    List<ListifyList> laterLists = [];

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

          return itemOnly.isAfter(tomorrow);
        } catch (_) {
          return false;
        }
      }).toList();

      if (filteredItems.isNotEmpty) {
        listifyList.items = filteredItems;
        laterLists.add(listifyList);
      }
    }

    return laterLists;
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