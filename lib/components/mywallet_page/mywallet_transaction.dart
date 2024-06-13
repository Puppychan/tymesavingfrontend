import 'package:flutter/material.dart';

class MyWalletTransaction extends StatefulWidget {
  const MyWalletTransaction({super.key, required this.month, required this.expense});
  
  final String month;
  final int expense;
  
  @override
  State<MyWalletTransaction> createState() => _MyWalletTransactionState();
}

class _MyWalletTransactionState extends State<MyWalletTransaction> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.background,
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
                          text: '${widget.expense} ',
                          style: textTheme.titleSmall!.copyWith(color: colorScheme.primary), // Same style for the expense value
                        ),
                        TextSpan(
                          text: 'vnd',
                          style: textTheme.titleSmall!.copyWith(color: colorScheme.primary), // Different color for "vnd"
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
