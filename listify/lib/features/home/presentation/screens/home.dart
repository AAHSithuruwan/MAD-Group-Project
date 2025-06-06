import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/Models/ListifyList.dart';
import 'package:listify/core/services/listify_list_service.dart';
import 'package:listify/core/services/local_notification_service.dart';
import 'package:listify/core/services/notification_handler.dart';
import 'package:listify/core/services/auth_service.dart';
import '../../../../core/Models/ListItem.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = true;
  String listEmptyMessage = "No items in the list for today";
  final TextEditingController _listNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<ListifyList> lists = [];
  ListifyListService listifyListService = ListifyListService();

  Future<void> getLists(DateTime? startDate, DateTime? endDate) async{
    List<ListifyList> listifyLists = await listifyListService.getListsByDateRange(startDate: startDate, endDate: endDate);
    setState(() {
      lists = listifyLists;
      isLoading = false;
    });
  }

  Future<void> initializeLists() async {
    DateTime today = DateTime.now();
    DateTime todayOnly = DateTime(today.year, today.month, today.day);

    await getLists(todayOnly, todayOnly);
  }

  List<ListType> listTypes = [
    ListType(Icons.today, "Today", true),
    ListType(Icons.calendar_month_outlined, "Tomorrow", false),
    ListType(Icons.watch_later, "Later", false),
    ListType(Icons.library_books, "All", false),
  ];

  @override
  void initState(){
    super.initState();
    NotificationHandler().startListeningToNotifications();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initializeLists();
    listifyListService.checkAndAddRecurringItems();

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
                      FutureBuilder<Map<String, dynamic>?>(
                        future: AuthService().getCurrentUserProfile(),
                        builder: (context, snapshot) {
                          final profile = snapshot.data;
                          final photoURL = profile?['photoURL'] as String? ?? '';
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: photoURL.isNotEmpty
                                ? NetworkImage(photoURL)
                                : const AssetImage("assets/images/placeholder.png") as ImageProvider,
                          );
                        },
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
                                      isLoading = true;
                                      for(var i in listTypes){
                                        i.isSelected = false;
                                      }
                                      item.isSelected = true;

                                      DateTime today = DateTime.now();
                                      DateTime todayOnly = DateTime(today.year, today.month, today.day);

                                      if(index == 0){
                                        getLists(todayOnly,todayOnly);
                                        listEmptyMessage = "No items in the list for today";
                                      }
                                      else if(index == 1){
                                        getLists(todayOnly.add(Duration(days: 1)), todayOnly.add(Duration(days: 1)));
                                        listEmptyMessage = "No items in the list for tomorrow";
                                      }
                                      else if(index == 2){
                                        getLists(todayOnly.add(Duration(days: 2)),null);
                                        listEmptyMessage = "No items in the list for later";
                                      }
                                      else{
                                        getLists(null,null);
                                        listEmptyMessage = "No items in the list";
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
              isLoading ?
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: SpinKitThreeBounce(
                        color: Colors.green,
                        size: 40.0,
                      ),),
                    ],
                  ),
                )
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
                                            child: IconButton(onPressed: () {
                                              context.push(
                                                          '/list-sharing', 
                                                          extra: {
                                                            'listId':
                                                                list.docId,
                                                            'listName':
                                                                list.name,
                                                          },
                                                        );
                                              
                                            }, icon: Icon(Icons.share ,size:  23,)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    list.items.isEmpty ?
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0,0,0,30),
                                          child: Text(listEmptyMessage),
                                        )
                                    :
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
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onLongPress: () {
                                                          context.push('/quantity-update', extra: {'listItem': item, 'listId': list.docId});
                                                        },
                                                        onTap: () {
                                                          //context.push('/quantity-update', extra: {'listItem': item, 'listId': list.docId});
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text("Item Details",textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                                                                content: Text("Name:  ${item.name} \n\nCategory:  ${item.category} \n\nQuantity:  ${item.quantity} \n\nRequired Date:  ${item.requiredDate}"),
                                                                actions: [
                                                                  TextButton(
                                                                    child: Text("Close", style: TextStyle(color: Colors.green),),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Flexible(child: Text(item.name, style: TextStyle(fontSize: 18))),
                                                              Flexible(child: Text(item.quantity, style: TextStyle(fontSize: 18))),
                                                            ],
                                                          ),
                                                        )
                                                      ),
                                                    ),
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

        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'fab2',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: Text('Create New List',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter List Name",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'List name cannot be empty';
                        }
                        return null;
                      },
                      controller: _listNameController,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Create',style: TextStyle(color: Colors.green),),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String listName = _listNameController.text;
                          String message = "List Creation Unsuccessful";
                          if (await listifyListService.createList(listName)) {
                            message = "List Created Successfully";
                          }
                          Navigator.of(context).pop();
                          _listNameController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(message)),
                              duration: Duration(seconds: 2), // Optional
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating, // Optional
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              }
            );
          },
          label: Text("Create List", style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      );
  }

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }
}

class ListType{
  IconData icon;
  String label;
  bool isSelected;

  ListType(this.icon,this.label,this.isSelected);
}