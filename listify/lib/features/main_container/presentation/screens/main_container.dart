import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'package:listify/features/item/presentation/screens/create_items_user.dart';
import 'package:listify/features/menu/presentation/screens/menu_screen.dart';
import 'package:listify/features/notifications/presentation/screens/notifications_screen.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_floating_action_button.dart';
import '../../../home/presentation/screens/home.dart';

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

  void selectHomePage() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    return Scaffold(
      appBar:
          _selectedIndex == 0
              ? null
              : (_selectedIndex == 1
                  ? CustomAppBar(
                    title: "Notifications",
                    selectHomePage: selectHomePage,
                    displayTitle: true,
                  )
                  : (_selectedIndex == 2
                      ? CustomAppBar(
                        title: "Shopping",
                        displayTitle: false,
                        selectHomePage: selectHomePage,
                      )
                      : CustomAppBar(
                        title: "Menu",
                        displayTitle: true,
                        selectHomePage: selectHomePage,
                      ))),

      body:
          _selectedIndex == 0
              ? Home()
              : (_selectedIndex == 1
                  ? (userId != null
                      ? NotificationsScreen(userId: userId)
                      : const Center(child: Text("User not logged in")))
                  : (_selectedIndex == 2 ? CreateItemsUser() : MenuScreen())),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: CustomFloatingActionButton(),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // FAB in center

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 2,
            ), // Top border
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
          color:
              isSelected
                  ? Color(0x1A1BA424)
                  : Colors.transparent, // Green background for selected icon
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
