import 'package:flutter/material.dart';

class CustomTextFormItem extends StatelessWidget {
  final String hintTitle;
  final TextEditingController controller;

  const CustomTextFormItem({
    super.key,
    required this.hintTitle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintTitle,
        border: const OutlineInputBorder(),
      ),
      validator: (input) {
        if (input != null && input.isNotEmpty) {
          return null; // Valid input
        } else {
          return "$hintTitle must not be empty!";
        }
      },
    );
  }
}