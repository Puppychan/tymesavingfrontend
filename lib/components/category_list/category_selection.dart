import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/components/category_list/category_icon.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class CategorySelectionPage extends StatefulWidget {
  final VoidCallback? onNavigateToNext;
  final FormStateType type;
  const CategorySelectionPage(
      {super.key, this.onNavigateToNext, required this.type});

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  @override
  Widget build(BuildContext context) {
    final formStateService =
        Provider.of<FormStateProvider>(context, listen: false);
    final TransactionCategory selectedCategory =
        formStateService.getCategory(widget.type);
    // function to handle the category selection
    Future<void> onTransactionCategorySelected(
        BuildContext context, TransactionCategory category) async {
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // context.read<FormStateProvider>().updateFormCategory(category);
      formStateService.updateFormCategory(category, widget.type);

      if (widget.onNavigateToNext != null) {
        widget.onNavigateToNext!();
      }
    }

    // function to render the category list
    List<Widget> renderCategories(BuildContext context) {
      List<TransactionCategory> categories = [];
      // render the categories based on the type of form
      if (widget.type == FormStateType.income || widget.type == FormStateType.updateIncome) {
        categories = TransactionCategory.incomeCategories;
      } else {
        categories = TransactionCategory.expenseCategories;
      }
      return categories.expand((category) {
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;
        final isSelected = selectedCategory.name == category.name;
        Map<String, dynamic>? categoryInfo = transactionCategoryData[category];
        return [
          Material(
              // color: isSelected ? colorScheme.background : Colors.transparent,
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: colorScheme.quaternary,
                  onTap: () async =>
                      {await onTransactionCategorySelected(context, category)},
                  child: ListTile(
                    leading: getCategoryIcon(
                        currentCategoryInfo: categoryInfo ?? {}),
                    title: Text(category.name, style: textTheme.bodyLarge),
                    trailing: isSelected
                        ? RoundedIcon(
                          hasShadow: false,
                            iconData: FontAwesomeIcons.circleCheck,
                            backgroundColor: colorScheme.inversePrimary.withOpacity(0.6),
                            iconColor: colorScheme.primary.withOpacity(0.6))
                        : null,
                  ))),

          const SizedBox(height: 10),
          const Divider(), // Adds a divider below the ListTile
        ];
      }).toList();
    }

    return SingleChildScrollView(
        child: Column(
      children: renderCategories(context),
    ));
  }
}
