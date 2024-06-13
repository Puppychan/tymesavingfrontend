import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart(
      {super.key, required this.totalsExpense, required this.totalsIncome});

  final Map<String, int> totalsExpense;
  final Map<String, int> totalsIncome;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late List<BarChartGroupData> barChartGroupData;
  late List<MapEntry<String, int>> expenseEntries;
  late List<MapEntry<String, int>> incomeEntries;

  @override
  void initState() {
    super.initState();
    expenseEntries = widget.totalsExpense.entries.toList();
    incomeEntries = widget.totalsIncome.entries.toList();
    barChartGroupData = _createBarGroups();
  }

  List<BarChartGroupData> _createBarGroups() {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < expenseEntries.length; i++) {
      final expenseEntry = expenseEntries[i];
      final incomeEntry = incomeEntries[i];

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: expenseEntry.value.toDouble(),
              color: AppColors.negative,
              width: 8,
              borderRadius: BorderRadius.circular(0),
            ),
            BarChartRodData(
              toY: incomeEntry.value.toDouble(),
              color: AppColors.positive,
              width: 8,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
                swapAnimationCurve: Curves.linear,
                swapAnimationDuration: const Duration(milliseconds: 150),
                BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(
                        border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide.none,
                      bottom: BorderSide(width: 1),
                    )),
                    groupsSpace: 10,
                    barGroups: barChartGroupData))),
      ),
    );
  }
}
