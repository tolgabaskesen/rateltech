import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier with ChangeNotifier {
  String _LoginUser = "";
  String get LoginUser => _LoginUser;
  late int _userCorrectPoint;
  int get userCorrectPoint => _userCorrectPoint;
  late int _userFalsePoint;
  int get userFalsePoint => _userFalsePoint;

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

  getCorrectPoint(int point) async {
    _userCorrectPoint = point;
    notifyListeners();
  }

  getFalsePoint(int point) {
    _userFalsePoint = point;
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
    getCorrectPoint(user.getInt(newUser + "correct")!);
    getFalsePoint(user.getInt(newUser + "false")!);
    notifyListeners();
  }

  void correctAnswer(String sendUser) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    int newPoint = user.getInt(sendUser + "correct")! + 1;
    user.setInt(sendUser + "correct", newPoint);
    notifyListeners();
  }

  void falseAnswer(String sendUser) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    int newPoint = user.getInt(sendUser + "false")! + 1;
    user.setInt(sendUser + "false", newPoint);
    notifyListeners();
  }
}
