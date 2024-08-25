import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/category_list/category_icon.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';

class CategoryShortSelection extends StatelessWidget {
  final FormStateType type;
  final TransactionCategory selectedCategory;

  const CategoryShortSelection(
      {super.key,
      required this.type,
      required this.selectedCategory,});


  @override
  Widget build(BuildContext context) {
  void onTransactionCategorySelected(TransactionCategory category) {
    Future.microtask(() async {
      final formStateService =
          Provider.of<FormStateProvider>(context, listen: false);
      formStateService.updateFormCategory(category, type);
    });
  }
    final colorScheme = Theme.of(context).colorScheme;
    List<TransactionCategory> categories = [];
    if (type == FormStateType.income || type == FormStateType.updateIncome) {
      categories = TransactionCategory.incomeCategories;
    } else if (type == FormStateType.expense ||
        type == FormStateType.updateExpense) {
      categories = TransactionCategory.expenseCategories;
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: categories.expand((category) {
              final isSelected = selectedCategory.name == category.name;
              Map<String, dynamic> categoryInfo =
                  transactionCategoryData[category]!;

              return [
                Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashColor: colorScheme.tertiary,
                      onTap: () async =>
                          {onTransactionCategorySelected(category)},
                      child: getCategoryIcon(
                          currentCategoryInfo: categoryInfo,
                          isSelected: isSelected,
                          colorScheme: colorScheme),
                    )),
                const SizedBox(width: 10)
              ];
            }).toList()));
  }
}