import 'package:flutter/material.dart';

class TipCard extends StatefulWidget {
  const TipCard({super.key, 
  required this.netSpend, 
  required this.income, 
  required this.expense
  });

  final int netSpend;
  final int income;
  final int expense;
  @override
  State<TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<TipCard> {
  bool tip = true;
  bool noData = false;

  @override
  void initState() {
    if (widget.netSpend >= 0) {
      tip = true;
    } else {
      tip = false;
    }

    if (widget.income == 0 && widget.expense == 0){
      noData = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
        color: Colors.transparent.withOpacity(0),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(children: [
              Icon(Icons.tips_and_updates,
                  color: colorScheme.primary, size: 30),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noData ? 
                          'Currently there is no data to give out tips, please make more transaction and be mindful about what you spend!':
                        tip
                            ? 'Your net spend is positive! Great job managing your finances. Keep up the good work and continue saving for your future, remember to always save an emergency funds!'
                            : 'Your net spend is negative. Consider reviewing your expenses and identify areas where you can reduce unnecessary spending such as non-essential spending (subscription, eat out, shopping, etc)',
                        style: textTheme.bodyMedium,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      )
                ]),
              )
            ])
          ));
  }
}
