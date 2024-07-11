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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Outflow detail',
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        Text(
          'Here is a breakdown of your expense',
          style: Theme.of(context).textTheme.bodyMedium!,
        ),
        Text(
          'account activity so far this month.',
          style: Theme.of(context).textTheme.bodyMedium!,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
