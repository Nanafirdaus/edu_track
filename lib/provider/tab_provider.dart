import 'package:flutter/material.dart';

class TabProvider extends ChangeNotifier{
  bool isClassTab = true;

  void changeTab(bool value){
    isClassTab = value;
    notifyListeners();
  }
}