import 'package:flutter/material.dart';
import '../screens/assistant_detail.dart';
import '../screens/home.dart';
import '../../../../model/User.dart' as model;

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => HHome(),
  '/detail': (context) => SliverAssistantDetail(
      img: ModalRoute.of(context)!.settings.arguments as ImageProvider<Object>,
      assUser: ModalRoute.of(context)!.settings.arguments as model.User,
      name: ModalRoute.of(context)!.settings.arguments as String,
      uid: ModalRoute.of(context)!.settings.arguments as String),
};
