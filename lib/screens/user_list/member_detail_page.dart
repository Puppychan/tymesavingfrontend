import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/animation_progress_bar.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/user/user_detail_widget.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/screens/transaction/view_all_transaction_page.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';

class MemberDetailPage extends StatefulWidget {
  final SummaryUser user;
  final String groupId;
  const MemberDetailPage(
      {super.key, required this.user, required this.groupId});

  @override
  State<MemberDetailPage> createState() => _OtherUserDetailState();
}

class _OtherUserDetailState extends State<MemberDetailPage> {
  void _fetchOtherUserDetails() async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getOtherUserInfo(
          widget.user.id,
          sharedBudgetId: widget.groupId,
        );
        // return result;
      }, () async {});
    });
  }

  Future<void> _fetchTransactions() async {
    await Provider.of<BudgetService>(context, listen: false)
        .fetchTransactionsByUserId(widget.groupId ?? "", widget.user.id ?? "");
  }

  @override
  void initState() {
    super.initState();
    _fetchOtherUserDetails();
    _fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final transactions = Provider.of<BudgetService>(context).transactions;

    return Consumer<UserService>(
      builder: (context, userService, child) {
        final user = userService.summaryUser;
        // TODO: change to real data
        const double groupConcurrentAmount = 10000000.0; // Example data
        // TODO: change to real data
        const double groupTargetAmount = 15000000.0; // Example data
        final double incomeAmount = user?.totalIncome ?? 0.0;
        final double expenseAmount = user?.totalExpense ?? 0.0;
        final double totalAmount = incomeAmount + expenseAmount;

        final double incomeProgress =
            totalAmount > 0 ? incomeAmount / totalAmount : 0.0;
        final double expenseProgress =
            totalAmount > 0 ? expenseAmount / totalAmount : 0.0;
        final double userGroupProgress = groupConcurrentAmount > 0
            ? totalAmount / groupConcurrentAmount
            : 0.0;
        const double groupTargetProgress = groupTargetAmount > 0
            ? groupConcurrentAmount / groupTargetAmount
            : 0.0;

        print("User Group Progress: $userGroupProgress");

        return Scaffold(
          appBar: Heading(
            title: user?.fullname ?? "。。。",
            showBackButton: true,
          ),
          body: SingleChildScrollView(
            padding: AppPaddingStyles.pagePaddingIncludeSubText,
            child: Column(
              children: [
                UserDetailWidget(
                    fetchedUser: user, otherDetails: user?.getOtherFields()),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: userGroupProgress.clamp(0.0, 1.0),
                    backgroundColor: colorScheme.quaternary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedProgressBar(
                  height: 10,
                  progress: userGroupProgress,
                  backgroundColor: colorScheme.quaternary,
                  progressColor: colorScheme.inversePrimary,
                  tooltipMessage: '${userGroupProgress * 100}%',
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: groupTargetProgress.clamp(0.0, 1.0),
                    backgroundColor: colorScheme.quaternary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.error),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'User Income vs Expense',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: colorScheme.quaternary,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.error),
                        minHeight: 8,
                      ),
                      LinearProgressIndicator(
                        value: incomeProgress,
                        backgroundColor: Colors.transparent,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'User Income & Expense vs Group Concurrent Amount',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value:
                        (incomeAmount / groupConcurrentAmount).clamp(0.0, 1.0),
                    backgroundColor: colorScheme.quaternary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value:
                        (expenseAmount / groupConcurrentAmount).clamp(0.0, 1.0),
                    backgroundColor: colorScheme.quaternary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.error),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  splashColor: colorScheme.quaternary,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewAllTransactionsPage(
                          transactions: transactions);
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Transactions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'View All',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
