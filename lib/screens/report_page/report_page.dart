import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_padding.dart';
import 'package:tymesavingfrontend/components/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/chart/custom_line_chart.dart';
import 'package:tymesavingfrontend/components/report_page/report_transaction.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50,),
          CustomLineChart(),
          SizedBox(height: 20,),
          CustomBarChart(),
          SizedBox(height: 20,),
          ReportTransaction(),
          ]
      ),
    );
  }
}
