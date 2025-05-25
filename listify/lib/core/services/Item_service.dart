import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listify/core/Models/Item_model.dart';

class ItemService {
  Future<void> addItem(Item item) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Items').doc();
      await docRef.set({
        ...item.toMap(),
        'docId': docRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Firestore error: $e');
      rethrow;
    }
  }
}
