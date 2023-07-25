import 'package:flutter/material.dart';
import 'package:let_com/components/have_account_text.dart';
import '../../sign_up/components/body.dart';
import '../../../constants.dart';

import '../../../size_config.dart';

class SignOption extends StatefulWidget {
  @override
  _SignOptionState createState() => _SignOptionState();
}

class _SignOptionState extends State<SignOption> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Text(
            "Register to LETSCOM",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(28),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            "Register as a hearing impaired person \nor Register as an assistant",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          SizedBox(height: getProportionateScreenHeight(30)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20), // Add margin from left and right
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Body(role: "assistant"),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0), // Add padding to the text
                      child: Text(
                        "Register as Assistant",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(15),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: kPrimaryColor, // Set the button color
                      onPrimary: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20), // Add margin from left and right
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Body(role: "Impaired"),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0), // Add padding to the text
                      child: Text(
                        "Register as Hearing Impaired",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(15),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: kPrimaryColor, // Set the button color
                      onPrimary: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(50)),
          HaveAccountText(),
        ],
      ),
    );
  }
}
