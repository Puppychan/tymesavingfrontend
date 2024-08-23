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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const Heading(
        title: "About us",
        showBackButton: true,
        // backgroundColor: Theme.of(context).colorScheme.,
        // textColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Engineering Journal\nBudget Management App',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Natural Intelligence Team',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Student name & ID:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tran Mai Nhung - s3879954',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Tran Nguyen Ha Khanh - s3877707',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Vo Thanh Thong - s3878071',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Giang Trong Duong - s3926135',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Ngo Viet Anh - s3928859',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Academic supervisor: ',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Ms. Anna Felipe',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Company:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'TymeX',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Industry supervisors:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mr. Vuong Tran',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Mr. Tung Nguyen',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Mr. Lanh Tran',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Mr. Long Nguyen',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text('Ms. Thuy Nguyen',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
