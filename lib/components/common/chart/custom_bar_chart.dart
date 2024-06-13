import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBE6),
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(BarChartData(
                borderData: FlBorderData(
                    border: const Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1),
                  bottom: BorderSide(width: 1),
                )),
                groupsSpace: 10,
                barGroups: [
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 10, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 10, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 15, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 10, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 11, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 6, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 10, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 7, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 10, width: 15, color: Colors.amber),
                  ]),
                  BarChartGroupData(x: 8, barRods: [
                    BarChartRodData(
                        fromY: 0, toY: 10, width: 15, color: Colors.amber),
                  ]),
                ]))),
      ),
    );
  }
}
