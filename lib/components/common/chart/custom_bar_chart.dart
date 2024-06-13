import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({super.key});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {


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
                barGroups: []
              )
            )
          ),
      ),
    );
  }
}