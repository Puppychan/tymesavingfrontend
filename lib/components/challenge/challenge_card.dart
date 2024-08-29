import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Card.outlined(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            widget.challengeModel!.isPublished ?
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeDetails(challengeId:  widget.challengeModel!.id, isForListing: true,)))
          : Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeDetails(challengeId:  widget.challengeModel!.id, isForListing: false,)));
          },
          child: Column(
            children: [
              // Image, title and description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month, 
                        size: 15,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8.0), 
                      Text(
                        DateFormat('EEEE, dd/MM/yyyy').format(widget.challengeModel!.endDate),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: colorScheme.primary, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        softWrap: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Text(
                    widget.challengeModel!.description,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.perm_identity_sharp, weight: 0.5, size: 20,color: colorScheme.primary,),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "By ", // First part of the text
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: widget.challengeModel!.createdBy, // Second part of the text
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: colorScheme.primary ), // Applying different style
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
