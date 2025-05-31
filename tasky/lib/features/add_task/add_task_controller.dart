import 'package:flutter/material.dart';

class AddTaskController with ChangeNotifier {
  bool isON = true;

  void toggleSwitch(bool value) {
    isON = value;
    notifyListeners();
  }
}
