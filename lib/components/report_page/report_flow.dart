import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class ReportFlow extends StatefulWidget {
  const ReportFlow(
      {super.key,
      required this.inflowCurrent,
      required this.inflowPercentage,
      required this.outflowCurrent,
      required this.outflowPercentage});

  final int inflowCurrent;
  final String inflowPercentage;
  final int outflowCurrent;
  final String outflowPercentage;

  @override
  State<ReportFlow> createState() => _ReportFlowState();
}

class _ReportFlowState extends State<ReportFlow> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Colors.transparent.withOpacity(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.arrow_upward, color: colorScheme.success),
                Text(
                  'Inflow',
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.inflowCurrent.toString(),
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    Text(
                      '${widget.inflowPercentage}% from previous month',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Colors.transparent.withOpacity(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.arrow_downward_rounded, color: colorScheme.error),
                Text(
                  'Outflow',
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.outflowCurrent.toString(),
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    Text(
                      '${widget.outflowPercentage}% from previous month',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
