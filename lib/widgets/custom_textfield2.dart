import 'package:flutter/material.dart';

class TextFieldWidget2 extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final String hintText;
  final Widget prefixIcon;
  final TextCapitalization textCapitalization;
  const TextFieldWidget2({
    required this.textEditingController,
    required this.textCapitalization,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              15,
            ),
          ),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              15,
            ),
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
