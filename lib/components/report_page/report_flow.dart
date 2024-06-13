import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

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
                      '${widget.inflowPercentage}% from previous month',
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
                      '${widget.outflowPercentage}% from previous month',
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
