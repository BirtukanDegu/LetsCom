import 'package:flutter/material.dart';
import '../screens/assistant_detail.dart';
import '../screens/home.dart';


Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => HHome(),
  '/detail': (context) => SliverAssistantDetail(),
};
