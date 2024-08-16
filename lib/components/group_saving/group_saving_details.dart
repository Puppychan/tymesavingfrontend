import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/button/secondary_button.dart';
import 'package:tymesavingfrontend/components/common/chart/group_saving_half_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common_group/group_heading_actions.dart';
import 'package:tymesavingfrontend/components/group_saving/group_saving_report.dart';
import 'package:tymesavingfrontend/components/group_saving/saving_approve_page.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';
import 'package:tymesavingfrontend/form/transaction_add_form.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupSavingDetails extends StatefulWidget {
  const GroupSavingDetails({super.key, required this.groupSavingId});

  final String groupSavingId;

  @override
  State<GroupSavingDetails> createState() => _GroupSavingDetailsState();
}

class _GroupSavingDetailsState extends State<GroupSavingDetails> with RouteAware {
  FormStateProvider? _formStateProvider;
  GroupSaving? _groupSaving;
  double? percentageTaken;
  double? percentageLeft;
  DateTime? endDate;
  int? daysLeft;
  String? endDay;
  SummaryUser? _user;
  bool isMember = false;
  bool isLoading = true;
  bool approval = false;
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
    final groupSavingService = Provider.of<GroupSavingService>(context, listen: false);
    await handleMainPageApi(context, () async {
      return await groupSavingService.fetchGroupSavingTransactions(widget.groupSavingId);
    }, () async {
      if (!mounted) return;
      setState(() {
        _transactions = groupSavingService.transactions;
        _awaitingApprovalTransaction = groupSavingService.awaitingApprovalTransaction;
        isLoading = false;
      });
    });
  }

  Future<void> _loadData() async {
    Future.microtask(() async {
      if (!mounted) return;
      final groupSavingService = Provider.of<GroupSavingService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await groupSavingService.fetchGroupSavingDetails(widget.groupSavingId);
      }, () async {
        if (!mounted) return;
        final tempGroupSaving = groupSavingService.currentGroupSaving;
        // // set groupSaving to update form
        _formStateProvider?.setUpdateGroupSavingFormFields(tempGroupSaving);
        // render host user

        // set state for groupSaving details
        setState(() {
          _groupSaving = tempGroupSaving;
          percentageTaken = _groupSaving!.concurrentAmount / _groupSaving!.amount * 100;
          percentageLeft =
              percentageTaken!.isInfinite ? 100.0 : 100.0 - percentageTaken!;
          endDate = DateTime.parse(_groupSaving!.endDate);
          daysLeft = calculateDaysLeft(endDate!);
          endDay = formatDate(endDate!);
          // check if user is member or host
          isMember = _groupSaving!.hostedBy.toString() !=
              Provider.of<AuthService>(context, listen: false).user?.id;
          // check group status
          if(_groupSaving!.defaultApproveStatus == "Pending") {
            approval = true;
          }
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

      await _renderUser(_groupSaving?.hostedBy);
      await _loadTransactions();
    });
  }

  @override
  void initState() {
    _formStateProvider = Provider.of<FormStateProvider>(context, listen: false);
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    // _formStateProvider?.resetForm(FormStateType.memberInvitation);
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void didChangeDependencies() {
    isLoading = true;
    _loadData();
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

  String formatDate(DateTime endDate){
    String formattedDate = DateFormat('MMMM d, y').format(endDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    
    
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: Heading(title: 'Group Saving', showBackButton: true, actions: [
          IconButton(onPressed: () {
            if (!mounted) return;
            // TODO: TEMP - check if group saving is income
            final formStateProvider =
                Provider.of<FormStateProvider>(context, listen: false);
            formStateProvider.resetForm(FormStateType.income);
            formStateProvider.updateFormField("groupType", TransactionGroupType.savings, FormStateType.income);
            formStateProvider.updateFormField("savingGroupId", _groupSaving!.id, FormStateType.income);
                        // render group
            if (!mounted) return;
            formStateProvider.updateFormField("tempChosenGroup", _groupSaving, FormStateType.income);
            showTransactionFormA(context, true, isFromGroupDetail: true);
          }, icon: const Icon(FontAwesomeIcons.moneyCheckDollar)),
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsis),
            onPressed: () {
              showGroupActionBottomSheet(
                  context, isMember, true, widget.groupSavingId);
            },
          )
        ]),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                                _groupSaving!.name,
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
                                height: 20,
                              ),
                              GroupSavingHalfProgressBar(
                              amount:
                                  percentageTaken!.isInfinite ? 0 : percentageTaken!,
                              concurrent: percentageLeft!),                           
                              const SizedBox(
                                height: 10,
                              ),
                              if (percentageTaken! > 100) 
                              Column(
                                children: [
                                  Text (' You have reached your goal and beyond!', style:Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 5,),
                                ],
                              ),
                              Text.rich(
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                TextSpan(
                                  text: '$daysLeft day${daysLeft != 1 ? 's' : ''}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    if(daysLeft! > 0)
                                    TextSpan(
                                      text:
                                          ' left until $endDay', 
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                              if(daysLeft! < 0)
                              Text('$endDay'),
                              const SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('You have saved', style: Theme.of(context).textTheme.bodyMedium,),
                                      const Expanded(child: SizedBox()),
                                      Text(formatAmountToVnd(_groupSaving!.concurrentAmount), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                                    ],  
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Goal target', style: Theme.of(context).textTheme.bodyMedium,),
                                      const Expanded(child: SizedBox()),
                                      Text(formatAmountToVnd(_groupSaving!.amount), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                        _groupSaving!.description,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                                  return SavingApprovePage(savingId: widget.groupSavingId,);
                                }));
                            } 
                            , title: "Approving transaction",
                          ),
                        ),
                    SizedBox(
                      height: 500,
                      child: RefreshIndicator(onRefresh: _pullRefresh, child: TransactionList(transactions: _transactions)),
                    ),
                  ],
                ),
            ));
  }

  Future<void> _pullRefresh() async {
    _loadTransactions();
  }
}