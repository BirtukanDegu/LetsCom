import 'package:flutter/material.dart';

import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  final String uId;
  static String routeName = "/login_success";

  const LoginSuccessScreen({super.key, required this.uId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Login Success"),
      ),
      body: Body(uId: uId),
    );
  }
}
