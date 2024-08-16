import 'package:flutter/cupertino.dart';
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
    return Card.outlined(
      child: Container(
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
                        Icons.calendar_today, // You can choose any icon that suits your design
                        size: 15, // Adjust the size according to your need
                        color: Theme.of(context).colorScheme.primary, // Adjust color if needed
                      ),
                      const SizedBox(width: 8.0), // Add some space between the icon and the text
                      Text(
                        DateFormat('EEEE, dd/MM/yyyy').format(widget.challengeModel!.endDate),
                        style: Theme.of(context).textTheme.bodyMedium,
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
                  Text(
                    "By ${widget.challengeModel!.createdBy}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!.copyWith(fontStyle: FontStyle.italic)
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
