import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  const DropDownWidget({super.key,required this.items,this.value,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        items: items.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(),
        value: value,
        onChanged: onChanged
    );
  }
}