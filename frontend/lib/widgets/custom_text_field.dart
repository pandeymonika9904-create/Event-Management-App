import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x33FFFFFF), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: AppTheme.textDark),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.textMuted),
          prefixIcon: Icon(prefixIcon, color: AppTheme.textMuted),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppTheme.secondaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }
}
