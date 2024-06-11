import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({
    super.key, 
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apr,
    required this.may,
    required this.jun,
    required this.jul,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,});

  final double jan;
  final double feb;
  final double mar;
  final double apr;
  final double may;
  final double jun;
  final double jul;
  final double aug;
  final double sep;
  final double oct;
  final double nov;
  final double dec;

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
              titlesData: const FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                ),
              ),
              minY: 0,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(1, widget.jan),
                    FlSpot(2, widget.feb),
                    FlSpot(3, widget.mar),
                    FlSpot(4, widget.apr),
                    FlSpot(5, widget.may),
                    FlSpot(6, widget.jun),
                    FlSpot(7, widget.jul),
                    FlSpot(8, widget.aug),
                    FlSpot(9, widget.sep),
                    FlSpot(10, widget.oct),
                    FlSpot(11, widget.nov),
                    FlSpot(12, widget.dec),
                  ],
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
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  Widget text;
  switch (value.toInt()) {
    case 2:
      text = const Text('FEB', style: AppTextStyles.subHeadingSmall);
      break;
    case 4:
      text = const Text('APR', style: AppTextStyles.subHeadingSmall);
      break;
    case 6:
      text = const Text('JUN', style: AppTextStyles.subHeadingSmall);
      break;
    case 8:
      text = const Text('AUG', style: AppTextStyles.subHeadingSmall);
      break;
    case 10:
      text = const Text('OCT', style: AppTextStyles.subHeadingSmall);
      break;
    case 12:
      text = const Text('DEC', style: AppTextStyles.subHeadingSmall);
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
