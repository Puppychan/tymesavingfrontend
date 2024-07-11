import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/budget/budget_card.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetListPage extends StatefulWidget {
  final User? user;
  const BudgetListPage({super.key, this.user});
  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  void _fetchBudgets() async {
    Future.microtask(() async {
      if (!mounted) return;
      final budgetService = Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await budgetService.fetchBudgetList(widget.user?.id);
      }, () async {
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBudgets();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetService>(builder: (context, budgetService, child) {
      final budgets = budgetService.budgets;
      return Padding(
          padding: AppPaddingStyles.pagePadding,
          child: budgets.isNotEmpty
              ? ListView.separated(
                  itemCount: budgets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return BudgetCard(budget: budgets[index]);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ));
    });
  }
}
