import 'package:flutter/material.dart';
import 'package:let_com/components/coustom_bottom_nav_bar.dart';
import 'package:let_com/enums.dart';
import '../home/HI_pages/screens/home.dart';

// import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HHome(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
