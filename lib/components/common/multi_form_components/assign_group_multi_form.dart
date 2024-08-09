import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/group_tile.dart';
import 'package:tymesavingfrontend/models/base_group_model.dart';
import 'package:tymesavingfrontend/screens/search_page.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class AssignGroupMultiForm extends StatefulWidget {
  final FormStateType transactionType;
  final String userId;
  final void Function(String, {dynamic value}) updateOnChange;
  final TransactionGroupType chosenGroupType;
  final BaseGroup? chosenResult;

  const AssignGroupMultiForm(
      {super.key,
      required this.updateOnChange,
      required this.transactionType,
      required this.chosenGroupType,
      required this.userId,
      required this.chosenResult});

  @override
  State<AssignGroupMultiForm> createState() => _AssignGroupMultiFormState();
}

class _AssignGroupMultiFormState extends State<AssignGroupMultiForm> {
  // Define your state variables and methods here
  TransactionGroupType _currentChosenGroupType = TransactionGroupType.none;
  BaseGroup? _currentChosenResult;

  String _renderFormKeyGroup() {
    return _isBudget() ? "budgetGroupId" : "savingGroupId";
  }

  @override
  void initState() {
    super.initState();
    _currentChosenGroupType = widget.chosenGroupType;
    _currentChosenResult = widget.chosenResult;
  }

  bool _isBudget() {
    return _currentChosenGroupType == TransactionGroupType.budget;
  }

  void searchCallback(String value, Function(List<dynamic>) updateResults,
      CancelToken? cancelToken) async {
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    final groupSavingService =
        Provider.of<GroupSavingService>(context, listen: false);
    await handleMainPageApi(context, () async {
      if (_isBudget()) {
        return await budgetService.fetchBudgetList(widget.userId,
            name: value, cancelToken: cancelToken);
      } else {
        return await groupSavingService.fetchGroupSavingList(widget.userId,
            name: value, cancelToken: cancelToken);
      }
    }, () async {
      if (_isBudget()) {
        updateResults(budgetService.budgets);
      } else {
        updateResults(groupSavingService.groupSavings);
      }
    }, notFoundAction: () async {
      updateResults([]);
    }, cancelAction: () async {
      updateResults([]);
    });
  }

  void onTapSearchResult(dynamic result) {
    String updateFieldKey = _renderFormKeyGroup();

    widget.updateOnChange("groupType", value: _currentChosenGroupType);
    widget.updateOnChange(updateFieldKey, value: result.id);
    widget.updateOnChange("tempChosenGroup", value: result);
    Navigator.pop(context);
  }

  @override
  void didUpdateWidget(AssignGroupMultiForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chosenGroupType != oldWidget.chosenGroupType) {
      if (!mounted) return;
      setState(() {
        _currentChosenGroupType = widget.chosenGroupType;
      });
    }
    if (widget.chosenResult != oldWidget.chosenResult) {
      if (!mounted) return;
      setState(() {
        _currentChosenResult = widget.chosenResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(children: [
      RadioField(
          label: "This transaction is for: ",
          options: widget.transactionType == FormStateType.expense ?
          TransactionGroupType.formattedExpenseList: 
          TransactionGroupType.formattedIncomeList,
          onSelected: (String formattedChosenGroupType) {
            TransactionGroupType convertGroupType =
                TransactionGroupType.fromFormattedString(
                    formattedChosenGroupType);
            if (convertGroupType != _currentChosenGroupType) {
              String updateFieldKey = _renderFormKeyGroup();
              widget.updateOnChange(updateFieldKey, value: null);
              widget.updateOnChange("tempChosenGroup", value: null);
            }
            widget.updateOnChange("groupType", value: convertGroupType);
          },
          defaultOption: _currentChosenGroupType.toStringFormatted()),
      _currentChosenGroupType != TransactionGroupType.none
          ? InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(
                          title: "Search Group",
                          searchLabel: "Search using name",
                          searchPlaceholder: "Search group name here...",
                          customResultSize: (1 / 1.2),
                          searchCallback: (value, updateResults,
                                  cancelToken) async =>
                              searchCallback(value, updateResults, cancelToken),
                          resultWidgetFunction: (result) => GroupTile(
                              type: _currentChosenGroupType,
                              baseGroup: result,
                              onTap: () {
                                onTapSearchResult(result);
                              })),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Find to Add Group",
                      style: textTheme.titleSmall!
                          .copyWith(fontWeight: FontWeight.w700)),
                  Icon(FontAwesomeIcons.searchengin,
                      color: colorScheme.primary),
                ],
              ),
            )
          : Container(),
      if (_currentChosenResult != null) ...[
        const Divider(),
        Card(
          shadowColor: colorScheme.onPrimary,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Icon(_currentChosenGroupType == TransactionGroupType.budget
                    ? Icons.savings
                    : Icons.assessment),
                const SizedBox(height: 3),
                Text(_currentChosenResult?.name ?? "",
                    style: textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(
                  _currentChosenResult?.description ?? "",
                  style: textTheme.bodyMedium,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        )
      ] else
        Container(),
    ]);
  }
}
