import 'package:cloud_firestore/cloud_firestore.dart';
import 'Item.dart';

class ListifyCategory {
  String? docId;

  String name;

  List<Item>? items;

  ListifyCategory({required this.docId, required this.name, this.items});


  factory ListifyCategory.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ListifyCategory(
      docId: doc.id,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'docId': docId,
    };
  }
}




