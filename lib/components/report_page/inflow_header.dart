import 'package:flutter/material.dart';

class InflowHeader extends StatefulWidget {
  const InflowHeader({super.key});

  @override
  State<InflowHeader> createState() => _InflowHeaderState();
}

class _InflowHeaderState extends State<InflowHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Income detail',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          Text(
            'Here is a breakdown of your account income so far this month.',
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