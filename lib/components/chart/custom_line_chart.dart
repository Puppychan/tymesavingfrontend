import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: LineChart(
        curve: Curves.linear,
        LineChartData(
          gridData: FlGridData(
            show: false,
          ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(1, 2),
                  FlSpot(2, 4),
                  FlSpot(3, 5),
                  FlSpot(4, 3),
                  FlSpot(5, 4),
                  FlSpot(6, 6),
                  FlSpot(7, 5),
                  FlSpot(8, 4),
                  FlSpot(9, 3),
                  FlSpot(10, 6),
                  FlSpot(11, 8),
                  FlSpot(12, 7),
                ],
                color: AppColors.primary,
                barWidth: 5,
                isCurved: true,
                curveSmoothness: 0.55,
                dotData: const FlDotData(show: false),

              )
            ]
        ),
      ),
    );
  }
}