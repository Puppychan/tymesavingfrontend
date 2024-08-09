import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BudgetPieChart extends StatefulWidget {
  const BudgetPieChart({
    super.key, 
    required this.amount, 
    required this.concurrent
  });

  final double amount;
  final double concurrent;

  @override
  State<BudgetPieChart> createState() => _BudgetPieChartState();
}

class _BudgetPieChartState extends State<BudgetPieChart> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            PieChart(
              PieChartData(
                startDegreeOffset: -90,
                sections: [
                  PieChartSectionData(
                    value: double.parse(widget.amount.toStringAsFixed(2)),
                    color: widget.amount == 100 ? const Color(0xFF4CAF50) : colorScheme.primary, // Example color
                    title: '',
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: double.parse(widget.concurrent.toStringAsFixed(2)),
                    color: Colors.grey, // Example color
                    title: '',
                    showTitle: false,
                  ),
                ],
              ),
            ),
            Center(
              child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: widget.amount.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          TextSpan(
                            text: '%',
                            style: Theme.of(context).textTheme.headlineMedium, // Customize this style as needed
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


