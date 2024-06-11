import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

class ReportFlow extends StatefulWidget {
  const ReportFlow(
      {super.key,
      required this.inflowCurrent,
      required this.inflowPrevious,
      required this.outflowCurrent,
      required this.outflowPrevious});

  final double inflowCurrent;
  final double inflowPrevious;
  final double outflowCurrent;
  final double outflowPrevious;

  @override
  State<ReportFlow> createState() => _ReportFlowState();
}

class _ReportFlowState extends State<ReportFlow> {
  late final String percentageChangeInflowFinal;
  late final String percentageChangeOutflowFinal;

  /*
  Logic để tính inflow và outflow percentages dựa trên history và current!
  */

  @override
  void initState() {
    final double percentageChangeInflow;
    final double percentageChangeOutflow;
    percentageChangeInflow = ((widget.inflowCurrent - widget.inflowPrevious) /
            widget.inflowPrevious) *
        100;

    percentageChangeOutflow =
        ((widget.outflowCurrent - widget.outflowPrevious) /
                widget.outflowPrevious) *
            100;

    percentageChangeInflowFinal =
        percentageChangeInflow.toStringAsFixed(2);
    percentageChangeOutflowFinal =
        percentageChangeOutflow.toStringAsFixed(2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: AppColors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.arrow_upward, color: AppColors.positive),
                const Text(
                  'Inflow',
                  style: AppTextStyles.headingSmall,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.inflowCurrent.toString(),
                      style: AppTextStyles.headingMedium,
                    ),
                    Text(
                      '$percentageChangeInflowFinal% from previous month',
                      style: AppTextStyles.subHeadingSmall,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: AppColors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.arrow_downward_rounded, color: AppColors.negative),
                const Text(
                  'Outflow',
                  style: AppTextStyles.headingSmall,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.outflowCurrent.toString(),
                      style: AppTextStyles.headingMedium,
                    ),
                    Text(
                      '$percentageChangeOutflowFinal% from previous month',
                      style: AppTextStyles.subHeadingSmall,
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
