import 'package:flutter/material.dart';

import 'components/body.dart';

class SignupSuccessScreen extends StatelessWidget {
  final String uid;
  static String routeName = "/signup_success";

  const SignupSuccessScreen({super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Signup Success"),
      ),
      body: Body(uid: uid),
    );
  }
}
