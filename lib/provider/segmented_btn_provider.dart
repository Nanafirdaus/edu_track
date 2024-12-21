import 'package:flutter/material.dart';

class SegmentedButtonController extends ChangeNotifier {
  bool classIsSelected = true;

  toggleSelection(bool value) {
    classIsSelected = value;
    notifyListeners();
  }
}