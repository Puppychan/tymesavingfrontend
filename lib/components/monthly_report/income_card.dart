import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class IncomeCard extends StatefulWidget {
  const IncomeCard({super.key,required this.currentMonthIncome, required this.currentMonth});

  final int currentMonthIncome;
  final String currentMonth;

  @override
  State<IncomeCard> createState() => _IncomeCardState();
}

class _IncomeCardState extends State<IncomeCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
      color: Colors.transparent.withOpacity(0),
      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            children: [
              Icon(Icons.trending_up, color: colorScheme.success, size: 30),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    overflow: TextOverflow.visible,
                    TextSpan(
                      text: '${widget.currentMonth} income is at ',
                      style: textTheme
                          .bodyMedium!, 
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ${formatAmountToVnd(widget.currentMonthIncome.toDouble())} ',
                          style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme
                                  .primary,
                              fontWeight: FontWeight.w500), 
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text.rich(
                  //   TextSpan(
                  //     text: 'Net spend of ',
                  //     style: textTheme
                  //         .titleSmall!, // Default style for the first part
                  //     children: <TextSpan>[
                  //       TextSpan(
                  //         text: '${formatAmountToVnd(widget.currentNetSpend.toDouble())} ',
                  //         style: textTheme.titleSmall!.copyWith(
                  //             color: colorScheme
                  //                 .primary), // Same style for the expense value
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              )
            ],
          )),
    );
  }
}
