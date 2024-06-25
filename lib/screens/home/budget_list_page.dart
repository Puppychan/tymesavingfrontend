import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  void _fetchBudgets() async {
    Future.microtask(() async {
      if (!mounted) return;
      final budgetService = Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        // return await budgetService.fetchBudgetGroup();
      }, () async {
        setState(() {
        });
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
      return budgets.isNotEmpty
          ? Expanded(
              child: ListView.separated(
              itemCount: budgets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return UserCard(user: budgets[index]);
              },
            ))
          : const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
      // return ElevatedButton(
      //   onPressed: () => showStyledBottomSheet(
      //     context: context,
      //     title: "Filter",
      //     contentWidget: UserSortFilter(updateUserList: _fetchBudgets),
      //   ),
      //   child: const Text('Show Filter'),
      // );
    });
  }
}
