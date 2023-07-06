import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:let_com/screens/home/HI_pages/tabs/ScheduleTab.dart';
import 'package:let_com/screens/home/home_screen.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    final Color activeIconColor = kPrimaryColor;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Home Icon.svg",
                color: selectedMenu == MenuState.home
                    ? activeIconColor
                    : inActiveIconColor,
              ),
              onPressed: () {
                if (selectedMenu != MenuState.home) {
                  Navigator.pushNamed(context, HomeScreen.routeName);
                }
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Heart Icon.svg",
                color: selectedMenu == MenuState.favorite
                    ? activeIconColor
                    : inActiveIconColor,
              ),
              onPressed: () {
                if (selectedMenu != MenuState.favorite) {
                  // Handle the onPressed event for the favorite icon.
                }
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/calendar Icon.svg",
                color: selectedMenu == MenuState.schedule
                    ? activeIconColor
                    : inActiveIconColor,
              ),
              onPressed: () {
                if (selectedMenu != MenuState.schedule) {
                  Navigator.pushNamed(context, ScheduleTab.routeName);
                }
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Bell.svg",
                color: selectedMenu == MenuState.notification
                    ? activeIconColor
                    : inActiveIconColor,
              ),
              onPressed: () {
                if (selectedMenu != MenuState.notification) {
                  // Handle the onPressed event for the notification icon.
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
