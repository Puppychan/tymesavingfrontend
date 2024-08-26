import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/category_list/category_selection.dart';
import 'package:tymesavingfrontend/components/category_list/category_short_selection.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/input/multiline_text_field.dart';
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

class MomoTransactionForm extends StatefulWidget {
  final FormStateType formType;
  const MomoTransactionForm({super.key, required this.formType});

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
            "amount", _amountController.text, widget.formType);
        break;
      case "description":
        formStateService.updateFormField(
            "description", _descriptionController.text, widget.formType);
        break;
      // case "date":
      //   final formattedDateTime =
      //       combineDateAndTime(_selectedDate, _selectedTime);
      //   formStateService.updateFormField(
      //       "createdDate", formattedDateTime ?? "", widget.formType);
      //   break;
      // case "groupType":
      //   formStateService.updateFormField("groupType", value, widget.formType);
      //   break;
      default:
        formStateService.updateFormField(type, value, widget.formType);
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
        .getFormField(widget.formType);
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
          widget.formType,
          formField['amount'],
          formField['payBy'] ?? "",
          formField['category'],
          (formField['transactionImages'] ?? []).whereType<String>().toList(),
          savingGroupId: formField['savingGroupId'],
          budgetGroupId: formField['budgetGroupId'],
          approveStatus: formField['defaultApproveStatus'],
          isMomo: true,
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
              .resetForm(widget.formType);
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MoMoPaymentPage(
                    paymentUrl: momoResponse['response']['payUrl'],
                    transactionId: momoResponse['response']['orderId'],
                  )));
          context.loaderOverlay.hide();

          
          SuccessDisplay.showSuccessToast(
              "Create new $widget.formType successfully", context);
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
          formStateService.getCategory(widget.formType);
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.formType);
      String formattedAmount =
          formStateService.getFormattedAmount(widget.formType);

      _amountController.text =
          formStateService.getFormattedAmount(widget.formType);
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
                          type: widget.formType,
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
                    type: widget.formType,
                    selectedCategory: selectedCategory)),
            AmountMultiForm(
                formattedAmount: formattedAmount,
                updateOnChange: updateOnChange,
                amountController: _amountController),
            MultilineTextField(
              label: 'DESCRIPTION',
              controller: _descriptionController,
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
