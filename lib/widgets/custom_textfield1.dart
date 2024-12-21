import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final FormFieldValidator formFieldValidator;
  final TextEditingController textEditingController;
  final String label;
  final String hintText;
  final Widget prefixIcon;

  const TextFieldWidget({
    required this.formFieldValidator,
    required this.textEditingController,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: formFieldValidator,
      controller: textEditingController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
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
