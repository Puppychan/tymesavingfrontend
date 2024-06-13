import 'package:flutter/material.dart';

class OutflowDetail extends StatefulWidget {
  const OutflowDetail({super.key});

  @override
  State<OutflowDetail> createState() => _OutflowDetailState();
}

class _OutflowDetailState extends State<OutflowDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Outflow detail', style: Theme.of(context).textTheme.titleLarge!,),
        Text('Check where your money has gone to here!', style: Theme.of(context).textTheme.bodyMedium!,),
      ],
    );
  }
}