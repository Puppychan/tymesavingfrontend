import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/approve_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/budget/budget_approve_page.dart';
import 'package:tymesavingfrontend/components/common/button/secondary_button.dart';
import 'package:tymesavingfrontend/components/common/chart/budget_pie_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common_group/group_heading_actions.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';
import 'package:tymesavingfrontend/form/transaction_add_form.dart';
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
  FormStateProvider? _formStateProvider;
  Budget? _budget;
  double? percentageTaken;
  double? percentageLeft;
  DateTime? endDate;
  int? daysLeft;
  SummaryUser? _user;
  bool isMember = false;
  bool approval = false;
  bool isLoading = true;
  String _displayPercentageTaken = '';
  bool _isDisplayRestDescription = false;

  List<Transaction> _transactions = [];
  List<Transaction> _awaitingApprovalTransaction = [];

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
        _awaitingApprovalTransaction = budgetService.awaitingApprovalTransaction;
        isLoading = false;
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
        _formStateProvider?.setUpdateBudgetFormFields(tempBudget);
        // render host user

        // set state for budget details
        if (!mounted) return;
        setState(() {
          _budget = tempBudget;
          percentageTaken = _budget!.concurrentAmount / _budget!.amount * 100;
          percentageLeft =
              percentageTaken!.isInfinite ? 100.0 : 100.0 - percentageTaken!;
          endDate = DateTime.parse(_budget!.endDate);
          daysLeft = calculateDaysLeft(endDate!);
          // check if user is member or host
          isMember = _budget!.hostedBy.toString() !=
              Provider.of<AuthService>(context, listen: false).user?.id;
          if(_budget!.defaultApproveStatus == ApproveStatus.pending.value) {
            approval = true;
          }
          // debugPrint(
          //     "percentageTaken: $percentageTaken, ${percentageTaken! > 199}, $percentageLeft");
          if (percentageTaken! < 0) {
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
    super.initState();
    _formStateProvider = Provider.of<FormStateProvider>(context, listen: false);
    _loadData();
  }

  @override
  void dispose() {
    // _formStateProvider?.resetForm(FormStateType.memberInvitation);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoading = true;
    _loadData();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    isLoading = true;
    _loadData();
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
        appBar: Heading(title: 'Budget Group', showBackButton: true, actions: [
          IconButton(onPressed: () async {
            if (!mounted) return;
            final formStateProvider =
                Provider.of<FormStateProvider>(context, listen: false);
            formStateProvider.resetForm(FormStateType.expense);
            formStateProvider.updateFormField("groupType", TransactionGroupType.budget, FormStateType.expense);
            formStateProvider.updateFormField("budgetGroupId", widget.budgetId, FormStateType.expense);
            formStateProvider.updateFormField("tempChosenGroup", _budget, FormStateType.expense);
            // render group
            if (!mounted) return;
            showTransactionFormA(context, false, isFromGroupDetail: true);
            
          }, icon: const Icon(FontAwesomeIcons.moneyCheckDollar)),
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsis),
            onPressed: () {
              showGroupActionBottomSheet(
                  context, isMember, true, widget.budgetId,);
            },
          )
        ]),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
              onRefresh: () => _pullRefreshAll(),
              child: SingleChildScrollView(
                child: Column(
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
                                
                                Text.rich(
                                  TextSpan(
                                    text: daysLeft! > 0 ? "You have " : "Budget expire by ",
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
                                            ' day${daysLeft != 1 ? 's' : ''}', // Pluralize based on the value of daysLeft
                                      ),
                                      TextSpan(
                                        text:
                                            daysLeft! > 0 ? " left" : "", // Pluralize based on the value of daysLeft
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Your initial budget', style: Theme.of(context).textTheme.bodyMedium,),
                                        const Expanded(child: SizedBox()),
                                        Text(formatAmountToVnd(_budget!.amount), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                                      ],  
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Current budget left', style: Theme.of(context).textTheme.bodyMedium,),
                                        const Expanded(child: SizedBox()),
                                        Text(formatAmountToVnd(_budget!.concurrentAmount), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Budget remain', style: Theme.of(context).textTheme.bodyMedium,),
                                        const Expanded(child: SizedBox()),
                                        Text(_displayPercentageTaken, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 2,
                                  runSpacing: 8,
                                  children:[ 
                                      Text(
                                        "Color ",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12)
                                      ),
                                      Container(
                                        width: 10,  // Width of the color box
                                        height: 10, // Height of the color box
                                        color: colorScheme.primary, // Color of the box
                                        margin: const EdgeInsets.only(right: 4), // Space between the box and the text
                                      ),
                                      Text(
                                        ' indicate',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      Text(
                                        ' percentages',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      Text(
                                        ' of',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      Text(
                                        ' budget',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      Text(
                                        ' left',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
              
                              ])
                              ],
                            ),
                          ),
                        ),
                      ),
                      BudgetPieChart(
                          amount:
                              percentageTaken! < 0 ? 0 : percentageTaken!,
                          concurrent: percentageLeft!),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            // Action to view the rest of the description. This could open a dialog, a new page, or expand the text in place.
                            setState(() {
                                _isDisplayRestDescription =
                                    !_isDisplayRestDescription;
                              });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _budget!.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.justify,
                                maxLines: _isDisplayRestDescription ? null : 2,
                                overflow: _isDisplayRestDescription
                                    ? TextOverflow.visible
                                    : TextOverflow.fade,
                              ),
                              if (!_isDisplayRestDescription)
                              Text(
                                "Tap for more",
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          )
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text('Transaction history', style: Theme.of(context).textTheme.headlineMedium,),
                      if (approval)
                      Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: 'Currently there are '),
                            TextSpan(
                              text: _awaitingApprovalTransaction.length.toString(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary, // Customize the color here
                                fontWeight: FontWeight.w500, // Optional: make the number bold
                              ),
                            ),
                            const TextSpan(text: ' request'),
                          ],
                        ),
                      ),
                      if (approval && !isMember)
                      const SizedBox(height: 20,),
                      if (approval && !isMember)
                      SizedBox(
                            width: 225,
                            height: 50,
                            child: SecondaryButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return BudgetApprovePage(budgetId: widget.budgetId,);
                                }));
                            } 
                            , title: "Approving transaction",
                          ),
                        ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 500,
                        child: RefreshIndicator(onRefresh: _pullRefresh, child: TransactionList(transactions: _transactions)),
                      ),
                    ],
                  ),
              ),
            ));
  }

  Future<void> _pullRefresh() async {
    _loadTransactions();
  }

  Future<void> _pullRefreshAll() async {
    setState(() {
      isLoading = true;
    });
    _loadData();
  }
}
