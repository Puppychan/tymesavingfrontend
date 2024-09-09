import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/divider_with_text.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/form/login_form.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_up_page.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/utils/dismiss_keyboard.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.sizeOf(context);
    // Create the TapGestureRecognizer
    final TapGestureRecognizer signUpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // dismiss the keyboard
        dismissKeyboardAndAct(context);
        // Code to execute when "Sign up here" is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpView()),
        );
      };
    return GestureDetector(
        onTap: () {
          dismissKeyboardAndAct(context);
        },
        child: Scaffold(
          appBar: const Heading(title: 'Sign In'),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppPaddingStyles.pagePaddingIncludeSubText,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset("assets/img/app_logo_light.svg",
                //     width: media.width * 0.5, fit: BoxFit.contain),
                CustomAlignText(
                    text: 'Login to manage your money!',
                    style: Theme.of(context).textTheme.headlineMedium!),
                const SizedBox(
                  height: 24,
                ),

                const LoginForm(),
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
                      TextSpan(
                        text: 'New to this application? ',
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      TextSpan(
                        text: ' Sign up',
                        recognizer:
                            signUpRecognizer, // Attach the recognizer here
                        style: AppTextStyles.paragraphLinkYellow(context),
                      ),
                      TextSpan(
                        text: ' now',
                        recognizer:
                            signUpRecognizer, // Attach the recognizer here
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
