import 'package:flutter/material.dart';
import 'package:let_com/screens/chat/pages/home/home_page.dart';

class ChatScreen extends StatelessWidget {
  static String routeName = "/chat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: HomePage(),
    );
  }
}
