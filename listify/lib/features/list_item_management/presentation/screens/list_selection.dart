import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/services/listify_list_service.dart';
import '../../../../core/Models/Item.dart';
import '../../../../core/Models/ListifyList.dart';

class ListSelection extends StatefulWidget {

  final Item item;

  final String quantity;

  const ListSelection({super.key, required this.item, required this.quantity});

  @override
  _ListSelectionState createState() => _ListSelectionState();
}

class _ListSelectionState extends State<ListSelection> {

  final TextEditingController requiredDateController = TextEditingController();

  List<ListifyList> lists = [];
  ListifyList? selectedList;

  ListifyListService listifyListService = ListifyListService();

  bool isRecurring = false;
  List<String> recurringOptions = ["Daily", "Weekly", "Monthly"];
  int? selectedRecurringIndex;

  Future<void> getLists() async{
    List<ListifyList> returnedLists = await listifyListService.getListsByDateRange();
    setState(() {
      lists = returnedLists;
    });
  }

  Future<bool> addListItem() async{
    if(await listifyListService.addListItem(widget.item, selectedList!.docId!, widget.quantity, requiredDateController.text)){
      if(isRecurring){
        if(await listifyListService.addRecurringItem(itemName: widget.item.name, targetListId: selectedList!.docId!, quantity: widget.quantity, categoryName: widget.item.categoryName, requiredDate: requiredDateController.text, recurringType: recurringOptions[selectedRecurringIndex!])){
          return true;
        }
        else{
          return false;
        }
      }
      else{
        return true;
      }
    }
    else{
      return false;
    }
  }


  @override
  void initState() {
    super.initState();
    getLists();
    selectedRecurringIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = 300; // Height of the image

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Stack(
              children: [
                Image.asset(
                  'assets/images/list_selection.png',
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),

                // Back button
                Positioned(
                  top: 50,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );// Navigate back to the previous screen
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.white,)
                  ),
                ),
              ],
            ),

            // Container wrapping the content
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                height: screenHeight + 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name dropdown
                    const Text(
                      "Select List",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<ListifyList>(
                      value: selectedList,
                      items: lists.map((list) {
                        return DropdownMenuItem<ListifyList>(
                          value: list,
                          child: Text(list.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedList = value;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF106A16), width: 1), // Green outline
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF106A16), width: 2), // Thicker green when focused
                        ),
                      ),
                    ),

                    const SizedBox(height: 40,),

                    const Text(
                      "Select Required Date",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: requiredDateController,
                      readOnly: true, // Prevent manual editing
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF106A16), width: 1), // Green outline
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF106A16), width: 2), // Thicker green when focused
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          requiredDateController.text =
                          "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    // Recurring checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isRecurring,
                          onChanged: (value) {
                            setState(() {
                              isRecurring = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF106A16),
                        ),
                        const Text(
                          "Recurring Item",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    // Recurring options dropdown
                    if (isRecurring) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        value: selectedRecurringIndex,
                        items: recurringOptions.map((option) {
                          return DropdownMenuItem<int>(
                            value: recurringOptions.indexOf(option),
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRecurringIndex = value;
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text("Recurring Option"),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF106A16), width: 1), // Green outline
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF106A16), width: 2), // Thicker green when focused
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () async {
                            if(selectedList == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text('Please Select a List')),
                                  duration: Duration(seconds: 2), // Optional
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,// Optional
                                ),
                              );
                            }
                            else if(requiredDateController.text == ''){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text('Please Select a Required Date')),
                                  duration: Duration(seconds: 2), // Optional
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,// Optional
                                ),
                              );
                            }
                            else{
                              if(await addListItem()){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Item Added Successfully',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.green,  // Optional
                                  ),
                                );
                                context.go('/');
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text('Item Adding Unsuccessful')),
                                    duration: Duration(seconds: 2), // Optional
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,// Optional
                                  ),
                                );

                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF106A16),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 14),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          child: const Text("Add"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}