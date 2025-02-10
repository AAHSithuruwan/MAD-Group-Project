import 'package:flutter/material.dart';
import 'package:mad_group_project/custom_app_bar.dart';
import 'package:mad_group_project/custom_bottom_navigation_bar.dart';
import 'package:mad_group_project/custom_floating_action_button.dart';
import 'package:overflow_view/overflow_view.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<String> buttonNames = ["Cargills", "Keells", "Sampath", "Arpidddddddco", "tset", "tset", "tset"];

  List<CategoryList> categoryList = [
    CategoryList(
        "Fruits",
        [
          Item("Apple", false, false),
          Item("Banana", true, false),
          Item("Mango", false, true),
          Item("Grapes", true, false),
          Item("Grapes", true, false),
          Item("Grapes", true, false),
        ]
    ),
    CategoryList(
        "Vegetables",
        [
          Item("Carrot", false, false),
          Item("Potato", true, true),
          Item("Cucumber", false, false),
          Item("Spinach", true, false),
          Item("Spinach", true, false),
          Item("Spinach", true, false),
        ]
    ),
    CategoryList(
        "Electronics",
        [
          Item("Laptop", true, true),
          Item("Headphones", false, false),
          Item("Smartphone", true, false),
          Item("Camera", false, true),
        ]
    ),
    CategoryList(
        "Clothes",
        [
          Item("T-shirt", true, false),
          Item("Jeans", false, false),
          Item("Jacket", true, true),
          Item("Shoes", false, true),
        ]
    ),
  ];

  bool categoryCheckBox(List<Item> items){
    bool checked = true;
    for (var item in items) {
      if(item.Checked == false){
        checked = false;
      }
    }
    return checked;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(title: "Home"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,8,8,5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Shared List",style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {},
                      child: Text("Personal List",style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {},
                      child: Text("Add +",style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Color(0xFFB7B7B7),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 10),
                child: OverflowView(
                  direction: Axis.horizontal,
                  spacing: 12.0, // Space between buttons
                  children: buttonNames
                      .map((name) => SizedBox(
                        height: 35,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9),  // Set the background color
                          ),
                          child: Text(name,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                        ),
                      )).toList(),

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
                        itemBuilder: (context) => buttonNames
                            .skip(buttonNames.length - remaining) // Get only hidden buttons
                            .map((name) => PopupMenuItem(value: name, child: Text(name)))
                            .toList(),
                        onSelected: (value) {

                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: categoryList.map((list) =>
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,8,20,15),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow:[
                            BoxShadow(
                              color: Color(0xFFD9D9D9), // Shadow color with opacity
                              blurRadius: 10, // The spread of the shadow
                              offset: Offset(-5, -5), // Shadow position (x, y)
                            ),
                            BoxShadow(
                              color: Color(0xFFD9D9D9), // Shadow color with opacity
                              blurRadius: 10, // The spread of the shadow
                              offset: Offset(5, 5), // Shadow position (x, y)
                            ),

                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20,8,15,8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(list.CategoryName, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                      value: categoryCheckBox(list.CategoryItems),
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          for(var item in list.CategoryItems){
                                            item.Checked = newValue!;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: list.CategoryItems
                                  .take(list.ShowAllItems ? list.CategoryItems.length : 4)
                                  .map((item) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.ItemName, style: TextStyle(fontSize: 18),),
                                            Row(
                                              children: [
                                                item.Urgent == true ?
                                                    Icon(
                                                      Icons.circle,
                                                      color: Colors.red,
                                                      size: 15,
                                                    )
                                                :
                                                    Container(),
                                                Checkbox(
                                                  value: item.Checked,
                                                  activeColor: Color(0xFF1BA424),  // Change the color of the checked box
                                                  checkColor: Colors.white,
                                                  onChanged: (bool? newValue) {
                                                      setState(() {
                                                        item.Checked = newValue!;
                                                      });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(25,0,15,15),
                                        child: Container(
                                          height: 1,
                                          color: Color(0xFFB7B7B7),
                                        ),
                                      )
                                    ],
                                  );}
                              ).toList(),
                            ),
                            // Show "See More" button if there are more than 4 items
                            if (list.CategoryItems.length > 4)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    list.ShowAllItems = !(list.ShowAllItems);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8,0,8,10),
                                  child: Text(
                                    list.ShowAllItems ? "<<Show Less>>" : "<<See More>>",
                                    style: TextStyle(color: Color(0xFF1BA424),),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ).toList()
                ),
              )
            ],
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // FAB in center
        bottomNavigationBar: CustomBottomNavigationBar(),
      );
  }
}

class CategoryList{
  String CategoryName;
  List<Item> CategoryItems;
  bool ShowAllItems = false;

  CategoryList(this.CategoryName,this.CategoryItems);
}

class Item{
  String ItemName;
  bool Checked;
  bool Urgent;

  Item(this.ItemName, this.Checked, this.Urgent);
}