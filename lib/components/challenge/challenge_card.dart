import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 180,
        child: Column(
          children: [
            // Image, title and description
            Row(
              children: [
                // Circle Image
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Title & Description
                Flexible(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Save your money",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                print("Tapped");
                              },
                              icon: Icon(Icons.more_horiz))
                        ],
                      ),
                      Text(
                        "Put your money into saving, for every 25k vnd you get 1 points!",
                        maxLines: 3,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Author name
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "By Zing L’s Amor",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12),
                )
              ],
            ),

            // Point and Day Left
            Row(
              children: [
                Text(
                  "20 out of 21 points",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12),
                ),
                const Spacer(),
                Text("2 days left",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.primary)),
              ],
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.4,
                  backgroundColor: Theme.of(context).colorScheme.quaternary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.inversePrimary),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
