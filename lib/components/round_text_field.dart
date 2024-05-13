import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';

class RoundTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  // final TextAlign titleAlign;
  final bool obscureText;
  final double componentHeight = 48;
  final String? Function(String?)? validator; // Add a validator parameter

  const RoundTextField(
      {super.key,
      // this.titleAlign = TextAlign.left,
      required this.label,
      required this.placeholder,
      this.controller,
      this.keyboardType,
      this.obscureText =
          false, // Whether the text should be obscured - hidden from view - for passwords
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: AppTextStyles.inputLabel,
              ),
            )
          ],
        ),
        // Space between label and input field
        const SizedBox(
          height: 4,
        ),
        // Input field
        Container(
          height: componentHeight,
          width: double.maxFinite,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.tertiary,
            // border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(componentHeight / 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 1,
              )
            ],
          ),
          child: TextFormField(
            controller: controller,
            // autovalidateMode:AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              // focusedErrorBorder: InputBorder.none,
              hintText: placeholder,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              // errorBorder: InputBorder.none,
              // errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            // validator: validator, // Use the validator
          ),
        )
      ],
    );
  }
}
