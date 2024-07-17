import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/chart/budget_pie_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common_group/group_heading_actions.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetDetails extends StatefulWidget {
  const BudgetDetails({super.key, required this.budgetId});

  final String budgetId;

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> with RouteAware {
  Budget? _budget;
  double? percentageTaken;
  double? percentageLeft;
  DateTime? endDate;
  int? daysLeft;
  SummaryUser? _user;
  bool isMember = false;
  bool isLoading = true;
  String _displayPercentageTaken = '';
  bool _isDisplayRestDescription = false;
  List<Transaction> _transactions = [];

  Future<void> _renderUser(String? userId) async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getOtherUserInfo(userId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _user = userService.summaryUser;
        });
      });
    });
  }

  Future<void> _loadTransactions() async {
    if (!mounted) return;
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    await handleMainPageApi(context, () async {
      return await budgetService.fetchBudgetTransactions(widget.budgetId);
    }, () async {
      if (!mounted) return;
      setState(() {
        _transactions = budgetService.transactions;
      });
    });
  }

  Future<void> _loadData() async {
    Future.microtask(() async {
      if (!mounted) return;
      final budgetService = Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await budgetService.fetchBudgetDetails(widget.budgetId);
      }, () async {
        if (!mounted) return;
        final tempBudget = budgetService.currentBudget;
        // // set budget to update form
        final formStateService =
            Provider.of<FormStateProvider>(context, listen: false);
        formStateService.setUpdateBudgetFormFields(tempBudget);
        // render host user

        // set state for budget details
        setState(() {
          _budget = tempBudget;
          percentageTaken = _budget!.amount / _budget!.concurrentAmount * 100;
          percentageLeft =
              percentageTaken!.isInfinite ? 100.0 : 100.0 - percentageTaken!;
          endDate = DateTime.parse(_budget!.endDate);
          daysLeft = calculateDaysLeft(endDate!);
          // check if user is member or host
          isMember = _budget!.hostedBy.toString() !=
              Provider.of<AuthService>(context, listen: false).user?.id;
          isLoading = false;

          // set display string
          print(
              "percentageTaken: $percentageTaken, ${percentageTaken! > 199}, $percentageLeft");
          if (percentageTaken!.isInfinite) {
            _displayPercentageTaken = '0%';
          } else if (percentageTaken! > 199) {
            _displayPercentageTaken = "> 199%";
          } else {
            _displayPercentageTaken = '${percentageTaken?.toStringAsFixed(2)}%';
          }
        });
      });

      await _renderUser(_budget?.hostedBy);
      await _loadTransactions();
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<FormStateProvider>(context, listen: false)
        .resetForm(FormStateType.memberInvitation);
    routeObserver.unsubscribe(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _loadData();
    super.didPopNext();
  }

  int calculateDaysLeft(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: Heading(title: 'Budget', showBackButton: true, actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsis),
            onPressed: () {
              showGroupActionBottonSheet(
                  context, isMember, true, widget.budgetId);
            },
          )
        ]),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Center(
                    child: Card.filled(
                      color: colorScheme.onPrimary,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _budget!.name,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Hosted by ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: colorScheme.secondary,
                                            fontStyle: FontStyle.italic),
                                  ),
                                  TextSpan(
                                    text: _user?.fullname ?? 'Loading..',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: colorScheme.secondary,
                                            fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                // Action to view the rest of the description. This could open a dialog, a new page, or expand the text in place.
                                setState(() {
                                  _isDisplayRestDescription =
                                      !_isDisplayRestDescription;
                                });
                              },
                              child: Text(
                                _budget!.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                                maxLines: _isDisplayRestDescription ? null : 1,
                                overflow: _isDisplayRestDescription
                                    ? TextOverflow.visible
                                    : TextOverflow.fade,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'You have ',
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text:
                                        '$daysLeft', // Display the daysLeft variable here
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  TextSpan(
                                    text:
                                        ' day${daysLeft != 1 ? 's' : ''} left', // Pluralize based on the value of daysLeft
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Used ',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: _displayPercentageTaken,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge, // Customize this style as needed
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(formatAmountToVnd(_budget!.concurrentAmount),
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BudgetPieChart(
                      amount:
                          percentageTaken!.isInfinite ? 0 : percentageTaken!,
                      concurrent: percentageLeft!),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TransactionList(transactions: _transactions),
                  ),
                ],
              ));
  }
}
