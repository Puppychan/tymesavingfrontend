import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';

class ReportDetail extends StatefulWidget {
  const ReportDetail({super.key, required this.topCategories});

  final List<TopCategory> topCategories;

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.topCategories.length,
            itemBuilder: (context, index) {
              return CategoryCardItem(
                  amountSpend: widget.topCategories[index].totalAmount,
                  categoryName: widget.topCategories[index].category);
            }));
  }
}

class CategoryCardItem extends StatefulWidget {
  const CategoryCardItem(
      {super.key, required this.amountSpend, required this.categoryName});

  final String categoryName;
  final int amountSpend;

  @override
  State<CategoryCardItem> createState() => _CategoryCardItemState();
}

class _CategoryCardItemState extends State<CategoryCardItem> {
  //Append icon to category
  final Map<String, Map<String, dynamic>> categoryData = {
    'Dine out': {'icon': Icons.restaurant, 'color': Colors.red},
    'Shopping': {'icon': Icons.shopping_cart, 'color': Colors.blue},
    'Travel': {'icon': Icons.airplanemode_active, 'color': Colors.orange},
    'Entertainment': {'icon': Icons.movie, 'color': Colors.purple},
    'Personal': {'icon': Icons.person, 'color': Colors.teal},
    'Transportation': {'icon': Icons.directions_car, 'color': Colors.green},
    'Rent/Mortgage': {'icon': Icons.home, 'color': Colors.brown},
    'Utilities': {'icon': Icons.lightbulb, 'color': Colors.yellow},
    'Bills & Fees': {'icon': Icons.receipt, 'color': Colors.grey},
    'Health': {'icon': Icons.local_hospital, 'color': Colors.pink},
    'Education': {'icon': Icons.school, 'color': Colors.indigo},
    'Groceries': {'icon': Icons.local_grocery_store, 'color': Colors.lime},
    'Gifts': {'icon': Icons.card_giftcard, 'color': Colors.redAccent},
    'Work': {'icon': Icons.work, 'color': Colors.blueAccent},
    'Other expenses': {'icon': Icons.money_off, 'color': Colors.black},
  };


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final category = categoryData[widget.categoryName] ?? {'icon': Icons.money_off, 'color': colorScheme.error};
    final IconData iconData = category['icon'];
    final Color color = category['color'];
    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Icon(iconData, color: color, size: 30),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: widget.categoryName,
                      style: textTheme
                          .titleSmall!, // Default style for the first part
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '${widget.amountSpend} vnd',
                      style: textTheme
                          .titleSmall!, // Default style for the first part
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
