import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/challenge/checkpoint_details.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class CheckPointCard extends StatefulWidget {
  const CheckPointCard({super.key, required this.checkpoint, required this.challengeId});
  final CheckPointModel checkpoint;
  final String challengeId;

  @override
  State<CheckPointCard> createState() => _CheckPointCardState();
}

class _CheckPointCardState extends State<CheckPointCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.tertiary,
      radius: 100,
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CheckPointDetails(checkpointId: widget.checkpoint.id, challengeId: widget.challengeId);
        }));
      },
      child: Card.outlined(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        formatAmountToVnd(widget.checkpoint.checkPointValue), 
                        style: Theme.of(context).textTheme.labelLarge,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        textAlign: TextAlign.center,
                      )
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.checkpoint.name, 
                        style: Theme.of(context).textTheme.bodyMedium, 
                        overflow: TextOverflow.visible,
                        softWrap: true, 
                        maxLines: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}