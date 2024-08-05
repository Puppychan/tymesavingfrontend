import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_details.dart';

class ChallengeCard extends StatefulWidget {
  const ChallengeCard({
    super.key,
    required this.challengeModel
  });
  
  final ChallengeModel? challengeModel;

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeDetails(challengeId:  widget.challengeModel!.id)));
        },
        child: Column(
          children: [
            // Image, title and description
            Row(
              children: [
                // Title & Description
                Flexible(
                  child: Column(
                    children: [
                      Text(
                            widget.challengeModel!.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
                          ),
                      const SizedBox(height: 10),
                      Text(
                        widget.challengeModel!.description,
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
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "By ${widget.challengeModel!.createdBy}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12),
                )
              ],
            ),

            // Progress bar
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(4),
            //     child: LinearProgressIndicator(
            //       value: 0.4,
            //       backgroundColor: Theme.of(context).colorScheme.quaternary,
            //       valueColor: AlwaysStoppedAnimation<Color>(
            //           Theme.of(context).colorScheme.inversePrimary),
            //       minHeight: 8,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
