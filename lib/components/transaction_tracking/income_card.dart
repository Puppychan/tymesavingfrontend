import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class IncomeCard extends StatefulWidget {
  const IncomeCard({super.key,required this.currentMonthIncome, required this.currentNetSpend});

  final int currentMonthIncome;
  final int currentNetSpend;

  @override
  State<IncomeCard> createState() => _IncomeCardState();
}

class _IncomeCardState extends State<IncomeCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
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
                    TextSpan(
                      text: 'Current income this month is ',
                      style: textTheme
                          .titleSmall!, // Default style for the first part
                      children: <TextSpan>[
                        TextSpan(
                          text: '${widget.currentMonthIncome} ',
                          style: textTheme.titleSmall!.copyWith(
                              color: colorScheme
                                  .primary), // Same style for the expense value
                        ),
                        TextSpan(
                          text: 'vnd',
                          style: textTheme.titleSmall!.copyWith(
                              color: colorScheme
                                  .primary), // Different color for "vnd"
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Net spend of ',
                      style: textTheme
                          .titleSmall!, // Default style for the first part
                      children: <TextSpan>[
                        TextSpan(
                          text: '${widget.currentNetSpend} ',
                          style: textTheme.titleSmall!.copyWith(
                              color: colorScheme
                                  .primary), // Same style for the expense value
                        ),
                        TextSpan(
                          text: 'vnd',
                          style: textTheme.titleSmall!.copyWith(
                              color: colorScheme
                                  .primary), // Different color for "vnd"
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
