import 'package:flutter/material.dart';
import 'package:listify/core/Models/ListifyList.dart';
import 'package:listify/core/services/listify_list_service.dart';
import '../../../../core/Models/ListItem.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ListifyListService listifyListService = new ListifyListService();

  List<ListifyList> lists = [];

  List<ListType> listTypes = [
    ListType(Icons.today, "Today", true),
    ListType(Icons.calendar_month_outlined, "Tomorrow", false),
    ListType(Icons.watch_later, "Later", false),
    ListType(Icons.library_books, "All", false),
  ];

  Future<void> getAllLists() async{
    List<ListifyList> listifyLists = await listifyListService.getAllLists();
    setState(() {
      lists = listifyLists;
    });
  }

  Future<void> getTodayLists() async{
    List<ListifyList> listifyLists = await listifyListService.getTodayLists();
    setState(() {
      lists = listifyLists;
    });
  }

  Future<void> getTomorrowLists() async{
    List<ListifyList> listifyLists = await listifyListService.getTomorrowLists();
    setState(() {
      lists = listifyLists;
    });
  }

  Future<void> getLaterLists() async{
    List<ListifyList> listifyLists = await listifyListService.getLaterLists();
    setState(() {
      lists = listifyLists;
    });
  }

  @override
  void initState(){
    super.initState();
    getTodayLists();
  }

  bool listCheckBox(List<ListItem> items){
    bool checked = true;
    for (var item in items) {
      if(item.checked == false){
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
      return Scaffold(
        backgroundColor: Color(0xFFF0F4F0),
        body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28,50,28,20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Listify", style: TextStyle(fontFamily: "Labrada", fontSize: 40),),
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
              ),
              //Button set
              Container(
                color: Colors.white,
                child: Padding(
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
                                      if(index == 0){
                                        getTodayLists();
                                      }
                                      else if(index == 1){
                                        getTomorrowLists();
                                      }
                                      else if(index == 2){
                                        getLaterLists();
                                      }
                                      else{
                                        getAllLists();
                                      }
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
                      ), // Greater than sign
                    ],
                  ),
                ),
              ),
              lists.isEmpty == true ?
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                          width: 200,
                          child: Image(image: AssetImage("assets/images/list.png"),)),
                    ],
                  ))
                  :
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Color(0xFFF0F4F0),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        //The List
                        Column(
                          children: lists.map((list) =>
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
                                          Text(list.name, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                          Transform.scale(
                                            scale: 1.3,
                                            child: Checkbox(
                                              activeColor: Color(0xFF0A3B0D),
                                              checkColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              value: listCheckBox(list.items),
                                              onChanged: (bool? newValue) {
                                                setState(() {
                                                  for(var item in list.items){
                                                    item.checked = newValue!;
                                                    listifyListService.checkItem(newValue, item.docId!, list.docId!);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: list.items
                                          .take(list.showAllItems ? list.items.length : 4)
                                          .map((item) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(item.name, style: TextStyle(fontSize: 18),),
                                                    Row(
                                                      children: [
                                                            Container(),
                                                        Transform.scale(
                                                          scale: 1.3,
                                                          child: Checkbox(
                                                            value: item.checked,

                                                            activeColor: Color(0xFF0A3B0D),
                                                            checkColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                            onChanged: (bool? newValue) {
                                                                setState(() {
                                                                  listifyListService.checkItem(newValue!, item.docId!, list.docId!);
                                                                  item.checked = newValue;
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
                                    if (list.items.length > 4)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            list.showAllItems = !(list.showAllItems);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(8,0,8,10),
                                          child: Text(
                                            list.showAllItems ? "<<Show Less>>" : "<<See More>>",
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
          ),
      );
  }
}

class ListType{
  IconData icon;
  String label;
  bool isSelected;

  ListType(this.icon,this.label,this.isSelected);
}

