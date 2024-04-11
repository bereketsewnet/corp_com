import 'package:flutter/material.dart';

import '../../../common/utils/colors.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final void Function(String)? onChange;
  final TextInputType? type;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChange,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        onChanged: onChange,
        controller: controller,
        obscureText: obscureText,
        keyboardType: type,
        style: const TextStyle(
          color: greenColor,
          decoration: TextDecoration.none,
        ),
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: messageColor),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: tabColor),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            fillColor: appBarColor,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: greenColor)),
      ),
    );
  }
}
