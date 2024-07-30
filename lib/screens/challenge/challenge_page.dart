import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_card.dart';

import 'package:tymesavingfrontend/components/common/heading.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(
        title: "Challenges",
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              "Embrace the challenge, for within it lies the opportunity to discover your true potential and ignite the fire within",
              maxLines: 3,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ChallengeCard(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ChallengeCard(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ChallengeCard(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ChallengeCard(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
