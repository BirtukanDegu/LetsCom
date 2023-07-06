import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:let_com/routes.dart';
import 'package:let_com/screens/splash/splash_screen.dart';
import 'package:let_com/screens/widget/widget_screen.dart';
import 'package:let_com/size_config.dart';
import 'package:let_com/theme.dart';

// import 'package:lets_com/screens/profile/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),

      home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      // initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
