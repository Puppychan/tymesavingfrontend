import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class NetSpendCard extends StatefulWidget {
  const NetSpendCard({super.key,required this.netSpend});

  final int netSpend;

  @override
  State<NetSpendCard> createState() => _NetSpendCardState();
}

class _NetSpendCardState extends State<NetSpendCard> {
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
              Icon(Icons.calculate, color: colorScheme.inversePrimary, size: 30),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Net spend of ',
                      style: textTheme
                          .bodyMedium!, // Default style for the first part
                      children: <TextSpan>[
                        TextSpan(
                          text: '${formatAmountToVnd(widget.netSpend.toDouble())} ',
                          style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme
                                  .primary,
                                  fontWeight: FontWeight.w500), 
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