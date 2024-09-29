// widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // Added for flexibility
  final IconData? icon; // New optional icon field

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.icon, // Added icon parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.padding / 2),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType, // Assigning keyboard type
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.grey[600]), // Change hint text color
          prefixIcon: icon != null
              ? Icon(icon, color: AppColors.deepNavy)
              : null, // Adding icon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
            borderSide: const BorderSide(
                color: AppColors.deepNavy, width: 2), // Border color and width
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
            borderSide: const BorderSide(
                color: AppColors.coral, width: 2), // Focused border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
            borderSide: const BorderSide(
                color: AppColors.softBlue, width: 1), // Enabled border color
          ),
          filled: true,
          fillColor: AppColors.softBlue,
        ),
        validator: validator,
      ),
    );
  }
}
