import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:tymesavingfrontend/components/CustomButton.dart';
import 'package:tymesavingfrontend/components/CustomInputField.dart';
import 'package:tymesavingfrontend/utils/AppColor.dart';
import 'package:tymesavingfrontend/utils/AppTextStyle.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sign in with Email', style: AppTextStyles.heading)),
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Input your budget saving account!', style: AppTextStyles.subHeading),
            const CustomInputField(
              label: 'Email',
              hintText: 'Type your email',
            ),
            const CustomInputField(
              label: 'Password',
              hintText: 'Type your password',
              isPassword: true,
            ),
            CustomButton(
              text: 'Sign in Now',
              onPressed: () {
                // Handle sign in
              },
            ),
            const Text(
              'Or',
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.center,
            ),
            CustomButton(
              text: 'Sign in with Apple',
              onPressed: () {
                // Handle Apple sign in
              },
            ),
            CustomButton(
              text: 'Sign in with Google',
              onPressed: () {
                // Handle Google sign in
              },
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: AppTextStyles.subHeading,
                children: [
                  TextSpan(text: 'New to us?'),
                  TextSpan(text: 'Sign Up Here', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.highlightText)),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: AppTextStyles.subHeading,
                children: [
                  TextSpan(text: 'By using our services you are agreeing to our\n'),
                  TextSpan(text: 'Terms', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.highlightText)),
                  TextSpan(text: ' and '),
                  TextSpan(text: 'Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.highlightText)),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
// class SignInScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//
//   }
// }