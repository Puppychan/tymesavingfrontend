import 'package:flutter/material.dart';

class OutflowHeader extends StatefulWidget {
  const OutflowHeader({super.key});

  @override
  State<OutflowHeader> createState() => _OutflowHeaderState();
}

class _OutflowHeaderState extends State<OutflowHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Outflow detail',
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        Text(
          'Check where your money has gone to here!',
          style: Theme.of(context).textTheme.bodyMedium!,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
