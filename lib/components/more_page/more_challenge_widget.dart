import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_page.dart';

class MoreMenuChallenge extends StatefulWidget {
  const MoreMenuChallenge({super.key});

  @override
  State<MoreMenuChallenge> createState() => _MoreMenuChallengeState();
}

class _MoreMenuChallengeState extends State<MoreMenuChallenge> {
  Future<void> challengePageRoute() async {
    //Debug here
    if (!mounted) return;
    debugPrint('Tracking page tapped!');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ChallengePage()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.background,
      child: InkWell(
          splashColor: colorScheme.tertiary,
          onTap: () {
            debugPrint('Challenge tapped.');
            challengePageRoute();
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
