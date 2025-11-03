import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';

class CommonTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData icon;


   const CommonTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: Container(
          margin: const EdgeInsets.only(top: 11),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Icon(icon),
              Container(height: 20, width: 1, color: Colors.grey),
            ],
          ),
        ),
        hintText: hintText,
        filled: true,
        fillColor: AppColors.softWhite,
        hintStyle: TextStyle(color: AppColors.grayNeutral),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grayNeutral),
        ),
      ),
    );
  }
}


