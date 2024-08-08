import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
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
    return SizedBox(
        height: 400,
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
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final category = transactionCategoryData[
            TransactionCategory.fromString(widget.categoryName)] ??
        {'icon': Icons.money_off, 'color': colorScheme.error};
    final IconData iconData = category['icon'];
    final Color color = category['color'];
    return Card.outlined(
      color: colorScheme.onPrimary,
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
                          .bodyLarge!, // Default style for the first part
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '${widget.amountSpend} ₫',
                      style: textTheme
                          .bodyLarge!, // Default style for the first part
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
