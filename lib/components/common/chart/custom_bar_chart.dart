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

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Card.filled(
        color: Colors.transparent.withOpacity(0),
        shadowColor: Theme.of(context).colorScheme.onTertiary,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(keyValuePairs[0].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 1:
        text = Text(keyValuePairs[1].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 2:
        text = Text(keyValuePairs[2].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 3:
        text = Text(keyValuePairs[3].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 4:
        text = Text(keyValuePairs[4].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 5:
        text = Text(keyValuePairs[5].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 6:
        text = Text(keyValuePairs[6].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 7:
        text = Text(keyValuePairs[7].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 8:
        text = Text(keyValuePairs[8].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 9:
        text = Text(keyValuePairs[9].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 10:
        text = Text(keyValuePairs[10].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 11:
        text = Text(keyValuePairs[11].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
        break;
      case 12:
        text = Text(keyValuePairs[12].key.toLowerCase(), style: AppTextStyles.graphData.copyWith(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400));
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
