import 'package:flutter/material.dart';

class OutflowHeader extends StatefulWidget {
  const OutflowHeader({super.key});

  @override
  State<OutflowHeader> createState() => _OutflowHeaderState();
}

class _OutflowHeaderState extends State<OutflowHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Expense detail',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          Text(
            'Here is a breakdown of your account expense so far this month.',
            style: Theme.of(context).textTheme.bodyMedium!,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
