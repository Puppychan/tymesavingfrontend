import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/momo/momo_transaction_form.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';

const defaultMomoFormType = FormStateType.income;

void showMomoTransaction(BuildContext context) {
  // TODO: first assume to be income -> change later
  final formStateService =
      Provider.of<FormStateProvider>(context, listen: false);
  formStateService.resetForm(defaultMomoFormType);
  final selectedCategory = TransactionCategory.incomeCategories[0];
  formStateService.updateFormCategory(selectedCategory, defaultMomoFormType);
  formStateService.updateWholeForm({
    "description": "Topup Wallet",
    "payBy": "Momo",
    "groupType": null,
    "budgetGroupId": null,
    "savingGroupId": null,
  }, defaultMomoFormType);

  showStyledBottomSheet(
    context: context,
    title: 'Momo Topup Form',
    subTitle: 'Choose category',
    contentWidget: const MomoTransactionForm(),
  );
}


// class MomoTransactionSheet extends StatefulWidget {
//   @override
//   _MomoTransactionSheetState createState() => _MomoTransactionSheetState();
// }

// class _MomoTransactionSheetState extends State<MomoTransactionSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // Add your widget code here
//     );
//   }
// }