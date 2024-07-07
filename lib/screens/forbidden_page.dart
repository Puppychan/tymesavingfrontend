import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';

class ForbiddenPage extends StatelessWidget {
  // final VoidCallback onRetry;

  const ForbiddenPage({super.key});

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
              'assets/img/forbidden.svg',
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              fit: BoxFit.cover,
            ), // Add this line
            const SizedBox(height: 16.0),
            Text(
              'An error occurred 403!',
              overflow: TextOverflow.visible,
              // style: Theme.of(context).textTheme.headline4,
              style: Theme.of(context).textTheme.headlineLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              'You are not allowed to access this page!',
              overflow: TextOverflow.visible,
              // style: Theme.of(context).textTheme.headline4,
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
                // Pop 2 times to go back to the previous page
                Navigator.pop(context);
                Navigator.pop(context);
              },
              theme: AppButtonTheme.yellowBlack,
              title: 'Back to Previous Page',
            ),
          ],
        ),
      ),
    ));
  }
}
