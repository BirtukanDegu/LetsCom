import 'package:flutter/material.dart';
import '../screens/HI_detail.dart';
import '../screens/home.dart';


Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => AHome(),
  '/detail': (context) => SliverAssistantDetail(),
};
