import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_dialog.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class CategoryDetails {
  IconData icon;
  Color color;

  CategoryDetails(
      String transactionCategory, IconData randomIcon, Color randomColor)
      : icon = randomIcon,
        color = randomColor {
    // define the category
    TransactionCategory category =
        TransactionCategory.fromString(transactionCategory);
    // get the category data for rendering the icon and color
    final categoryData = transactionCategoryData[category];
    if (categoryData != null) {
      icon = categoryData['icon'] ?? randomIcon;
      color = categoryData['color'] ?? randomColor;
    }
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final String formattedDate;
  final IconData randomIcon;
  final Color randomColor;

  const TransactionItem(
      {super.key,
      required this.transaction,
      required this.formattedDate,
      required this.randomIcon,
      required this.randomColor});

  @override
  Widget build(BuildContext context) {
    final displayCategoryData =
        CategoryDetails(transaction.category, randomIcon, randomColor);

    // Determine title and category display
    final title = transaction.user != null
        ? transaction.user!.username.toUpperCase()
        : transaction.category;
    final categoryDisplay =
        transaction.user != null ? transaction.category : '';
    final groupType = transaction.budgetGroupId != null
        ? 'Budget Group'
        : transaction.savingGroupId != null
            ? 'Saving Group'
            : 'Personal';
    final TextStyle displayTestStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Montserrat',
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        leading: transaction.user != null
            ? Transform.scale(
                scale: 1.2,
                child: CircleAvatar(
                  backgroundColor: displayCategoryData.color,
                  child: Icon(
                    displayCategoryData.icon,
                    color: Colors.white,
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: displayCategoryData.color,
                child: Icon(
                  displayCategoryData.icon,
                  color: Colors.white,
                ),
              ),
        title: Row(children: [
          if (transaction.isMomo != null && transaction.isMomo!)
            Image.asset(
              'assets/img/momo_icon.png',
              width: 15,
              height: 15,
            ),
            const SizedBox(width: 5),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.user != null) ...[
              const SizedBox(height: 3),
              Text(
                "$categoryDisplay - ${transaction.type}",
                style: displayTestStyle,
              ),
            ],
            const SizedBox(height: 3),
            Text(
              groupType,
              style: displayTestStyle,
            ),
            const SizedBox(height: 3),
            Text(
              formattedDate,
              style: displayTestStyle,
            ),
          ],
        ),
        trailing: Text(
          transaction.type == 'Income'
              ? '+ ${formatAmountToVnd(transaction.amount)}'
              : '- ${formatAmountToVnd(transaction.amount)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TransactionDialog(
                  transaction: transaction, formattedDate: formattedDate);
            },
          );
        },
      ),
    );
  }
}
