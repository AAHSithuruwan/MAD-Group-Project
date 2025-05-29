import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/Models/ListifyCategory.dart';
import 'package:listify/core/services/item_service.dart';
import 'package:overflow_view/overflow_view.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../core/Models/Item.dart';

class AddListItems extends StatefulWidget {
  const AddListItems({super.key});

  @override
  State<AddListItems> createState() => _AddListItemsState();
}

class _AddListItemsState extends State<AddListItems> {

  bool isLoading = true;

  List<ListifyCategory> categoriesWithItems = [];

  List<ListifyCategory> filteredCategoryWithItems = [];

  List<Item> recentItems = [];

  List<Item> filteredRecentItems = [];

  void navigateToQuantitySelectionPage(Item item) {
    context.push('/quantity-selection', extra: item);
  }

  Future<void> getItems() async {
    ItemService itemService = new ItemService();
    List<ListifyCategory> categoriesAndItems =
        await itemService.getCategoriesWithItems();
    List<Item> userRecentItems = await itemService.getLatest10RecentItems();
    setState(() {
      categoriesWithItems = categoriesAndItems;
      filteredCategoryWithItems = List.from(
        categoriesWithItems.map(
          (category) => ListifyCategory(
            docId: category.docId,
            name: category.name,
            items: List.from(category.items ?? []),
          ),
        ),
      );
      recentItems = userRecentItems;
      filteredRecentItems = List.from(
        recentItems.map(
          (item) => Item(
            docId: item.docId,
            name: item.name,
            units: List.from(item.units ?? []),
            storeName: item.storeName,
            categoryName: item.categoryName,
            isUserSpecificItem: item.isUserSpecificItem,
          ),
        ),
      );
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Add Items", displayTitle: true),
      backgroundColor: Color(0xFFF0F4F0),

      body: isLoading ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: SpinKitThreeBounce(
            color: Colors.green,
            size: 40.0,
          ),),
        ],
      )
      :
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 10),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          7,
                        ), // Rounded corners
                        side: BorderSide(
                          color: Colors.green, // Border color
                          width: 2, // Border width
                        ),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (query) {
                      controller.openView();
                    },
                    hintText: "Search items",
                    hintStyle: WidgetStatePropertyAll<TextStyle>(
                      TextStyle(
                        color: Color(0xFFAAAAAA),
                      ), // Change hint text color
                    ),
                    trailing: <Widget>[
                      Tooltip(
                        message: "search",
                        child: Icon(Icons.search, color: Color(0xFFB7B7B7)),
                      ),
                    ],
                  );
                },
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  List<Item> itemList = [];
                  for (var category in categoriesWithItems) {
                    for (var item in category.items!) {
                      itemList.add(item);
                    }
                  }
                  List<Item> filteredItems =
                      itemList
                          .where(
                            (item) => item.name.toLowerCase().contains(
                              controller.text.toLowerCase(),
                            ),
                          )
                          .toList();
                  return filteredItems.map((item) {
                    return ListTile(
                      title: Text(item.name),
                      onTap: () {
                        setState(() {
                          navigateToQuantitySelectionPage(item);
                        });
                      },
                    );
                  }).toList();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
              child: OverflowView(
                direction: Axis.horizontal,
                spacing: 12.0, // Space between buttons
                children: [
                  SizedBox(
                    height: 35,
                    width: 110,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(
                              0x1A1BA424,
                            ), // Shadow color with opacity
                            blurRadius: 20, // The spread of the shadow
                            offset: Offset(-5, -5), // Shadow position (x, y)
                          ),
                          BoxShadow(
                            color: Color(
                              0x1A1BA424,
                            ), // Shadow color with opacity
                            blurRadius: 20, // The spread of the shadow
                            offset: Offset(5, 5), // Shadow position (x, y)
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            filteredCategoryWithItems.clear();
                            filteredCategoryWithItems = List.from(
                              categoriesWithItems.map(
                                (category) => ListifyCategory(
                                  docId: category.docId,
                                  name: category.name,
                                  items: List.from(category.items ?? []),
                                ),
                              ),
                            );
                            filteredRecentItems.clear();
                            filteredRecentItems = List.from(
                              recentItems.map(
                                (item) => Item(
                                  docId: item.docId,
                                  name: item.name,
                                  units: List.from(item.units ?? []),
                                  storeName: item.storeName,
                                  categoryName: item.categoryName,
                                  isUserSpecificItem: item.isUserSpecificItem,
                                ),
                              ),
                            );
                          });
                        },

                        child: Text(
                          "All",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...categoriesWithItems.map(
                    (category) => SizedBox(
                      height: 35,
                      width: 110,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(
                                0x1A1BA424,
                              ), // Shadow color with opacity
                              blurRadius: 20, // The spread of the shadow
                              offset: Offset(-5, -5), // Shadow position (x, y)
                            ),
                            BoxShadow(
                              color: Color(
                                0x1A1BA424,
                              ), // Shadow color with opacity
                              blurRadius: 20, // The spread of the shadow
                              offset: Offset(5, 5), // Shadow position (x, y)
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              filteredCategoryWithItems.clear();
                              filteredRecentItems.clear();
                              filteredCategoryWithItems.add(category);
                            });
                          },

                          child: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                builder: (context, remaining) {
                  if (remaining == 0) return SizedBox();
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A1BA424), // Shadow color with opacity
                          blurRadius: 20, // The spread of the shadow
                          offset: Offset(-5, -5), // Shadow position (x, y)
                        ),
                        BoxShadow(
                          color: Color(0x1A1BA424), // Shadow color with opacity
                          blurRadius: 20, // The spread of the shadow
                          offset: Offset(5, 5), // Shadow position (x, y)
                        ),
                      ],
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_horiz),
                      color: Colors.white,
                      itemBuilder:
                          (context) =>
                              categoriesWithItems
                                  .skip(
                                    categoriesWithItems.length - remaining,
                                  ) // Get only hidden buttons
                                  .map(
                                    (category) => PopupMenuItem(
                                      value: category.name,
                                      child: Text(category.name),
                                    ),
                                  )
                                  .toList(),
                      onSelected: (value) {
                        ListifyCategory category = categoriesWithItems
                            .firstWhere(
                              (category) => category.name == value,
                              orElse:
                                  () => ListifyCategory(
                                    docId: '',
                                    name: 'Not Found',
                                    items: [],
                                  ), // Fallback if not found
                            );

                        setState(() {
                          filteredCategoryWithItems.clear();
                          filteredRecentItems.clear();
                          filteredCategoryWithItems.add(category);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Container(height: 1, color: Color(0xFFB7B7B7)),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 20, 35, 20),
              child: Container(
                constraints: BoxConstraints(minWidth: 400),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    filteredRecentItems.isEmpty == false
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recent Items",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children:
                                  (filteredRecentItems ?? [])
                                      .map(
                                        (item) => GestureDetector(
                                          onTap: () {
                                            navigateToQuantitySelectionPage(
                                              item,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD9D9D9),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    20,
                                                    10,
                                                    20,
                                                    10,
                                                  ),
                                              child: Text(
                                                item.name,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            SizedBox(height: 30),
                          ],
                        )
                        : Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          filteredCategoryWithItems
                              .map(
                                (category) =>
                                    category.items?.isEmpty == false
                                        ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              children:
                                                  (category.items ?? [])
                                                      .map(
                                                        (
                                                          item,
                                                        ) => GestureDetector(
                                                          onTap: () {
                                                            navigateToQuantitySelectionPage(
                                                              item,
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  const Color(
                                                                    0xFFD9D9D9,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.fromLTRB(
                                                                    20,
                                                                    10,
                                                                    20,
                                                                    10,
                                                                  ),
                                                              child: Text(
                                                                item.name,
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                            SizedBox(height: 30),
                                          ],
                                        )
                                        : Container(),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.pushReplacement('/create_items_user');
          },
          label: Text("Create Item", style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
