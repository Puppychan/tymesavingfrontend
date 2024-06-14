import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'month_tab.dart'; // Import the new MonthTab widget

class TransactionMonthTabs extends StatelessWidget {
  const TransactionMonthTabs({super.key});

  final List<String> months = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: months.length,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0),
        ),
        labelStyle:
            AppTextStyles.subHeadingSmall.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.subHeadingSmall,
        tabs: months.map((month) => MonthTab(month: month)).toList(),
      ),
    );
  }
}
