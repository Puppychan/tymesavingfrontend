import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/components/heading.dart';
import 'package:tymesavingfrontend/components/report_page/outflow_detail.dart';
import 'package:tymesavingfrontend/components/report_page/report_flow.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Heading(
        title: 'Reports',
        showBackButton: true,
      ),
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ReportFlow(
            inflowCurrent: 250000, 
            inflowPrevious: 278000, 
            outflowCurrent: 180000, 
            outflowPrevious: 190000
          ),
          SizedBox(height: 20,),
          OutflowDetail(),
        ],
      ),
    );
  }
}