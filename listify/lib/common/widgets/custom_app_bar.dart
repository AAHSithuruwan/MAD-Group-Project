import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{

  final String title;

  final Function? selectHomePage;

  final bool displayTitle;

  const CustomAppBar({super.key, required this.title, this.selectHomePage, required this.displayTitle});


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
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: (){
                if(widget.selectHomePage != null){
                  widget.selectHomePage!();
                }
                else{
                Navigator.pop(context);
                }
              },
              icon: Icon(Icons.arrow_back_ios,size: 35,)),
          widget.displayTitle == true ?
              Text(widget.title)
              :
              Text(""),
          Text(""),
        ],
      ),
      backgroundColor:  Colors.white,
    );
  }
}