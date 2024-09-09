import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiary,
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          splashColor: colorScheme.quaternary,
          onTap: () {
            widget.challengeModel!.isPublished ?
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeDetails(challengeId:  widget.challengeModel!.id, isForListing: true,)))
          : Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeDetails(challengeId:  widget.challengeModel!.id, isForListing: false,)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image, title and description
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
              const SizedBox(height: 15),
      
              // Text(
              //   widget.challengeModel!.description,
              //   maxLines: 3,
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodyMedium
              // ),
              // const SizedBox(height: 10,),
              // Icon(Icons.perm_identity_sharp, weight: 0.5, size: 20,color: colorScheme.primary,),
              Text.rich(
                textAlign: TextAlign.start,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "By ", 
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: widget.challengeModel!.createdByFullName, 
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: colorScheme.primary ), // Applying different style
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Text(
                DateFormat('EEEE, dd/MM/yyyy').format(widget.challengeModel!.endDate),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colorScheme.primary, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                textAlign: TextAlign.left,
                maxLines: 3,
                softWrap: true,
              ),
              
              const SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }
}
