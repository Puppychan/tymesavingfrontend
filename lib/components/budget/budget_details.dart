import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/chart/budget_pie_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetDetails extends StatefulWidget {
  const BudgetDetails({super.key, required this.budgetId});

  final String budgetId;

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  late Budget _budget;

  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() async {
      if (!mounted) return;
      final budgetService =
          Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        // TODO: add the fetchBudgetDetails method to the budgetService
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
        });

        // // update state
        // setState(() {
        //   _budget = tempBudget;
        // });
        // await _renderUser(tempBudget!.userId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(
        title: 'Budget details',
        showBackButton: true, 
      ),
      body: Column(
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
                    Text(_budget.name, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center,),
                    Text('By Duong', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
                    const SizedBox(height: 10,),
                    Text('You have 10 days left', style: Theme.of(context).textTheme.bodyMedium),
                    Text('Used 50%', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
                    const SizedBox(height: 10,),
                    Text('5.983,321 vnd', style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
            ),
          ),
          BudgetPieChart(amount: 10, concurrent: 10),
          const SizedBox(height: 20,),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text('',
            style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,
            overflow: TextOverflow.clip,),
          )
        ],
      )
    );
  }
}