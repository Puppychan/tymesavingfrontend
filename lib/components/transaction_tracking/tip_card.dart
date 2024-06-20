import 'package:flutter/material.dart';

class TipCard extends StatefulWidget {
  const TipCard({super.key, required this.netSpend});

  final int netSpend;
  @override
  State<TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<TipCard> {
  bool tip = true;
  @override
  void initState() {
    if (widget.netSpend >= 0) {
      tip = true;
    } else {
      tip = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
        color: Colors.transparent.withOpacity(0),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        tip
                            ? 'Your net spend is positive! Great job managing your finances. Keep up the good work and continue saving for your future.'
                            : 'Your net spend is negative. Consider reviewing your expenses and identify areas where you can reduce unnecessary spending.',
                        style: textTheme.bodyMedium,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      )
                    ]),
              )
            ])));
  }
}
