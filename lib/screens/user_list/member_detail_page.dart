import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/animation_progress_bar.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/user/user_detail_widget.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/screens/transaction/view_all_transaction_page.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';

class MemberDetailPage extends StatefulWidget {
  final SummaryUser user;
  final String groupId;
  const MemberDetailPage(
      {super.key, required this.user, required this.groupId});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  Budget? group;
  double groupConcurrentAmount = 0;
  double groupTargetAmount = 0;
  List<Transaction> transactions = [];

  SummaryUser? user;
  double incomeAmount = 0;
  double expenseAmount = 0;
  double totalAmount = 0;

  double incomeProgress = 0;
  double expenseProgress = 0;
  double userGroupProgress = 0;
  double groupTargetProgress = 0;

  Future<void> _fetchOtherUserDetails() async {
    if (!mounted) return;
    final userService = Provider.of<UserService>(context, listen: false);
    await handleMainPageApi(context, () async {
      return await userService.getOtherUserInfo(
        widget.user.id,
        sharedBudgetId: widget.groupId,
      );
      // return result;
    }, () async {
      setState(() {
        user = userService.summaryUser;
        incomeAmount = user?.totalIncome ?? 0.0;
        expenseAmount = user?.totalExpense ?? 0.0;
        totalAmount = incomeAmount + expenseAmount;

        incomeProgress = totalAmount > 0 ? incomeAmount / totalAmount : 0.0;

        expenseProgress = totalAmount > 0 ? expenseAmount / totalAmount : 0.0;
        userGroupProgress = groupConcurrentAmount > 0
            ? totalAmount / groupConcurrentAmount
            : 0.0;
        groupTargetProgress = groupTargetAmount > 0
            ? groupConcurrentAmount / groupTargetAmount
            : 0.0;
      });
      print("Income progress: $incomeProgress");
    });
  }

  Future<void> _fetchGroupDetails() async {
    Future.microtask(() async {
      if (!mounted) return;
      final groupService = Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await groupService.fetchBudgetDetails(widget.groupId);
        // return result;
      }, () async {
        setState(() {
          group = groupService.currentBudget;
          groupConcurrentAmount = group?.concurrentAmount ?? 0;
          groupTargetAmount = group?.amount ?? 0;

        });

        await _fetchOtherUserDetails();
        await _fetchTransactions();
      });
    });
  }

  Future<void> _fetchTransactions() async {
    await handleMainPageApi(context, () async {
      return await Provider.of<BudgetService>(context, listen: false)
          .fetchTransactionsByUserId(
              widget.groupId, widget.user.id);
    }, () async {
      setState(() {
        transactions = Provider.of<BudgetService>(context, listen: false)
            .transactions;
      });
    });
  }

  @override
  void initState() {
    _fetchGroupDetails();
    super.initState();
    // Future.microtask(
    //   () {
    //     _disposeContent();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            const SizedBox(height: 10),
            InkWell(
                  splashColor: colorScheme.quaternary,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ViewAllTransactionsPage();
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "Total Transactions: ${user?.transactionCount ?? 0}",
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
              ),
              TextButton(
                  onPressed: () {
                    // TODO: view all transactions page
                  },
                  child: Text("View History",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: colorScheme.primary,
                          )))
            ]),
            const Divider(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTransactionSummaryCard(true, incomeAmount, context),
                _buildTransactionSummaryCard(false, expenseAmount, context),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text("Transaction Summary",
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 30),
            AnimatedProgressBar(
              title: "User Income & Expense Progress",
              base: {
                "text": "User Total Amount",
                "value": totalAmount,
              },
              progressList: [
                {
                  'progress': incomeProgress,
                  'progressColor': colorScheme.error,
                  'progressText': 'User Income',
                  'originValue': incomeAmount,
                },
                {
                  'progress': expenseProgress,
                  'progressColor': colorScheme.inversePrimary,
                  'progressText': 'User Expense',
                  'originValue': expenseAmount,
                },
              ],
              backgroundColor: colorScheme.quaternary,
            ),
            const SizedBox(height: 35),
            AnimatedProgressBar(
              title: "User Total Amount towards Group Concurrent Amount",
              base: {
                "text": "Group Current Amount",
                "value": groupConcurrentAmount,
              },
              progressList: [
                {
                  'progress': userGroupProgress,
                  'progressColor': colorScheme.inversePrimary,
                  'progressText': 'User Total Progress',
                  'originValue': totalAmount,
                },
              ],
              backgroundColor: colorScheme.quaternary,
            ),
            const SizedBox(height: 35),
            const Divider(),
            const SizedBox(height: 10),
            Text("General Progress",
                style: Theme.of(context).textTheme.titleSmall),
            Text(group?.name ?? "Loading group...",
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                "From ${convertTimestamptzToReadableDate(group?.createdDate)} - To ${convertTimestamptzToReadableDate(group?.endDate)}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontStyle: FontStyle.italic,
                    )),
            const SizedBox(height: 20),
            AnimatedProgressBar(
              title: "Group Target Amount vs Group Concurrent Amount",
              base: {
                "text": "Group Target Amount",
                "value": groupTargetAmount,
              },
              progressList: [
                {
                  'progress': groupTargetProgress,
                  'progressColor': colorScheme.error,
                  'progressText': 'Group Concurrent Progress',
                  'originValue': groupConcurrentAmount,
                },
              ],
              backgroundColor: colorScheme.quaternary,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSummaryCard(
      bool isIncome, double amount, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
        elevation: 10,
        color: colorScheme.onSecondary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  alignment: WrapAlignment.start,
                  children: [
                    Icon(
                        isIncome
                            ? FontAwesomeIcons.anglesUp
                            : FontAwesomeIcons.anglesDown,
                        color:
                            isIncome ? colorScheme.success : colorScheme.error,
                        size: 18),
                    Text(isIncome ? "Income" : "Expense",
                        style: textTheme.bodyLarge!
                            .copyWith(color: colorScheme.secondary))
                  ]),
              const SizedBox(height: 10),
              Text(
                "Amount: ${formatAmountToVnd(amount)}",
                style: textTheme.bodyMedium,
                maxLines: 3,
              ),
            ],
          ),
        ));
  }
}
