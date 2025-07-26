import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Function? onSuffixIconPressed;
  final bool obscureText;
  final Color borderColor;
  final double borderRadius;
  final Color textColor;
  final TextInputType? keyboardType; // Add keyboardType parameter
  final int? maxLength; // Add maxLength parameter

  CustomTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    required this.borderColor,
    required this.borderRadius,
    required this.textColor,
    this.keyboardType, // Add keyboardType parameter
    this.maxLength, // Add maxLength parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      keyboardType: keyboardType, // Pass keyboardType to TextField
      maxLength: maxLength, // Pass maxLength to TextField
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: borderColor),
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(suffixIcon),
          onPressed: () => onSuffixIconPressed!(),
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}