import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: "About us Updated",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Engineering Journal\nBudget Management App',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
              selectionColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'NI – Natural Intelligence',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Student name & ID:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Card.filled(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Text(
                    'Tran Mai Nhung',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Tran Nguyen Ha Khanh',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Vo Thanh Thong',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Giang Trong Duong',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Ngo Viet Anh',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Academic supervisor: ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Card.filled(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(children: [
                Text(
                  'Ms. Anna Felipe',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ]),
            ),
            const SizedBox(height: 15),
            Text(
              'Company:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Card.filled(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(children: [
                Text(
                  'Tyme',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ]),
            ),
            const SizedBox(height: 15),
            Text(
              'Project Leader:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Card.filled(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(children: [
                Text(
                  'Mr. Vuong Tran',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Text(
              'Industry supervisors:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Card.filled(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(children: [
                Text(
                  'Mr. Tung Nguyen',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Mr. Lanh Tran',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Mr. Long Nguyen',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
