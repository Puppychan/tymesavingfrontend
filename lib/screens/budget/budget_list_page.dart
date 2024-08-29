import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/budget/budget_card.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetListPage extends StatefulWidget {
  final User? user;
  const BudgetListPage({super.key, this.user});
  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> with RouteAware {
  bool _isLoading = false;
  void _fetchBudgets() async {
    Future.microtask(() async {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      if (!mounted) return;
      final budgetService = Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await budgetService.fetchBudgetList(widget.user?.id);
      }, () async {
      });
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBudgets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBudgets();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchBudgets();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetService>(builder: (context, budgetService, child) {
      final budgets = budgetService.budgets;
      return _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: AppPaddingStyles.pagePadding,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search),
                          labelText: 'Search',
                          labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal
                          ),
                          border: InputBorder.none
                        ),
                        onSubmitted: (String value) {
                          setState(() {
                            // searchName = value.toString().trimRight();
                            // isLoading = true;
                          });
                        },
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  budgets.isNotEmpty
                  ? Flexible(
                    child: RefreshIndicator(
                      onRefresh: () =>
                        _pullRefresh(),
                      child: ListView.separated(
                          itemCount: budgets.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            return BudgetCard(budget: budgets[index]);
                          },
                        ),
                    ),
                  )
                  : const NotFoundMessage(message: "No budgets found")
                ],
              ));
    });
  }
  Future<void> _pullRefresh() async {
    _fetchBudgets();
  }
}
