import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorPage extends StatelessWidget {
  static const String routeName = '/errorPage'; // Add this line
  final String errorMessage;
  final int statusCode;
  // final VoidCallback onRetry;

  const ErrorPage(
      {super.key, required this.errorMessage, required this.statusCode});

  String _generateErrorMessage(int statusCode) {
    switch (statusCode) {
      case 404:
        return 'The requested resource was not found.';
      case 401:
        return 'You are not authorized to access this resource.';
      case 403:
        return 'You are forbidden from accessing this resource.';
      case 408:
        return 'The request timed out.';
      case 503:
        return 'The server is unavailable.';
      case 500:
        return 'An error occurred on the server.';
      default:
        return 'An error occurred.';
    }
  }

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
              // 'An error occurred ${statusCode.toString()}!',
              'An error occurred!',
              overflow: TextOverflow.visible,
              // style: Theme.of(context).textTheme.headline4,
              style: Theme.of(context).textTheme.headlineLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            Text(
              // errorMessage,
              _generateErrorMessage(statusCode),
              // style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Text(
              'Please try again later or contact support if the issue persists.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            Text(
              'Contact us: enquiries@rmit.edu.vn',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: () {
                try {
                  Future.microtask(() async {
                    const email = 'enquiries@rmit.edu.vn';
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: email,
                      queryParameters: {
                        'subject': 'Support Request',
                      },
                    );
                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    }
                  });
                } catch (e) {
                  ErrorDisplay.showErrorToast(
                      'Could not launch email client.', context);
                }
              },
              icon: const Icon(Icons.email_outlined),
              label: Text(
                'Contact Support',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                  // back to page cause error
                  Navigator.pop(context);
                  // back to previous page before error
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
