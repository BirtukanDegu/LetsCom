import 'package:flutter/material.dart';
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/model/User.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthService _authMethods = AuthService();
  User? get getUser => _user;
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    print(_user);
    notifyListeners();
  }
}
