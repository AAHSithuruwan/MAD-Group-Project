import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{

  final String title;

  const CustomAppBar({super.key, required this.title});


  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.title == "Home" ?
              Icon(Icons.home, color: Colors.white, size: 35,)
              : Icon(Icons.arrow_back, color: Colors.white, size: 35,),
          Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24), ),
          Icon(Icons.more_vert, color: Colors.white, size: 35,)
        ],
      ),
      backgroundColor:  Color(0xFF1BA424),
    );
  }
}