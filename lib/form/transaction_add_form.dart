import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
// import 'package:tymesavingfrontend/components/multiple_page_sheet/common/add_amount_calculator.dart';
import 'package:tymesavingfrontend/form/common_form/transaction_form.dart';
import 'package:tymesavingfrontend/components/category_list/category_selection.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/navigate_between_sheet.dart';

void showTransactionFormA(BuildContext context, bool isIncome,
    {bool isFromGroupDetail = false}) {
  final formService = Provider.of<FormStateProvider>(context, listen: false);
  final formType = isIncome ? FormStateType.income : FormStateType.expense;
  final formFields = formService.getFormField(formType);
  // only create template form if the form is empty
  if (formFields.isEmpty || isFromGroupDetail) {
    formService.updateWholeForm({
      "description": "Note My ${isIncome ? 'Income' : 'Expense'}",
      "payBy": "No record",
    }, formType);
  }
  // because this sheet open from another sheet -> we need to pop the current sheet
  showStyledBottomSheet(
      context: context,
      title: 'Add new ${isIncome ? 'income' : 'expense'}',
      subTitle: 'Choose category',
      contentWidget: CategorySelectionPage(
        type: isIncome ? FormStateType.income : FormStateType.expense,
        onNavigateToNext: () => navigateSheetToSheet(
          context,
          () => showTransactionFormB(context, isIncome,
              isFromGroupDetail: isFromGroupDetail),
        ),
      )
      // onNavigateToNextSheet: () => showSecondBottomSheet(context),
      );
}

void showTransactionFormB(BuildContext context, bool isIncome,
    {bool isFromGroupDetail = false}) {
  showStyledBottomSheet(
      context: context,
      title: 'Add new ${isIncome ? 'income' : 'expense'}',
      // contentWidget: Text("PageB "),
      contentWidget: TransactionFormMain(
          type: isIncome ? FormStateType.income : FormStateType.expense,
          isFromGroupDetail: isFromGroupDetail),
      onNavigateToPreviousSheet: () => navigateSheetToSheet(
            context,
            () => showTransactionFormA(context, isIncome),
          )
      // onNavigateToNextSheet: () => showSecondBottomSheet(context),
      );
}
