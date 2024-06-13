import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({
    super.key,
    required this.totals,
  });

  final Map<String, int> totals;

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  late List<MapEntry<String, int>> keyValuePairs;
  late List<FlSpot> flSpots = [];

  @override
  void initState() {
    // List to hold key-value pairs as tuples
    keyValuePairs = [];

    // Extract and insert key-value pairs into the list
    widget.totals.forEach((key, value) {
      keyValuePairs.add(MapEntry(key, value));
    });

    for (int i = 0; i < keyValuePairs.length; i++) {
      var entry = keyValuePairs[i];
      debugPrint('Month: ${entry.key}, Value: ${entry.value}');
      flSpots.add(FlSpot(i.toDouble(), entry.value.toDouble()));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 300,
        child: LineChart(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
          LineChartData(
              gridData: const FlGridData(
                show: false,
              ),
              borderData: FlBorderData(
                show: false,
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
                    reservedSize: 90,
                    interval: 1,
                    getTitlesWidget: (value, meta) =>
                        bottomTitleWidgets(value, meta),
                  ),
                ),
              ),
              minY: 0,
              lineBarsData: [
                LineChartBarData(
                  spots: flSpots,
                  color: AppColors.primary,
                  barWidth: 5,
                  isCurved: true,
                  curveSmoothness: 0.55,
                  preventCurveOverShooting: true,
                  dotData: const FlDotData(show: false),
                )
              ]),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(keyValuePairs[0].key, style: AppTextStyles.subHeadingSmall);
        break;
      case 2:
        text = Text(keyValuePairs[2].key, style: AppTextStyles.subHeadingSmall);
        break;
      case 4:
        text = Text(keyValuePairs[4].key, style: AppTextStyles.subHeadingSmall);
        break;
      case 6:
        text = Text(keyValuePairs[6].key, style: AppTextStyles.subHeadingSmall);
        break;
      case 8:
        text = Text(keyValuePairs[8].key, style: AppTextStyles.subHeadingSmall);
        break;
      case 10:
        text = Text(keyValuePairs[10].key, style: AppTextStyles.subHeadingSmall);
        break;
      case 12:
        text =
            Text(keyValuePairs[12].key, style: AppTextStyles.subHeadingSmall);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Container(padding: const EdgeInsets.only(top: 30), child: text),
    );
  }
}
