import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/group_tile.dart';
import 'package:tymesavingfrontend/screens/search_page.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class AssignGroupMultiForm extends StatefulWidget {
  final FormStateType transactionType;
  final String userId;
  final void Function(String, {dynamic value}) updateOnChange;
  final TransactionGroupType chosenGroupType;

  const AssignGroupMultiForm(
      {super.key,
      required this.updateOnChange,
      required this.transactionType,
      required this.chosenGroupType,
      required this.userId});

  @override
  State<AssignGroupMultiForm> createState() => _AssignGroupMultiFormState();
}

class _AssignGroupMultiFormState extends State<AssignGroupMultiForm> {
  // Define your state variables and methods here
  TransactionGroupType _currentChosenGroupType = TransactionGroupType.none;

  @override
  void initState() {
    super.initState();
    _currentChosenGroupType = widget.chosenGroupType;
  }

  bool _isBudget() {
    return _currentChosenGroupType == TransactionGroupType.budget;
  }

  void searchCallback(String value, Function(List<dynamic>) updateResults,
      CancelToken? cancelToken) async {
    print("UpdatedResults $value");
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
    final multipleFormPageService =
        Provider.of<FormStateProvider>(context, listen: false);
    String updateFieldKey = _isBudget() ? "budgetGroupId" : "savingGroupId";
    multipleFormPageService.updateFormField(
        updateFieldKey, result.id, widget.transactionType);
    Navigator.pop(context);
    SuccessDisplay.showSuccessToast("Add user to invition list", context);
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
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(children: [
      RadioField(
          label: "Belong to Group?",
          options: TransactionGroupType.formattedList,
          onSelected: (String formattedChosenGroupType) {
            widget.updateOnChange("groupType",
                value: TransactionGroupType.fromFormattedString(
                    formattedChosenGroupType));
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
                      color: Theme.of(context).colorScheme.primary),
                ],
              ),
            )
          : Container(),
    ]);
  }
}
