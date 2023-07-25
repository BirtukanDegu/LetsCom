import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../tabs/HomeTab.dart';
import '../tabs/ScheduleTab.dart';

class HHome extends StatefulWidget {
  static String routeName = "/home";
  const HHome({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HHome> {
  int _selectedIndex = 0;
  
  void goToSchedule() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeTab(
        onPressedScheduleCard: goToSchedule,
      ),
      ScheduleTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(MyColors.primary),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: screens[_selectedIndex],
      ),
    );
  }
}
