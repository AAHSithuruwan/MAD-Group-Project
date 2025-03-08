import 'package:flutter/material.dart';
import 'package:mad_group_project/custom_app_bar.dart';
import 'package:mad_group_project/main_container.dart';
import 'package:mad_group_project/custom_floating_action_button.dart';
import 'package:overflow_view/overflow_view.dart';

class AddItems extends StatefulWidget{
  const AddItems({super.key});


  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {

  List<Category> categories = [
    Category('Fruits', [
      Item('Apple'),
      Item('Banana'),
      Item('Orangedddddddddddddddddddddddddddddddd'),
      Item('Mango'),
    ]),
    Category('Vegetables', [
      Item('Carrot'),
      Item('Brocc'),
      Item('Spinachddddddddddddddddddddddddddd'),
      Item('Potato'),
    ]),
    Category('Meats', [
      Item('Chicken'),
      Item('Beef'),
      Item('Pork'),
      Item('Lamb'),
    ]),
    Category('Beverages', [
      Item('Water'),
      Item('Juice'),
      Item('Tea'),
      Item('Coffee'),
    ]),
  ];

  List<Category> filteredCategory = [];

  @override
  void initState() {
    super.initState();
    // Creating a deep copy of categories
    filteredCategory = List.from(categories.map((category) =>
        Category(category.categoryName, List.from(category.items))
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Add Items"),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30,35,30,10),
              child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      elevation: WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7), // Rounded corners
                          side: BorderSide(
                            color: Color(0xFFBCBCBC), // Border color
                            width: 2, // Border width
                          ),
                        ),
                      ),
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (query) {
                        controller.openView();
                      },
                      hintText: "Search items",
                      hintStyle: WidgetStatePropertyAll<TextStyle>(
                        TextStyle(color: Color(0xFFAAAAAA)), // Change hint text color
                      ),
                      trailing: <Widget>[
                        Tooltip(
                          message: "search",
                          child: Icon(Icons.search, color: Color(0xFFB7B7B7),),
                        )
                      ],
                    );
                  }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    List<String> itemList = [];
                    for(var category in categories){
                      for(var item in category.items){
                        itemList.add(item.itemName);
                      }
                    }
                    List<String> filteredItems = itemList
                        .where((item) => item.toLowerCase().contains(controller.text.toLowerCase()))
                        .toList();
                    return filteredItems.map((item) {
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    }).toList();
              }),
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
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          filteredCategory.clear();
                          filteredCategory = List.from(categories.map((category) =>
                              Category(category.categoryName, List.from(category.items))
                          ));
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFD9D9D9),  // Set the background color
                      ),
                      child: Text("All",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ...categories.map((category) => SizedBox(
                  height: 35,
                  width: 110,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        filteredCategory.clear();
                        filteredCategory.add(category);
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD9D9D9),  // Set the background color
                    ),
                    child: Text(category.categoryName,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                  ),
                )),
                ],

                builder: (context, remaining) {
                  if (remaining == 0) return SizedBox();
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_horiz),
                      color: Color(0xFFD9D9D9),
                      itemBuilder: (context) => categories
                          .skip(categories.length - remaining) // Get only hidden buttons
                          .map((category) => PopupMenuItem(value: category.categoryName, child: Text(category.categoryName)))
                          .toList(),
                      onSelected: (value) {
                        Category category = categories.firstWhere(
                              (category) => category.categoryName == value,
                          orElse: () => Category('Not Found', []), // Fallback if not found
                        );

                        setState(() {
                          filteredCategory.clear();
                          filteredCategory.add(category);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 1,
              color: Color(0xFFB7B7B7),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35,20,35,20),
              child: Container(
                constraints: BoxConstraints(minWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredCategory.map((category) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.categoryName,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: category.items.map((item) =>
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFD9D9D9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20,10,20,10),
                                        child: Text(item.itemName,style: TextStyle(fontSize: 15)),
                                      )),
                                )
                            ).toList()
                          ),
                          SizedBox(height: 30,)
                        ],
                      )
                  ).toList()
                ),
              ),
            ),

          ],
        ),
      ),

      floatingActionButton: CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // FAB in center
      bottomNavigationBar: MainContainer(),
    );
  }
}

class Category{
  String categoryName;
  List<Item> items;

  Category(this.categoryName,this.items);
}

class Item{
  String itemName;

  Item(this.itemName);
}