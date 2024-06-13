import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

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
    required this.dec,
  });

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
                    // getTitlesWidget: bottomTitleWidgets,
                    getTitlesWidget: (value, meta) =>
                        bottomTitleWidgets(context, value, meta),
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

Widget bottomTitleWidgets(BuildContext context, double value, TitleMeta meta) {
  final style = Theme.of(context).textTheme.bodyMedium!;

  Widget text;
  switch (value.toInt()) {
    case 2:
      text = Text('FEB', style: style);
      break;
    case 4:
      text = Text('APR', style: style);
      break;
    case 6:
      text = Text('JUN', style: style);
      break;
    case 8:
      text = Text('AUG', style: style);
      break;
    case 10:
      text = Text('OCT', style: style);
      break;
    case 12:
      text = Text('DEC', style: style);
      break;
    default:
      text = Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
