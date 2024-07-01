import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/screens/budget/budget_update_page.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:timeago/timeago.dart' as timeago;

final tempBudget = Budget(
  id: "1",
  hostedBy: "72e4b93000be75dd6e367723",
  name: 'Budget Name',
  description: 'Description',
  amount: 50000000,
  concurrentAmount: 10000000,
  createdDate: DateTime.now().toString(),
  endDate: DateTime.now().add(const Duration(days: 30)).toString(),
  participants: [],
);

class BudgetCard extends StatefulWidget {
  final String budgetId;
  const BudgetCard({super.key, required this.budgetId});
  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    // final budget = Provider.of<AuthService>(context).budget;
    final budget = tempBudget;
    final currentProgress = budget.concurrentAmount / budget.amount;

    void onEdit() {
      // Implement the edit functionality
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BudgetUpdatePage(budgetId: budget.id)),
      );
    }

    Future showDeleteConfirmationDialog() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Confirmation'),
            content: const Text('Are you sure you want to delete this budget?'),
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
                    final budgetService =
                        Provider.of<BudgetService>(context, listen: false);
                    await handleMainPageApi(context, () async {
                      return await budgetService.deleteBudget(budget.id);
                      // return result;
                    }, () async {
                      Navigator.of(context).pop();
                      SuccessDisplay.showSuccessToast(
                          "Successfully delete the budget", context);
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

    // double progress = budget.contribution / maxContribution; // Calculate the progress as a fraction
    String formattedDate =
        timeago.format(DateTime.parse(budget.createdDate.toString()));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.secondary.withOpacity(0.5),
      elevation: 5,
      child: InkWell(
        splashColor: colorScheme.quaternary,
        onTap: () {
          // debugPrint('Challenge tapped.');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            // TODO: Implement the budget details page
            return BudgetUpdatePage(budgetId: budget.id);
          }));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // CustomCircleAvatar(imagePath: budget.avatarPath),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      budget.name,
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
                      text: formatAmount(budget.concurrentAmount),
                      // text: "Budget Contribution",
                      style: textTheme.bodyLarge,
                    ),
                     TextSpan(
                      text: ' / ',
                      style: textTheme.labelLarge!.copyWith(
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                    TextSpan(
                      text: formatAmount(budget.amount),
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
