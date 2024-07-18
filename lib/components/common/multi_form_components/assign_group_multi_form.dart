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
  final Function(String, String) updateOnChange;
  final String defaultOption;
  final String chosenGroupType;

  const AssignGroupMultiForm(
      {super.key,
      required this.updateOnChange,
      required this.chosenGroupType,
      required this.defaultOption, required this.transactionType});

  @override
  State<AssignGroupMultiForm> createState() => _AssignGroupMultiFormState();
}

class _AssignGroupMultiFormState extends State<AssignGroupMultiForm> {
  // Define your state variables and methods here

  bool _isBudget() {
    return TransactionGroupType.fromString(widget.chosenGroupType) ==
        TransactionGroupType.budget;
  }

  void searchGroups(String value, Function(List<dynamic>) updateResults,
      CancelToken? cancelToken) async {
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    final groupSavingService =
        Provider.of<GroupSavingService>(context, listen: false);
    await handleMainPageApi(context, () async {
      if (_isBudget()) {
        return await budgetService
            .fetchBudgetList(value, cancelToken: cancelToken);
      } else {
        return await groupSavingService
            .fetchGroupSavingList(value, cancelToken: cancelToken);
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(children: [
      RadioField(
          label: "Belong to Group?",
          options: TransactionGroupType.formattedList,
          onSelected: (String chosenGroupType) {
            widget.updateOnChange("groupType", chosenGroupType);
          },
          defaultOption: widget.defaultOption),
      widget.chosenGroupType != TransactionGroupType.none.toString()
          ? InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(
                          title: "Search Group",
                          searchLabel: "Search using name",
                          searchPlaceholder: "Search group name here...",
                          searchCallback: (value, updateResults,
                                  cancelToken) async =>
                              searchGroups(value, updateResults, cancelToken),
                          resultWidgetFunction: (result) => GroupTile(
                              type: TransactionGroupType.fromString(
                                  widget.chosenGroupType),
                              baseGroup: result,
                              onTap: () {
                                // userController.text = result.id;
                                final multipleFormPageService =
                                    Provider.of<FormStateProvider>(context,
                                        listen: false);
                                        String updateFieldKey = _isBudget() ? "budgetGroupId" : "savingGroupId";
                                multipleFormPageService.updateFormField(updateFieldKey, result.id, widget.transactionType);
                                Navigator.pop(context);
                                SuccessDisplay.showSuccessToast(
                                    "Add user to invition list", context);
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
