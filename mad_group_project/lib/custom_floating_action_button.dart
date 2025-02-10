import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatefulWidget{
  const CustomFloatingActionButton({super.key});

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){},
      backgroundColor: Colors.white,
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.black, // Border color is black
          width: 2.0, // Border width
        ),
      ),
      child: Icon(Icons.add, size: 35, color: Colors.black,),
    );
  }
}