import 'package:flutter/material.dart';
import 'package:mad_group_project/common/widgets/custom_app_bar.dart';
import 'package:mad_group_project/features/main_container/presentation/screens/main_container.dart';
import 'package:mad_group_project/common/widgets/custom_floating_action_button.dart';
import 'package:overflow_view/overflow_view.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<ListType> listTypes = [
    ListType(Icons.home, "Family", true),
    ListType(Icons.lock, "Personal", false),
    ListType(Icons.group, "Friends", false),
    ListType(Icons.group, "Friends", false),
    ListType(Icons.lock, "Personal", false),
  ];

  //First, fetch the Family List and set it in the below list.
  //Then, when user press another list such as personal list.
  //Fetch that list and set it in the below list.

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

  String getSelectedListName(){
    for(var i in listTypes){
      if(i.isSelected == true){
        return "${i.label} List";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
      return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28,50,28,20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Listify 1", style: TextStyle(fontFamily: "Labrada", fontSize: 40),),
                      Text("Simplify your shopping list", style: TextStyle(fontFamily: "Khmer", fontSize: 12),)
                    ],
                  ),
                  CircleAvatar(
                    radius: 25, // Adjust the size
                    backgroundImage: AssetImage("assets/images/profileImg.png") // Replace with your image URL
                  ),
                ],
              ),
            ),
            //Button set
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 25, 3),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listTypes.length,
                        itemBuilder: (context, index) {
                          final item = listTypes[index];
                          return Padding(
                            padding: EdgeInsets.only(top: 5, left: 13, right: 13),
                            child: GestureDetector(
                              onTap: () {
                                //Fetch the relevant list and set it.
                                setState(() {
                                  for(var i in listTypes){
                                    i.isSelected = false;
                                  }
                                  item.isSelected = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 60, // Adjust size
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: item.isSelected ? Colors.green : Colors.grey[300], // Background color
                                      shape: BoxShape.circle, // Ensures it's circular
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.25), // 25% opacity black
                                          offset: Offset(4, 4), // X: 4, Y: 4
                                          blurRadius: 10, // Blur: 10
                                          spreadRadius: 1, // Spread: 1
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        item.icon,
                                        size: 35,
                                        color: item.isSelected ? Colors.white : Colors.black54,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    item.label,
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 20, // Adjust size
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          shape: BoxShape.circle, // Ensures it's circular
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ), // Greater than sign
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Color(0xFFF0F4F0),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      //List Name
                      Align(
                        alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20,8,20,5),
                            child: Text(getSelectedListName(),style: TextStyle(fontWeight:FontWeight.w600, fontSize: 20,),),
                          )
                      ),
                      //The List
                      Column(
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20,8,15,8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(list.CategoryName, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            activeColor: Color(0xFF0A3B0D),
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
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
                                              padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
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
                                                      Transform.scale(
                                                        scale: 1.3,
                                                        child: Checkbox(
                                                          value: item.Checked,

                                                          activeColor: Color(0xFF0A3B0D),
                                                          checkColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          onChanged: (bool? newValue) {
                                                              setState(() {
                                                                item.Checked = newValue!;
                                                              });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20,0,15,15),
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
                                          style: TextStyle(color: Colors.black,),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ).toList()
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
  }
}

class ListType{
  IconData icon;
  String label;
  bool isSelected;

  ListType(this.icon,this.label,this.isSelected);
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