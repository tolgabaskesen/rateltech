import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestNotifier with ChangeNotifier {
  // ignore: non_constant_identifier_names
  String _LoginUser = "";
  // ignore: non_constant_identifier_names
  String get LoginUser => _LoginUser;


  late int _userCorrectPoint;
  int get userCorrectPoint => _userCorrectPoint;
  late int _userFalsePoint;
  int get userFalsePoint => _userFalsePoint;
  setCorrectPoint(int point) async {
    _userCorrectPoint = point;
    notifyListeners();
  }

  setFalsePoint(int point) {
    _userFalsePoint = point;
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
