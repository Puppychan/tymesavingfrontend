// import 'package:flutter/material.dart';
// import 'package:tymesavingfrontend/common/styles/app_color.dart';
// import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
// import 'package:tymesavingfrontend/models/transaction.model.dart';
// import 'month_tab.dart'; // Import the new MonthTab widget

// class TransactionMonthTabs extends StatelessWidget {
//   TransactionMonthTabs({super.key});

//   final Map<String, List<Transaction>> monthlyTransactions = {
//     "Jan": [
//       Transaction(
//         id: "1",
//         type: "expense",
//         category: "Groceries",
//         amount: 50,
//         createdDate: DateTime(2023, 1, 1),
//       ),
//       Transaction(
//         id: "2",
//         type: "expense",
//         category: "Rent",
//         amount: 1000,
//         createdDate: DateTime(2023, 1, 5),
//       ),
//     ],
//     "Feb": [
//       Transaction(
//         id: "3",
//         type: "expense",
//         category: "Utilities",
//         amount: 100,
//         createdDate: DateTime(2023, 2, 3),
//       ),
//     ],
//     // Add transactions for other months...
//   };

//   final List<String> months = const [
//     "Jan",
//     "Feb",
//     "Mar",
//     "Apr",
//     "May",
//     "Jun",
//     "Jul",
//     "Aug",
//     "Sep",
//     "Oct",
//     "Nov",
//     "Dec"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: months.length,
//       child: TabBar(
//         isScrollable: true,
//         tabAlignment: TabAlignment.start,
//         indicator: const UnderlineTabIndicator(
//           borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0),
//         ),
//         labelStyle:
//             AppTextStyles.subHeadingSmall.copyWith(fontWeight: FontWeight.w600),
//         unselectedLabelStyle: AppTextStyles.subHeadingSmall,
//         tabs: months.map((month) => MonthTab(month: month)).toList(),
    
//       ),
//     );
//   }
// }
