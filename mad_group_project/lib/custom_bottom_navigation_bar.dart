import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 2), // Top border
        ),
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildIcon(0, Icons.home_outlined),
            _buildIcon(1, Icons.notifications_none_outlined),
            SizedBox(width: 35), // Space for the FloatingActionButton
            _buildIcon(2, Icons.add_shopping_cart_outlined),
            _buildIcon(3, Icons.menu),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int index, IconData icon) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0x1A1BA424) : Colors.transparent, // Green background for selected icon
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 32,
          color: Colors.black54, // White icon when selected
        ),
      ),
    );
  }
}
