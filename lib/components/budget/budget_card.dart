import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/budget/budget_details.dart';
import 'package:tymesavingfrontend/components/budget/budget_report.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
// import 'package:timeago/timeago.dart' as timeago;

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
    // String formattedDate =
    //     timeago.format(DateTime.parse(widget.budget.createdDate.toString()));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.shadow,
      elevation: 1,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Progress or Group closed text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.01),
              child: Text.rich(
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: <TextSpan>[
                    widget.budget.isClosedOrExpired ?
                    TextSpan(
                      text: 'Group closed',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: const Color(0xFFF44336)
                        ),
                    )
                    :
                    TextSpan(
                      text: 'Progress ',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // The line indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.005),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: currentProgress.clamp(
                      0.0, 1.0),
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

            // Amount indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.005),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 3),
                  Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: formatAmountToVnd(widget.budget.concurrentAmount),
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
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
            // Budget name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.005),
              child: Text(
                        widget.budget.name,
                        style: textTheme.headlineMedium,
                        maxLines: 2,
                      ),
            ),
            // User create name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.005),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "By ", 
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: widget.budget.hostByFullName, 
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400, 
                              color: colorScheme.primary
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            
            // // Description
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.005),
            //   child: Text(
            //             widget.budget.description,
            //             style: textTheme.bodyMedium,
            //             maxLines: 3,
            //             overflow: TextOverflow.fade,
            //           ),
            // ),

            // // Format date
            //  Padding(
            //   padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
            //   child: Text(
            //             "Created $formattedDate",
            //             style: textTheme.bodyMedium!.copyWith(
            //               fontStyle: FontStyle.italic,
            //               fontWeight: FontWeight.w400,
            //             ),
            //             maxLines: 2,
            //           ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget displayParticipants() {
  //   return
  // }
}
