import 'package:cloud_firestore/cloud_firestore.dart';

class ListItem{

  String? docId;

  String name;

  String category;

  String quantity;

  String requiredDate;

  bool checked;

  String addedUserId;

  ListItem({this.docId, required this.name, required this.category, required this.quantity, required this.requiredDate, required this.checked, required this.addedUserId});

  factory ListItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("ListItem document data is null");
    }

    return ListItem(
      docId: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      quantity: data['quantity'] ?? 0,
      requiredDate: data['requiredDate'] ?? '',
      checked: data['checked'] ?? false,
      addedUserId: data['addedUserId'] ?? ''
    );
  }
}