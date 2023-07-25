import 'package:flutter/material.dart';
import 'package:let_com/components/default_button.dart';
import 'package:let_com/screens/home/home_screen.dart';
import '../../home/Assistant_pages/screens/home.dart';
import 'package:let_com/size_config.dart';

class Body extends StatelessWidget {
  final String uid;

  const Body({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Signup Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Continue",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            uId: uid,
                          )));
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
