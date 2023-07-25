import 'dart:ffi';

import 'package:flutter/material.dart';
import '../screens/HI_detail.dart';
import '../screens/home.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => AHome(),
  '/detail': (context) => SliverAssistantDetail(
      accept: ModalRoute.of(context)!.settings.arguments as bool,
      pid: ModalRoute.of(context)!.settings.arguments as String,
      img: ModalRoute.of(context)!.settings.arguments as ImageProvider<Object>,
      address: ModalRoute.of(context)!.settings.arguments as String,
      name: ModalRoute.of(context)!.settings.arguments as String),
};
