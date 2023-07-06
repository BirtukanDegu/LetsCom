import 'package:flutter/material.dart';
import 'package:let_com/screens/sign_up/components/sign_up_option.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SignOption(),
    );
  }
}
