import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/utils/AppColor.dart';  // Assuming you have defined colors here
import 'package:tymesavingfrontend/utils/AppTextStyle.dart';  // Assuming you have defined text styles here

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;  // Optional: Adding controller to manage text input

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPassword = false,  // Defaulting isPassword to false if not provided
    this.controller,  // Optional: Controller can be passed or managed internally
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),  // Example TextStyle, modify as needed
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[200],  // Example filler color, use AppColor if defined
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 16),  // Added space below the input field
      ],
    );
  }
}
