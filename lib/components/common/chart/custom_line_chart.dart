import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/models/transaction_report.model.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({
    super.key, this.chartReport,
  });

  final ChartReport? chartReport;

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 250,
        child: LineChart(
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
                  spots: [],
                  color: AppColors.primary,
                  barWidth: 5,
                  isCurved: true,
                  curveSmoothness: 0.55,
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
      case 2:
        text = Text('placeholder', style: AppTextStyles.subHeadingSmall);
        break;
      case 4:
        text = Text('placeholder', style: AppTextStyles.subHeadingSmall);
        break;
      case 6:
        text = Text('placeholder', style: AppTextStyles.subHeadingSmall);
        break;
      case 8:
        text = Text('placeholder', style: AppTextStyles.subHeadingSmall);
        break;
      case 10:
        text = Text('placeholder', style: AppTextStyles.subHeadingSmall);
        break;
      case 12:
        text = Text('placeholder', style: AppTextStyles.subHeadingSmall);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
