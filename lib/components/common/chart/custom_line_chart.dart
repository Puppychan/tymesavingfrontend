import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({
    super.key,
    required this.totalsIncome,
    required this.totalsExpense,
  });

  final Map<String, int> totalsIncome;
  final Map<String, int> totalsExpense;

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  late List<MapEntry<String, int>> keyValuePairsIncome;
  late List<MapEntry<String, int>> keyValuePairsExpense;
  late List<FlSpot> incomeSpots = [];
  late List<FlSpot> expenseSpots = [];

  @override
  void initState() {
    super.initState();
    keyValuePairsIncome = widget.totalsIncome.entries.toList();
    keyValuePairsExpense = widget.totalsExpense.entries.toList();

    for (int i = 6; i < keyValuePairsIncome.length; i++) {
      incomeSpots.add(FlSpot(i.toDouble(), keyValuePairsIncome[i].value.toDouble()));
      expenseSpots.add(FlSpot(i.toDouble(), keyValuePairsExpense[i].value.toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1,
                );
              },
              drawHorizontalLine: false,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                showTitles: false,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) =>
                      bottomTitleWidgets(value, meta),
                ),
              ),
            ),
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: incomeSpots,
                color: colorScheme.success,
                barWidth: 2.5,
                isCurved: true,
                curveSmoothness: 0.3,
                preventCurveOverShooting: true,
                dotData: const FlDotData(show: true),
              ),
              LineChartBarData(
                spots: expenseSpots,
                color: colorScheme.error,
                barWidth: 2.5,
                isCurved: true,
                curveSmoothness: 0.3,
                preventCurveOverShooting: true,
                dotData: const FlDotData(show: true),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    // Use the color of the graph line for the tooltip text
                    final textColor = touchedSpot.bar.color!;

                    return LineTooltipItem(
                      formatAmountToVnd(touchedSpot.y),
                      TextStyle(
                        color: textColor, // Set the tooltip text color to the graph line color
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.labelMedium!;
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(keyValuePairsIncome[0].key, style: style);
        break;
      // case 1:
      //   text = Text(keyValuePairsIncome[1].key, style: style);
      //   break;
      case 2:
        text = Text(keyValuePairsIncome[2].key.toLowerCase(), style: style);
        break;
      // case 3:
      //   text = Text(keyValuePairsIncome[3].key, style: style);
      //   break;
      case 4:
        text = Text(keyValuePairsIncome[4].key, style: style);
        break;
      // case 5:
      //   text = Text(keyValuePairsIncome[5].key, style: style);
      //   break;
      case 6:
        text = Text(keyValuePairsIncome[6].key.toLowerCase(), style: style);
        break;
      case 7:
        text = Text(keyValuePairsIncome[7].key.toLowerCase(), style: style);
        break;
      case 8:
        text = Text(keyValuePairsIncome[8].key.toLowerCase(), style: style);
        break;
      case 9:
        text = Text(keyValuePairsIncome[9].key.toLowerCase(), style: style);
        break;
      case 10:
        text = Text(keyValuePairsIncome[10].key.toLowerCase(), style: style);
        break;
      case 11:
        text = Text(keyValuePairsIncome[11].key.toLowerCase(), style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Container(padding: const EdgeInsets.only(top: 8), child: text),
    );
  }
}

