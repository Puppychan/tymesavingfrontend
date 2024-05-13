import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/layouts/login_form.dart';
// import 'package:tymesavingfrontend/components/SecondaryButton.dart';
import 'package:tymesavingfrontend/screens/SignUpPage.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isRemember = false;
  // final TapGestureRecognizer _signUpTapRecognizer = TapGestureRecognizer()
  //   ..onTap = () {
  //     // Handle the tap event, e.g., by navigating to a sign-up page
  //     print('Navigate to sign-up screen');
  //   };

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset("assets/img/app_logo_light.png",
              //     width: media.width * 0.5, fit: BoxFit.contain),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign In',
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.left,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to manage your money!',
                  style: AppTextStyles.subHeading,
                  textAlign: TextAlign.left,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ),
              SizedBox(
                height: 24,
              ),

              LoginForm(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'New to brainy academy?',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                        // fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0.10,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign up here',
                      // recognizer:
                      //     _signUpTapRecognizer, // Attach the recognizer to this TextSpan

                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        // fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        height: 0.10,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "if you don't have an account yet?",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.cream, fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              // SecondaryButton(
              //   title: "Sign up",
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SignUpView(),
              //       ),
              //     );
              //   },
              // ),

              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context)
              //         .push(MaterialPageRoute(builder: (ctx) => const SignInView()));
              //   },
              //   child: Text("Don't have an account? Sign Up"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
