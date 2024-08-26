import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/momo/momo_transaction_form.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';

void showMomoOption(BuildContext context) {
  FormStateType formStateType = FormStateType.income;
  showStyledBottomSheet(
    context: context,
    title: 'Momo Option',
    subTitle: 'Choose option for Momo',
    contentWidget: Column(
      children: [
        RadioField(
            label: "Top Up or Withdraw",
            options: [FormStateType.income.value, FormStateType.expense.value],
            onSelected: (String stringChosenResult) {
              formStateType = FormStateType.fromString(stringChosenResult);
            },
            defaultOption: formStateType.value),
        const SizedBox(height: 20),
        PrimaryButton(
          title: 'Continue',
          onPressed: () {
            showMomoTransaction(context, formStateType);
          },
        ),
      ],
    ),
  );
}

void showMomoTransaction(BuildContext context, FormStateType formType) {
  final formStateService =
      Provider.of<FormStateProvider>(context, listen: false);
  formStateService.resetForm(formType);
  final selectedCategory = TransactionCategory.incomeCategories[0];
  formStateService.updateFormCategory(selectedCategory, formType);
  formStateService.updateWholeForm({
    "description": formType == FormStateType.income ? "Topup Wallet" : "Withdraw Wallet",
    "payBy": "Momo",
    "groupType": null,
    "budgetGroupId": null,
    "savingGroupId": null,
    "type": formType,
  }, formType);

  showStyledBottomSheet(
    context: context,
    title: 'Momo Topup Form',
    subTitle: 'Choose category',
    contentWidget: MomoTransactionForm(
      formType: formType,
    ),
  );
}