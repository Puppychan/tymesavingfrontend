import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/chart/budget_pie_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

List<Widget> renderHeadingActions(BuildContext context, bool isMember) {
  List<Widget> actions = [
    IconButton(
      icon: const Icon(Icons.people_rounded),
      onPressed: () {
        // Navigate to the edit page
      },
    ),
    IconButton(
      icon: const Icon(Icons.wallet_sharp),
      onPressed: () {
        // Navigate to the edit page
      },
    ),
  ];
  // if host
  if (!isMember) {
    actions.add(
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // Navigate to the edit page
        },
      ),
    );
  }
  return actions;
}

class BudgetDetails extends StatefulWidget {
  const BudgetDetails({super.key, required this.budgetId});

  final String budgetId;

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  late final Budget? _budget;
  late final double? percentageTaken;
  late final double? percentageLeft;
  late DateTime? endDate;
  late int? daysLeft;
  User? _user;
  bool isLoading = true;

  Future<void> _renderUser(userId) async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getUserDataById(userId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _user = userService.currentFetchUser;
        });
      });
    });
  }

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final budgetService =
          Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await budgetService.fetchBudgetDetails(widget.budgetId);
      }, () async {
        if (!mounted) return;
        final tempBudget = budgetService.currentBudget;
        // // set budget to update form
        final formStateService =
            Provider.of<FormStateProvider>(context, listen: false);
        formStateService.setUpdateBudgetFormFields(tempBudget);
        setState(() {
          _budget = tempBudget!;
          percentageTaken = _budget!.amount / _budget.concurrentAmount * 100;
          percentageLeft = percentageTaken!.isInfinite ? 100.0 : 100.0 - percentageTaken!;
          endDate = DateTime.parse(_budget.endDate);
          daysLeft = calculateDaysLeft(endDate!);
          isLoading = false;
        });
        await _renderUser(tempBudget!.hostedBy);
      });
    });

    super.initState();
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
      appBar: const Heading(
        title: 'Budget details',
        showBackButton: true, 
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Center(
            child: Card.filled(
              color: colorScheme.onPrimary,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_budget!.name, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hosted by ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          TextSpan(
                            text: _user?.fullname ?? '...',
                            style: Theme.of(context).textTheme.headlineMedium, // Customize this style as needed
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10,),
                    Text.rich(
                      TextSpan(
                        text: 'You have ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '$daysLeft', // Display the daysLeft variable here
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: ' day${daysLeft != 1 ? 's' : ''} left', // Pluralize based on the value of daysLeft
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Used ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: percentageTaken!.isInfinite ? '0%' : '${percentageTaken?.toStringAsFixed(2)}%',
                            style: Theme.of(context).textTheme.bodyMedium, // Customize this style as needed
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: _budget.concurrentAmount.toString(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          TextSpan(
                            text: 'đ',
                            style: Theme.of(context).textTheme.headlineMedium, // Customize this style as needed
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          BudgetPieChart(amount: percentageTaken!.isInfinite ? 0 : percentageTaken! , concurrent: percentageLeft!),
          const SizedBox(height: 20,),
          Card.filled(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: 
            Column(
              children: [
                Text('Description', style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: 10,),
                Text(_budget.description,
                style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,
                overflow: TextOverflow.clip,),
              ],
            )
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 300,
            child: PrimaryButton(
                title: 'UPDATE',
                // TODO: Add method to open update pages!
                onPressed: (){}),
          ),
          const SizedBox(height: 50),
        ],
      )
    );
  }
}