import 'package:flutter/material.dart';
import 'package:rateltech/notifiers/test_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier with ChangeNotifier {
  // ignore: non_constant_identifier_names
  String _LoginUser = "";
  // ignore: non_constant_identifier_names
  String get LoginUser => _LoginUser;

  logOut() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    user.setString("user", "");
    _LoginUser = "";
    notifyListeners();
  }

  setLoginUserFirst(String newUser) {
    _LoginUser = newUser;
    notifyListeners();
  }

  void login(String newUser) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    user.setString(newUser, newUser);
    user.setString("user", newUser);
    if (user.getInt(newUser + "correct") == null) {
      user.setInt(newUser + "correct", 0);
    }
    if (user.getInt(newUser + "false") == null) {
      user.setInt(newUser + "false", 0);
    }
    setLoginUserFirst(newUser);
    TestNotifier().setCorrectPoint(user.getInt(newUser + "correct")!);
    TestNotifier().setFalsePoint(user.getInt(newUser + "false")!);
    notifyListeners();
  }
}
