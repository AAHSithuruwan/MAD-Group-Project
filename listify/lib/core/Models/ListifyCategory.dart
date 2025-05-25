import 'Item_model.dart';

class ListifyCategory{

  String? docId;

  String name;

  List<Item>? items;

  ListifyCategory({required this.docId, required this.name, this.items});
}