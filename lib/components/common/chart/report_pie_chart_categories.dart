import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/report_model.dart';

class ReportPieChartCategories extends StatefulWidget {
  const ReportPieChartCategories({super.key, required this.reportCategory});

  final List<ReportCategory> reportCategory;

  @override
  State<ReportPieChartCategories> createState() => _ReportPieChartCategoriesState();
}

class _ReportPieChartCategoriesState extends State<ReportPieChartCategories> {
  @override
  Widget build(BuildContext context) {
    // Reverse the colors list
    final reversedColors = Colors.accents.reversed.toList();

    // Create pie chart sections
    List<PieChartSectionData> sections = widget.reportCategory.map((category) {
      final color = reversedColors[widget.reportCategory.indexOf(category) % reversedColors.length];
      return PieChartSectionData(
        color: color,
        value: category.percentage, // Replace with the actual amount or value
        title: "${category.percentage}%", // Customize title as needed
        radius: 90, // Adjust radius as needed
        titleStyle: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.black)
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: sections
              )
            ),
          ),
          const SizedBox(height: 15),
          _buildLegend(reversedColors),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildLegend(List<Color> reversedColors) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 8,
      runSpacing: 5,
      children: widget.reportCategory.map((category) {
        final color = reversedColors[widget.reportCategory.indexOf(category) % reversedColors.length];
        return Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(category.category), // Display the category name
          ],
        );
      }).toList(),
    );
  }
}
