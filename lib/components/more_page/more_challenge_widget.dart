import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

class MoreMenuChallenge extends StatelessWidget {
  const MoreMenuChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.surface,
      child: InkWell(
          splashColor: colorScheme.tertiary,
          onTap: () {
            debugPrint('Challenge tapped.');
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                children: [
                  Icon(Icons.emoji_events,
                      color: colorScheme.primary, size: 30),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge your saving skills now',
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                      Text('Let\'s go!',
                          style: AppTextStyles.titleLargeBlue(context)),
                    ],
                  )
                ],
              ))),
    );
  }
}
