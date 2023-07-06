import 'package:flutter/widgets.dart';
import 'package:let_com/screens/complete_profile/complete_profile_screen.dart';
import 'package:let_com/screens/forgot_password/forgot_password_screen.dart';
import 'package:let_com/screens/home/HI_pages/tabs/ScheduleTab.dart';
import 'package:let_com/screens/home/home_screen.dart';
import 'package:let_com/screens/login_success/login_success_screen.dart';
import 'package:let_com/screens/otp/otp_screen.dart';
import 'package:let_com/screens/profile/profile_screen.dart';
import 'package:let_com/screens/sign_in/sign_in_screen.dart';
import 'package:let_com/screens/signup_success/signup_success_screen.dart';
import 'package:let_com/screens/splash/splash_screen.dart';

import 'screens/sign_up/components/body.dart';
import 'screens/sign_up/sign_up_screen.dart';
import './screens/chat/pages/message_page.dart';
import './screens/chat/pages/story/story_page.dart';
import './screens/chat/pages/call/video/video_call_page.dart';

// We use name route
// All our routes will be available here

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ScheduleTab.routeName: (context) => ScheduleTab(),
  Body.routeName: (context) =>
      Body(role: ModalRoute.of(context)!.settings.arguments as String),
  SignupSuccessScreen.routeName: (context) => SignupSuccessScreen(),
  '/message': (context) => MessagePage(),
  '/story': (context) => StoryPage(),
  '/video-call': (context) => VideoCallPage(),
};
