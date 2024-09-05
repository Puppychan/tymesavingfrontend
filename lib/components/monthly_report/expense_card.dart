import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({super.key, required this.month, required this.expense});
  
  final String month;
  final int expense;
  
  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
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
              Icon(Icons.money_off,
                  color: colorScheme.error, size: 30),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${widget.month} expense is at ',
                      style: textTheme.titleSmall!, // Default style for the first part
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ${formatAmountToVnd(widget.expense.toDouble())} ',
                          style: textTheme.titleSmall!.copyWith(color: colorScheme.primary), // Same style for the expense value
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
