import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/divider_with_text.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/form/signup_form.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.sizeOf(context);
    // Create the TapGestureRecognizer
    final TapGestureRecognizer signInRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Code to execute when "Sign up here" is tapped
        Navigator.pop(context);
      };
    return Scaffold(
      appBar: const Heading(title: 'Sign Up', showBackButton: true),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset("assets/img/app_logo_light.svg",
            //     width: media.width * 0.5, fit: BoxFit.contain),
            //  const Heading(title: 'Sign Up', showBackButton: true),
            const CustomAlignText(
                text: 'Become a part to use this app',
                style: AppTextStyles.subHeading),
            const SizedBox(
              height: 24,
            ),

            const SignupForm(),
            const SizedBox(
              height: 20,
            ),
            const DividerWithText(text: 'Or'),
            const SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Already Have an Account? ',
                    style: AppTextStyles.paragraph,
                  ),
                  TextSpan(
                    text: ' Login Here',
                    recognizer: signInRecognizer, // Attach the recognizer here
                    style: AppTextStyles.paragraphLink,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
