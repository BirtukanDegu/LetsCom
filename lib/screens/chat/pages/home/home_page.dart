import 'package:flutter/material.dart';
import '../../shared/constants/color_constants.dart';
import '../home/tabs/chat_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabs = <Widget>[
    ChatTab(),
  ];

  late PageController _pageController;
  int currentTab = 1;

  goToTab(int page) {
    setState(() {
      currentTab = page;
    });

    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: tabs,
        controller: _pageController,
      ),
    );
  }

  Widget _bottomAppBarItem({icon, page}) {
    return IconButton(
      splashRadius: 20,
      onPressed: () => goToTab(page),
      icon: Icon(
        icon, 
        color: currentTab == page ? ColorConstants.primaryColor : Colors.blueGrey.shade200, 
        size: 22,
      ),
    );
  }
}
