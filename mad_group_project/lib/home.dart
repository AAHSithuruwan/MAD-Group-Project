import 'package:flutter/material.dart';
import 'package:mad_group_project/custom_app_bar.dart';
import 'package:mad_group_project/custom_bottom_navigation_bar.dart';
import 'package:mad_group_project/custom_floating_action_button.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(title: "Home"),
        body: Text("data"),
        floatingActionButton: CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // FAB in center
        bottomNavigationBar: CustomBottomNavigationBar(),
      );
  }
}