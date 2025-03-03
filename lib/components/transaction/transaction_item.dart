import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_dialog.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TransactionDialog(
                transaction: transaction, formattedDate: formattedDate);
          },
        );
      },
      child: Card(
          color: Theme.of(context).colorScheme.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Left
              Expanded(
                flex: 1, // 1/4
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate, // Time
                      style: textTheme.bodySmall!
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    Text(title, // Date
                        style: textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Vertical Divider
              Container(
                width: 2,
                height: 55,
                color: colorScheme.divider,
              ),
              const SizedBox(width: 16),

              // Right
              Expanded(
                  flex: 3, // 3/4
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildCategory(displayCategoryData),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              transaction.type == 'Income'
                                  ? '+ ${formatAmountToVnd(transaction.amount)}'
                                  : '- ${formatAmountToVnd(transaction.amount)}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis, // Apply ellipsis overflow
                            ),
                          ),
                          
                          if (transaction.isMomo != null && transaction.isMomo!)
                            Image.asset(
                              'assets/img/momo_icon.png',
                              width: 25,
                              height: 25,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$categoryDisplay - $groupType',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ))
            ]),
          )),
    );
  }

  Widget _buildCategory(CategoryDetails displayCategoryData) {
    return transaction.user != null
        ? RoundedIcon(
            backgroundColor: displayCategoryData.color,
            iconData: displayCategoryData.icon,
            iconColor: Colors.white,
            size: 25,
          )
        : CircleAvatar(
            backgroundColor: displayCategoryData.color,
            child: Icon(
              displayCategoryData.icon,
              color: Colors.white,
            ),
          );
  }
}
