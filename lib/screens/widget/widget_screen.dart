import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_com/screens/chat/pages/home/home_page.dart';
import 'package:let_com/screens/home/home_screen.dart';

import 'package:let_com/screens/sign_in/sign_in_screen.dart';
import 'package:let_com/size_config.dart';

class WidgetScreen extends StatelessWidget {
  const WidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('hey');
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return HomeScreen(
                uId: snapshot.data!.uid,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return SignInScreen();
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
          return SignInScreen();
        },
      ),
    );
  }
}
