import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/report_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class ReportPieChartUser extends StatefulWidget {
  const ReportPieChartUser({super.key, required this.reportUserList});

  final List<ReportUser> reportUserList;

  @override
  State<ReportPieChartUser> createState() => _ReportPieChartUserState();
}

class _ReportPieChartUserState extends State<ReportPieChartUser> {
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = widget.reportUserList.map((user) {
      return PieChartSectionData(
        color: Colors.primaries[widget.reportUserList.indexOf(user) % Colors.primaries.length],
        value: user.percentage, // Replace with the actual amount or value
        title: "${user.percentage}%", // Customize title as needed
        radius: 90, // Adjust radius as needed
        titleStyle: Theme.of(context).textTheme.labelLarge
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: sections
              )
            ),
          ),
          const SizedBox(height: 15),
          _buildDescriptionTable(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

   Widget _buildDescriptionTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text("")),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Amount')),
      ],
      rows: widget.reportUserList.map((user) {
        final color = Colors.primaries[widget.reportUserList.indexOf(user) % Colors.primaries.length];
        return DataRow(
          cells: [
            DataCell(Container(
              width: 10,
              height: 10,
              color: color,
            )),
            DataCell(Text(user.user)), // Display the category or user name
            DataCell(Text(formatAmountToVnd(user.totalAmount.toDouble()))), // Display the amount or percentage
          ],
        );
      }).toList(),
    );
  }
}