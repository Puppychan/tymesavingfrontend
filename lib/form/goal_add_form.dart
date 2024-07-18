import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/form/common_form/goal_form.dart';
// import 'package:tymesavingfrontend/components/multiple_page_sheet/common/add_amount_calculator.dart';

void showGroupSavingFormA(BuildContext context) {
  // because this sheet open from another sheet -> we need to pop the current sheet
  showStyledBottomSheet(
    context: context,
    title: 'New GroupSaving Group',
    subTitle: 'Define your goal group',
    contentWidget: const GroupSavingFormMain(
      type: FormStateType.saving,
    ),
    // onNavigateToNextSheet: () => showSecondBottomSheet(context),
  );
}

// void showTransactionFormB(BuildContext context, bool isIncome) {
//   showStyledBottomSheet(
//       context: context,
//       title: 'Add new ${isIncome ? 'income' : 'expense'}',
//       // contentWidget: Text("PageB "),
//       contentWidget: TransactionFormMain(
//         type: isIncome ? FormStateType.income : FormStateType.expense,
//       ),
//       onNavigateToPreviousSheet: () => navigateSheetToSheet(context,
//             () => showTransactionFormA(context, isIncome),
//           )
//       // onNavigateToNextSheet: () => showSecondBottomSheet(context),
//       );
// }
