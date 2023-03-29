import 'package:flutter/material.dart';

class CheckMarkAnimationProvider extends ChangeNotifier {
  CheckMarkAnimationProvider();

  int checkStateIndex = 0;

  List<Icon> checkState = const [
    Icon(Icons.check_circle, size: 40, color: Color.fromARGB(50, 0, 0, 0)),
    Icon(Icons.check_circle, size: 40, color: Color.fromARGB(200, 0, 150, 0)),
    Icon(Icons.check_circle, size: 40, color: Color.fromARGB(200, 255, 0, 0)),
  ];

  setCheckStateIndex(int index) {
    checkStateIndex = index;
    notifyListeners();
  }
}
