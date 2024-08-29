import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/budget/budget_details.dart';
import 'package:tymesavingfrontend/components/budget/budget_report.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math' as math;

class BudgetCard extends StatefulWidget {
  final Budget budget;
  const BudgetCard({super.key, required this.budget});
  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    final currentProgress =
        widget.budget.concurrentAmount / widget.budget.amount;
    String formattedDate =
        timeago.format(DateTime.parse(widget.budget.createdDate.toString()));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.shadow,
      elevation: 5,
      child: InkWell(
        splashColor: colorScheme.quaternary,
        onTap: () {
          widget.budget.isClosedOrExpired ?
           Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BudgetReport(budgetId: widget.budget.id);
          }))
          :
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BudgetDetails(budgetId: widget.budget.id);
          }));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CustomCircleImage(imagePath: budget.avatarPath),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.budget.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Expanded(
                    child: CustomAlignText(
                      text: "Created $formattedDate",
                      alignment: Alignment.centerRight,
                      style: Theme.of(context).textTheme.bodySmall!,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.budget.hostByFullName),
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
                            widget.budget.isClosedOrExpired ?
                            TextSpan(
                              text: 'Group closed',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
                            )
                            :
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
                      text: formatAmountToVnd(widget.budget.concurrentAmount),
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
                      text: formatAmountToVnd(widget.budget.amount),
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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    currentProgress == 1 ? 
                  const Color(0xFF4CAF50) :
                  currentProgress < 0.30 ?
                  const Color(0xFFF44336) : 
                  colorScheme.primary
                  ),
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
