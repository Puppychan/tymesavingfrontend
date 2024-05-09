
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/utils/AppColor.dart';
import 'package:tymesavingfrontend/utils/AppTextStyle.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text, style: AppTextStyles.button),
      ),
    );
  }
}