import 'package:cloud_firestore/cloud_firestore.dart';
import 'ListItem.dart';
import 'Member.dart';

class ListifyList{

  String? docId;

  String name;

  List<ListMember> members;

  List<ListItem> items;

  String ownerId;

  bool showAllItems = false;

  ListifyList({required this.docId, required this.name, required this.members, required this.items, required this.ownerId});

  factory ListifyList.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("ListifyList document data is null");
    }

    List<ListMember> membersList = [];
    if (data['members'] != null) {
      membersList = List<Map<String, dynamic>>.from(data['members'])
          .map((memberMap) => ListMember.fromMap(memberMap))
          .toList();
    }

    return ListifyList(
      docId: doc.id,
      name: data['name'] ?? '',
      members: membersList,
      ownerId: data['ownerId'] ?? '',
      items: [], // items will be loaded separately
    );
  }
}