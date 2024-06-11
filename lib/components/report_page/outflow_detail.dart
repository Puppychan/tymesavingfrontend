import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

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
        const Text('Outflow detail', style: AppTextStyles.headingMedium,),
        const Text('Check where your money has gone to here!', style: AppTextStyles.subHeadingSmall,),
      ],
    );
  }
}