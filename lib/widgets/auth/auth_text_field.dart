import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 42),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 12),
          hintStyle: const TextStyle(fontSize: 12),
          errorStyle: const TextStyle(fontSize: 11, height: 1.2),
          errorMaxLines: 2,
          prefixIcon: Icon(prefixIcon, size: 18),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode:
            autovalidateMode ?? AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
