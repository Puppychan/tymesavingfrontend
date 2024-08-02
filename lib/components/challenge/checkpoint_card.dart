import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';

class CheckPointCard extends StatefulWidget {
  const CheckPointCard({super.key, required this.checkpoint});
  final CheckPointModel checkpoint;

  @override
  State<CheckPointCard> createState() => _CheckPointCardState();
}

class _CheckPointCardState extends State<CheckPointCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card.outlined(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.checkpoint.name, style: Theme.of(context).textTheme.labelLarge, softWrap: true, overflow: TextOverflow.clip,),
              Row(
                children: [
                  Text('Value of ${widget.checkpoint.checkPointValue} points'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}