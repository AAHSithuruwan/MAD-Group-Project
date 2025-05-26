class RecentItem{

  String itemId;

  String name;

  String categoryName;

  bool isUserSpecificItem;

  RecentItem({required this.itemId, required this.name, required this.categoryName, this.isUserSpecificItem = false});
}