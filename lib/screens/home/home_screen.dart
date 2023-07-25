import 'package:flutter/material.dart';
import '../../model/User.dart' as model;

// import 'package:let_com/components/coustom_bottom_nav_bar.dart';
// import 'package:let_com/enums.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:let_com/screens/home/Assistant_pages/screens/home.dart';
import 'package:provider/provider.dart';
import '../home/HI_pages/screens/home.dart';

// import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  final String uId;
  const HomeScreen({required this.uId});
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      UserProvider _userp = Provider.of(context, listen: false);
      await _userp.refreshUser();

      setState(() {});
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: user == null
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue[700]),
            )
          : user.role == "Impaired"
              ? HHome()
              : AHome(),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
