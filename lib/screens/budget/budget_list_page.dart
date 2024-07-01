import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/budget/budget_card.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/components/user/user_card.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetListPage extends StatefulWidget {
  const BudgetListPage({super.key});
  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  // void _fetchBudgets() async {
  //   Future.microtask(() async {
  //     if (!mounted) return;
  //     final budgetService = Provider.of<BudgetService>(context, listen: false);
  //     await handleMainPageApi(context, () async {
  //       // TODO: add the fetchBudgetGroup method to the budgetService
  //       // return await budgetService.fetchBudgetGroup();
  //     }, () async {
  //       setState(() {
  //         // TODO: add the budgetGroup to the budgetService
  //       });
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _fetchBudgets();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Remove this temporary budget
    final budgets = [tempBudget];
    return Consumer<BudgetService>(builder: (context, budgetService, child) {
      // final budgets = budgetService.budgets;
      return Padding(
          padding: AppPaddingStyles.pagePadding,
          child: budgets.isNotEmpty
              ? ListView.separated(
                  itemCount: budgets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return BudgetCard(budgetId: budgets[index].id);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ));
    });
  }
}
