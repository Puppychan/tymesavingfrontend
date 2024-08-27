import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
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
      final category = transactionCategoryData[
          TransactionCategory.fromString(widget.topCategories[i].category)];
      final Color color = category?['color'];
      pieChartData.add(PieChartSectionData(
        value: double.parse(widget.topCategories[i].percentages),
        color: color,
        title: '',
        showTitle: false, // Hide title on the chart
      ));
    }

    super.initState();
  }

@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: pieChartData,
              startDegreeOffset: 90,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Custom Legend
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List.generate(widget.topCategories.length, (index) {
            final category = transactionCategoryData[
                TransactionCategory.fromString(widget.topCategories[index].category)];
            final Color color = category?['color'];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.topCategories[index].percentages}%',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
