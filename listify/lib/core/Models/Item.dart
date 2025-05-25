import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String? docId;
  String name;
  List<String> units;
  String categoryName;
  String storeName;

  Item({
    required this.docId,
    required this.name,
    required this.units,
    required this.categoryName,
    required this.storeName,
  });

  factory Item.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item(
      docId: doc.id,
      name: data['name'] ?? '',
      units: List<String>.from(data['units'] ?? []),
      categoryName: data['categoryName'] ?? '',
      storeName: data['storeName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'units': units,
      'categoryName': categoryName,
      'storeName': storeName,
    };
  }
}
