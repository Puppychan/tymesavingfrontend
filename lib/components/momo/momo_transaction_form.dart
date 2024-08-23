import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_type_enum.dart';
import 'package:tymesavingfrontend/components/category_list/category_selection.dart';
import 'package:tymesavingfrontend/components/category_list/category_short_selection.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/comonent_multi_form.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/screens/momo_payment_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/momo_payment_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

const defaultMomoFormType = FormStateType.income;

class MomoTransactionForm extends StatefulWidget {
  const MomoTransactionForm({super.key});

  @override
  State<MomoTransactionForm> createState() => _MomoTransactionFormState();
}

class _MomoTransactionFormState extends State<MomoTransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void updateOnChange(String type, {dynamic value}) {
    if (!mounted) return;
    final formStateService =
        Provider.of<FormStateProvider>(context, listen: false);
    switch (type) {
      case "amount":
        formStateService.updateFormField(
            "amount", _amountController.text, defaultMomoFormType);
        break;
      case "description":
        formStateService.updateFormField(
            "description", _descriptionController.text, defaultMomoFormType);
        break;
      // case "date":
      //   final formattedDateTime =
      //       combineDateAndTime(_selectedDate, _selectedTime);
      //   formStateService.updateFormField(
      //       "createdDate", formattedDateTime ?? "", defaultMomoFormType);
      //   break;
      // case "groupType":
      //   formStateService.updateFormField("groupType", value, defaultMomoFormType);
      //   break;
      default:
        formStateService.updateFormField(type, value, defaultMomoFormType);
        break;
    }
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate();

    if (isValid == null || !isValid) {
      final String? validateTotalAmount =
          Validator.validateAmount(_amountController.text);
      if (validateTotalAmount != null) {
        ErrorDisplay.showErrorToast(validateTotalAmount, context);
        return;
      }

      final String? validateDescription =
          Validator.validateTransactionDescription(_descriptionController.text);
      if (validateDescription != null) {
        ErrorDisplay.showErrorToast(validateDescription, context);
        return;
      }
    }

    updateOnChange("amount");
    updateOnChange("description");

    // render necessary data
    final formField = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(defaultMomoFormType);
    final user = Provider.of<AuthService>(context, listen: false).user;
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        // return null

        context.loaderOverlay.show();
        return await Provider.of<TransactionService>(context, listen: false)
            .createTransaction(
          user?.id ?? "",
          formField['createdDate'] ?? "",
          formField['description'] ?? "",
          defaultMomoFormType,
          formField['amount'],
          formField['payBy'] ?? "",
          formField['category'],
          (formField['transactionImages'] ?? []).whereType<String>().toList(),
          savingGroupId: formField['savingGroupId'],
          budgetGroupId: formField['budgetGroupId'],
          approveStatus: formField['defaultApproveStatus'],
        );
      }, () async {
        dynamic momoResponse;
        await handleMainPageApi(context, () async {
          momoResponse = await MomoPaymentService.initiateMoMoPayment(
              Provider.of<TransactionService>(context, listen: false)
                      .detailedTransaction
                      ?.id ??
                  "");
          return momoResponse;
        }, () async {
          debugPrint("Success payment response: $momoResponse");
          Provider.of<FormStateProvider>(context, listen: false)
              .resetForm(defaultMomoFormType);
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MoMoPaymentPage(
                    paymentUrl: momoResponse['response']['payUrl'],
                    deeplink: momoResponse['response']['deeplink'],
                  )));
          context.loaderOverlay.hide();

          
          SuccessDisplay.showSuccessToast(
              "Create new $defaultMomoFormType successfully", context);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<FormStateProvider>(builder: (context, value, child) {
      final formStateService = Provider.of<FormStateProvider>(context);
      final TransactionCategory selectedCategory =
          formStateService.getCategory(defaultMomoFormType);
      Map<String, dynamic> formFields =
          formStateService.getFormField(defaultMomoFormType);
      String formattedAmount =
          formStateService.getFormattedAmount(defaultMomoFormType);

      _amountController.text =
          formStateService.getFormattedAmount(defaultMomoFormType);
      _descriptionController.text = formFields['description'] ?? "";

      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 1.5),
                  ),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                ),
                onPressed: () {
                  showStyledBottomSheet(
                      context: context,
                      title: "Category Selection",
                      contentWidget: CategorySelectionPage(
                          type: defaultMomoFormType,
                          onNavigateToNext: () => Navigator.pop(context)));
                },
                child: Text(
                  "Category Details",
                  style: textTheme.titleSmall,
                )),
            ...buildComponentGroup(
                context: context,
                label: "CHOOSE CATEGORY",
                contentWidget: CategoryShortSelection(
                    type: defaultMomoFormType,
                    selectedCategory: selectedCategory)),
            AmountMultiForm(
                formattedAmount: formattedAmount,
                updateOnChange: updateOnChange,
                amountController: _amountController),
            UnderlineTextField(
              label: 'DESCRIPTION',
              controller: _descriptionController,
              icon: Icons.description,
              placeholder: "Please add description",
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              onChange: (value) => updateOnChange("description"),
            ),
            const SizedBox(height: 30),
            PrimaryButton(title: "Add", onPressed: _trySubmit)
          ],
        ),
      );
    });
  }
}
