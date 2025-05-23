import 'package:cloud_firestore/cloud_firestore.dart';

import 'ListItem.dart';

class ListifyList{

  String? docId;

  String name;

  List<String> members;

  List<ListItem> items;

  bool showAllItems = false;

  ListifyList({required this.docId, required this.name, required this.members, required this.items});

  factory ListifyList.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("ListifyList document data is null");
    }

    return ListifyList(
      docId: doc.id,
      name: data['name'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      items: [], // empty for now, load separately
    );
  }
}