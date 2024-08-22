import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/challenge/checkpoint_details.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class CheckPointCard extends StatefulWidget {
  const CheckPointCard({super.key, required this.checkpoint, required this.challengeId});
  final CheckPointModel checkpoint;
  final String challengeId;

  @override
  State<CheckPointCard> createState() => _CheckPointCardState();
}

class _CheckPointCardState extends State<CheckPointCard> {

Future<void> _deleteCheckpoint(String challengeId, String checkpointId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.deleteCheckPoint(challengeId, checkpointId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _finishDelete();
        });
      });
    });
  }
  
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
              ElevatedButton(
                onPressed: () {_showDeletePrompt(context, widget.checkpoint.name);} ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showDeletePrompt(BuildContext context, String mileStoneName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Milestone Confirmation', style: Theme.of(context).textTheme.headlineSmall,),
          content: Text('Are you sure you want to delete Milestone: ${mileStoneName}? (Cannot be undo!)'
          ,style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.visible,),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: Theme.of(context).textTheme.labelLarge,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: Theme.of(context).textTheme.labelLarge,),
              onPressed: () async {
                context.loaderOverlay.show();
                await _deleteCheckpoint(widget.checkpoint.challengeId, widget.checkpoint.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _finishDelete(){
    context.loaderOverlay.hide();
    Navigator.of(context).pop();
  }
}