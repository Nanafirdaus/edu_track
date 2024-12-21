import 'package:flutter/material.dart';

TextStyle kTextStyle(
  double size, {
  bool isBold = false,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontFamily: 'Poppins',
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  );
}
