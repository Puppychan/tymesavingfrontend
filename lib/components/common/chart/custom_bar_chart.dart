import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart(
      {super.key, required this.totalsExpense, required this.totalsIncome});

  final Map<String, int> totalsExpense;
  final Map<String, int> totalsIncome;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late List<MapEntry<String, int>> expenseEntries;
  late List<MapEntry<String, int>> incomeEntries;
  late List<MapEntry<String, int>> keyValuePairs;

  @override
  void initState() {
    super.initState();
    expenseEntries = widget.totalsExpense.entries.toList();
    incomeEntries = widget.totalsIncome.entries.toList();
    keyValuePairs = [];

    // Extract and insert key-value pairs into the list
    widget.totalsExpense.forEach((key, value) {
      keyValuePairs.add(MapEntry(key, value));
    });
  }

  @override
  Widget build(BuildContext context) {
    // late List<BarChartGroupData> barChartGroupData;
    List<BarChartGroupData> createBarGroups() {
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
                color: Theme.of(context).colorScheme.inversePrimary,
                width: 10,
                borderRadius: BorderRadius.circular(0),
              ),
              BarChartRodData(
                toY: incomeEntry.value.toDouble(),
                color: Theme.of(context).colorScheme.primary,
                width: 10,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
            barsSpace: 1,
          ),
        );
      }
      return groups;
    }

    return AspectRatio(
        aspectRatio: 1.9,
        child: Card.filled(
          color: Colors.transparent.withOpacity(0),
          shadowColor: Theme.of(context).colorScheme.onTertiary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: BarChart(
                swapAnimationCurve: Curves.linear,
                swapAnimationDuration: const Duration(milliseconds: 150),
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                    titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                         bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: 1,
                            getTitlesWidget: (value, meta) =>
                              bottomTitleWidgets(value, meta),
                          ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(
                        border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide.none,
                      bottom: BorderSide.none,
                    )),
                    groupsSpace: 10,
                    barGroups: createBarGroups())),
          ),
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(keyValuePairs[0].key, style: AppTextStyles.graphData);
        break;
      case 1:
        text = Text(keyValuePairs[1].key, style: AppTextStyles.graphData);
        break;
      case 2:
        text = Text(keyValuePairs[2].key, style: AppTextStyles.graphData);
        break;
      case 3:
        text = Text(keyValuePairs[3].key, style: AppTextStyles.graphData);
        break;
      case 4:
        text = Text(keyValuePairs[4].key, style: AppTextStyles.graphData);
        break;
      case 5:
        text = Text(keyValuePairs[5].key, style: AppTextStyles.graphData);
        break;
      case 6:
        text = Text(keyValuePairs[6].key, style: AppTextStyles.graphData);
        break;
      case 7:
        text = Text(keyValuePairs[7].key, style: AppTextStyles.graphData);
        break;
      case 8:
        text = Text(keyValuePairs[8].key, style: AppTextStyles.graphData);
        break;
      case 9:
        text = Text(keyValuePairs[9].key, style: AppTextStyles.graphData);
        break;
      case 10:
        text = Text(keyValuePairs[10].key, style: AppTextStyles.graphData);
        break;
      case 11:
        text = Text(keyValuePairs[11].key, style: AppTextStyles.graphData);
        break;
      case 12:
        text = Text(keyValuePairs[12].key, style: AppTextStyles.graphData);
        break;
      default:
        text = const Text('', style: AppTextStyles.graphData);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Container(padding: const EdgeInsets.only(top: 5), child: text),
    );
  }
}
