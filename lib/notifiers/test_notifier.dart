import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestNotifier with ChangeNotifier {
  // ignore: non_constant_identifier_names
  String _LoginUser = "";
  // ignore: non_constant_identifier_names
  String get LoginUser => _LoginUser;

  int _userCorrectPoint = 0;
  int get userCorrectPoint => _userCorrectPoint;
  int _userFalsePoint = 0;
  int get userFalsePoint => _userFalsePoint;
  setCorrectPoint(int point) async {
    _userCorrectPoint = point;
    print(_userCorrectPoint);
    notifyListeners();
  }

  setFalsePoint(int point) {
    _userFalsePoint = point;
    print(_userFalsePoint);
    notifyListeners();
  }

  void correctAnswer(String sendUser) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    int newPoint = user.getInt(sendUser + "correct")! + 1;
    user.setInt(sendUser + "correct", newPoint);
    _userCorrectPoint = newPoint;
    notifyListeners();
  }

  void falseAnswer(String sendUser) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    int newPoint = user.getInt(sendUser + "false")! + 1;
    user.setInt(sendUser + "false", newPoint);
    _userFalsePoint = newPoint;
    notifyListeners();
  }
}
