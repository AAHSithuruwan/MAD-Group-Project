import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String? docId;
  String name;
  List<String> units;
  String categoryName;
  String storeName;
  GeoPoint? location;
  bool isUserSpecificItem;

  Item({
    required this.docId,
    required this.name,
    required this.units,
    required this.categoryName,
    required this.storeName,
    this.location,
    this.isUserSpecificItem = false,
  });

  factory Item.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    GeoPoint? location;
    if (data.containsKey('location') && data['location'] is GeoPoint) {
      location = data['location'] as GeoPoint;
    }

    return Item(
      docId: doc.id,
      name: data['name'] ?? '',
      units: List<String>.from(data['units'] ?? []),
      storeName: data['storeName'] ?? '',
      categoryName: data['categoryName'] ?? '',
      location: location,
      isUserSpecificItem: data['isUserSpecificItem'] ?? false,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'units': units,
      'categoryName': categoryName,
      'storeName': storeName,
      if (location != null) 'location': location,
      'isUserSpecificItem': isUserSpecificItem,
    };
  }
}
