import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget{
  const CustomBottomNavigationBar({super.key});


  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

  int _selectedIndex = 0;

  void onItemTapped(int index){
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Color(0xFFD9D9D9),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home_outlined, size: 32),
            onPressed: () => onItemTapped(0),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, size: 32),
            onPressed: () => onItemTapped(1),
          ),
          SizedBox(width: 35), // Space for the FloatingActionButton
          IconButton(
            icon: Icon(Icons.add_shopping_cart_outlined, size: 32),
            onPressed: () => onItemTapped(2),
          ),
          IconButton(
            icon: Icon(Icons.menu, size: 32),
            onPressed: () => onItemTapped(3),
          ),
        ],
      ),
    );
  }
}