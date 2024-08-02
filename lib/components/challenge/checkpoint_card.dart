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
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.checkpoint.name, style: Theme.of(context).textTheme.labelLarge, softWrap: true, overflow: TextOverflow.clip,),
              Row(
                children: [
                  Text('Reached checkpoint at ${formatAmountToVnd(widget.checkpoint.checkPointValue)}'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}