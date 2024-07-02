import 'package:flutter/material.dart';

class EmptyCaseOutFlow extends StatefulWidget {
  const EmptyCaseOutFlow({super.key});

  @override
  State<EmptyCaseOutFlow> createState() => _EmptyCaseOutFlowState();
}

class _EmptyCaseOutFlowState extends State<EmptyCaseOutFlow> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            children: [
              Icon(Icons.lightbulb_circle_rounded, color: colorScheme.error, size: 30),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your transaction data is currently insufficient for analysis. Please make transaction and use the app further more!',
                        style: textTheme.bodyMedium,
                        overflow: TextOverflow.visible
                      )
                    ]),
              )
            ],
          )),
    );
  }
}
