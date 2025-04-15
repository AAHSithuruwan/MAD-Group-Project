import 'package:flutter/material.dart';
import 'package:mad_group_project/custom_app_bar.dart';
import 'package:mad_group_project/features/home/presentation/screens/home.dart';
import 'package:mad_group_project/notifications.dart';
import 'custom_floating_action_button.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ?
        null
          : ( _selectedIndex == 1 ?
              CustomAppBar(title: "Notifications")
              : (_selectedIndex == 2 ?
                null
                : null
      )
      ),

      body: _selectedIndex == 0 ?
            Home()
          : ( _selectedIndex == 1 ?
            Notifications()
          : (_selectedIndex == 2 ?
            null
          : null
      )
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: CustomFloatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // FAB in center

      bottomNavigationBar: Container(
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
