import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/bottom_sheet.dart';
// import 'package:tymesavingfrontend/components/multiple_page_sheet/common/add_amount_calculator.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/common/add_transaction_form_main.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/common/transaction_selection_sheet.dart';
import 'package:tymesavingfrontend/utils/navigate_between_sheet.dart';

void showTransactionFormA(BuildContext context, bool isIncome) {
  // because this sheet open from another sheet -> we need to pop the current sheet
  showStyledBottomSheet(
      context: context,
      title: 'Add new income',
      subTitle: 'Choose category',
      contentWidget: TransactionCategorySelectionPage(
        type: isIncome ? FormStateType.income : FormStateType.expense,
        onNavigateToNext: () => navigateSheetToSheet(context,
          () => showTransactionFormB(context, isIncome),
        ),
      )
      // onNavigateToNextSheet: () => showSecondBottomSheet(context),
      );
}

void showTransactionFormB(BuildContext context, bool isIncome) {
  showStyledBottomSheet(
      context: context,
      title: 'Add new income',
      // contentWidget: Text("PageB "),
      contentWidget: AddTransactionFormMain(
        type: isIncome ? FormStateType.income : FormStateType.expense,
      ),
      onNavigateToPreviousSheet: () => navigateSheetToSheet(context,
            () => showTransactionFormA(context, isIncome),
          )
      // onNavigateToNextSheet: () => showSecondBottomSheet(context),
      );
}
