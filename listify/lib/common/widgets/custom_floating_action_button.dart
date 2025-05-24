import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomFloatingActionButton extends StatefulWidget{
  const CustomFloatingActionButton({super.key});

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        onPressed: (){
          context.push('/add-list-items');
        },
        backgroundColor: Colors.white,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.green, // Border color is black
            width: 3.0, // Border width
          ),
        ),
        child: Icon(Icons.add, size: 50, color: Colors.green),
      ),
    );
  }
}