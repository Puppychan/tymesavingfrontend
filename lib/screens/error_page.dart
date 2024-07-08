import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';

class ErrorPage extends StatelessWidget {
  static const String routeName = '/errorPage'; // Add this line
  final String errorMessage;
  final int statusCode;
  // final VoidCallback onRetry;

  const ErrorPage(
      {super.key, required this.errorMessage, required this.statusCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const Heading(title: 'Error'),
        body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/img/error.svg',
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              fit: BoxFit.cover,
            ), // Add this line

            Text(
              'An error occurred ${statusCode.toString()}!',
              overflow: TextOverflow.visible,
              // style: Theme.of(context).textTheme.headline4,
              style: Theme.of(context).textTheme.headlineLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              errorMessage,
              // style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.headlineMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: onRetry,
            //   child: const Text('Retry'),
            // ),
            // const SizedBox(height: 8.0),
            PrimaryButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInView(),
                  ),
                  (_) => false,
                );
              },
              theme: AppButtonTheme.yellowBlack,
              title: 'Go Back To Sign In Page',
            ),
            const SizedBox(height: 16.0),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Or Back to Previous Page',
                    style: AppTextStyles.paragraphLinkBlue(context)
                        .copyWith(fontSize: 17.0))),
          ],
        ),
      ),
    ));
  }
}
