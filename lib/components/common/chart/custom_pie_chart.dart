import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({super.key, required this.topCategories});

  final List<TopCategory> topCategories;

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  late List<PieChartSectionData> pieChartData;
  final Map<String, Color> categoryColors = {
    'Dine out': Colors.red,
    'Shopping': Colors.blue,
    'Travel': Colors.orange,
    'Entertainment': Colors.purple,
    'Personal': Colors.teal,
    'Transportation': Colors.green,
    'Rent/Mortgage': Colors.brown,
    'Utilities': Colors.yellow,
    'Bills & Fees': Colors.grey,
    'Health': Colors.pink,
    'Education': Colors.indigo,
    'Groceries': Colors.lime,
    'Gifts': Colors.redAccent,
    'Work': Colors.blueAccent,
    'Other expenses': Colors.black,
  };

  @override
  void initState() {
    pieChartData = [];
    for (int i = 0; i < widget.topCategories.length; i++) {
      pieChartData.add(PieChartSectionData(
        value: double.parse(widget.topCategories[i].percentages),
        color: categoryColors[widget.topCategories[i].category],
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: SizedBox(
        height: 200,
        child: PieChart(PieChartData(sections: pieChartData)),
      ),
    );
  }
}
