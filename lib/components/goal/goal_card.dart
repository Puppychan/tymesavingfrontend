import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/models/goal_model.dart';
import 'package:tymesavingfrontend/screens/goal/goal_update_page.dart';
import 'package:tymesavingfrontend/services/goal_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:timeago/timeago.dart' as timeago;

// final tempGoal = Goal(
//   id: "1",
//   hostedBy: "72e4b93000be75dd6e367723",
//   name: 'Goal Name',
//   description: 'Description',
//   amount: 50000000,
//   concurrentAmount: 10000000,
//   createdDate: DateTime.now().toString(),
//   endDate: DateTime.now().add(const Duration(days: 30)).toString(),
//   participants: [],
// );

class GoalCard extends StatefulWidget {
  // final String goalId;
  final Goal goal;
  const GoalCard({super.key, required this.goal});
  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    // final goal = Provider.of<AuthService>(context).goal;
    // final goal = tempGoal;
    final currentProgress = widget.goal.concurrentAmount / widget.goal.amount;

    void onEdit() {
      // Implement the edit functionality
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoalUpdatePage(goalId: widget.goal.id)),
      );
    }

    Future showDeleteConfirmationDialog() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Confirmation'),
            content: const Text('Are you sure you want to delete this goal?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Future.microtask(() async {
                    final goalService =
                        Provider.of<GoalService>(context, listen: false);
                    await handleMainPageApi(context, () async {
                      return await goalService.deleteGoal(widget.goal.id);
                      // return result;
                    }, () async {
                      Navigator.of(context).pop();
                      SuccessDisplay.showSuccessToast(
                          "Successfully delete the goal", context);
                    });
                  });
                  // onDelete();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    // double progress = goal.contribution / maxContribution; // Calculate the progress as a fraction
    String formattedDate =
        timeago.format(DateTime.parse(widget.goal.createdDate.toString()));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.shadow,
      elevation: 5,
      child: InkWell(
        splashColor: colorScheme.quaternary,
        onTap: () {
          // debugPrint('Challenge tapped.');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            // TODO: Implement the goal details page
            return GoalUpdatePage(goalId: widget.goal.id);
          }));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // CustomCircleAvatar(imagePath: goal.avatarPath),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.goal.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Created $formattedDate",
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 6,
                      child: Text.rich(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Progress ',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(width: 3),
                  Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: formatAmount(widget.goal.concurrentAmount),
                      // text: "Goal Contribution",
                      style: textTheme.bodyLarge,
                    ),
                     TextSpan(
                      text: ' / ',
                      style: textTheme.labelLarge!.copyWith(
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                    TextSpan(
                      text: formatAmount(widget.goal.amount),
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ]))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: currentProgress.clamp(
                      0.0, 1.0), // Ensuring the value is between 0 and 1
                  // value: 0.4, // Ensuring the value is between 0 and 1
                  backgroundColor: colorScheme.quaternary,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget displayParticipants() {
  //   return 
  // }
}
