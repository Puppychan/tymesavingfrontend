import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/category_list/category_short_selection.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/category_list/category_icon.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/assign_group_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/comonent_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/images_uploading_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/short_group_info_multi_form.dart';
import 'package:tymesavingfrontend/models/base_group_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/momo_payment_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/momo_payment_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class TransactionFormMain extends StatefulWidget {
  final FormStateType type;
  final bool isFromGroupDetail;
  const TransactionFormMain(
      {super.key, required this.type, this.isFromGroupDetail = false});
  @override
  State<TransactionFormMain> createState() => _TransactionFormMainState();
}

class _TransactionFormMainState extends State<TransactionFormMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _payByController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  User? _user;
  // String _savingOrBudget = 'For None';
  // init state
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    // get the form fields
    final formFields = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(widget.type);
    final authService = Provider.of<AuthService>(context, listen: false);
    // get current logged in user
    setState(() {
      _user = authService.user;
    });
    // get default date and time
    String? formCreatedDate;
    formCreatedDate = formFields['createdDate'];
    if (formCreatedDate != null) {
      if (!mounted) return;
      setState(() {
        final Map<String, dynamic> dateTimeMap =
            setDateTimeFromTimestamp(formCreatedDate);
        _selectedDate = dateTimeMap['date'];
        _selectedTime = dateTimeMap['time'];
      });
    }
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate();
    // If the form is not valid, show an error
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

    // validate saving or budget group
    final formField = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(widget.type);
    TransactionGroupType currentChosenType =
        formField["groupType"] ?? TransactionGroupType.none;
    String? chosenGroupKey = (currentChosenType != TransactionGroupType.none)
        ? (currentChosenType == TransactionGroupType.budget)
            ? "budgetGroupId"
            : "savingGroupId"
        : null;
    String? currentChosenGroupId = formField[chosenGroupKey];
    // final validation (custom)
    if (currentChosenType != TransactionGroupType.none &&
        currentChosenGroupId == null) {
      ErrorDisplay.showErrorToast(
          "You must choose a group if this transaction belongs to a group",
          context);
      return;
    }

    updateOnChange("amount");
    updateOnChange("date");
    updateOnChange("description");
    updateOnChange("payBy");
    updateOnChange("groupType", value: currentChosenType);
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        // return null;

        FormStateType transactionType = widget.type;
        if (widget.type == FormStateType.income ||
            widget.type == FormStateType.updateIncome) {
          transactionType = FormStateType.income;
        } else if (widget.type == FormStateType.expense) {
          transactionType = FormStateType.expense;
        }

        context.loaderOverlay.show();
        if (widget.type == FormStateType.updateExpense ||
            widget.type == FormStateType.updateIncome) {
          // TODO: implement update transaction images¸
          return await Provider.of<TransactionService>(context, listen: false)
              .updateTransaction(
            // user?.id ?? "",
            formField['id'],
            formField['createdDate'],
            formField['description'],
            // transactionType,
            formField['amount'],
            formField['payBy'],
            formField['category'],
          );
        } else {
          return await Provider.of<TransactionService>(context, listen: false)
              .createTransaction(
            _user?.id ?? "",
            formField['createdDate'],
            formField['description'] ?? "",
            transactionType,
            formField['amount'],
            formField['payBy'] ?? "",
            formField['category'],
            (formField['transactionImages'] ?? []).whereType<String>().toList(),
            savingGroupId: formField['savingGroupId'],
            budgetGroupId: formField['budgetGroupId'],
            approveStatus: formField['defaultApproveStatus'],
          );
        }
      }, () async {
        context.loaderOverlay.hide();

        if (!mounted) return;
        Provider.of<FormStateProvider>(context, listen: false)
            .resetForm(widget.type);
        Navigator.of(context).pop();
        SuccessDisplay.showSuccessToast(
            "Create new ${widget.type} successfully", context);
      });
    });
  }

  void updateOnChange(String type, {dynamic value}) {
    if (!mounted) return;
    final formStateService =
        Provider.of<FormStateProvider>(context, listen: false);
    switch (type) {
      case "amount":
        formStateService.updateFormField(
            "amount", _amountController.text, widget.type);
        break;
      case "description":
        formStateService.updateFormField(
            "description", _descriptionController.text, widget.type);
        break;
      case "payBy":
        formStateService.updateFormField(
            "payBy", _payByController.text, widget.type);
        break;
      case "date":
        final formattedDateTime =
            combineDateAndTime(_selectedDate, _selectedTime);
        formStateService.updateFormField(
            "createdDate", formattedDateTime ?? "", widget.type);
        break;
      // case "groupType":
      //   formStateService.updateFormField("groupType", value, widget.type);
      //   break;
      default:
        formStateService.updateFormField(type, value, widget.type);
        break;
    }
  }



  TransactionGroupType getGroupType(Map<String, dynamic> formFields) {
    TransactionGroupType? type = formFields['groupType'];
    if (type == null) {
      if (formFields['budgetGroupId'] != null) {
        type = TransactionGroupType.budget;
      } else if (formFields['savingGroupId'] != null) {
        type = TransactionGroupType.savings;
      } else {
        type = TransactionGroupType.none;
      }
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      TransactionCategory selectedCategory =
          formStateService.getCategory(widget.type);
      TransactionGroupType chosenGroupType = getGroupType(formFields);
      BaseGroup? chosenResult = formFields["tempChosenGroup"];
      String formattedAmount = formStateService.getFormattedAmount(widget.type);
      bool isBelongToGroup = chosenGroupType != TransactionGroupType.none &&
          (widget.type == FormStateType.updateExpense ||
              widget.type == FormStateType.updateIncome);
      List<String> transactionImages =
          (formFields['transactionImages'] ?? []).whereType<String>().toList();

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      // _amountController.text = formFields['amount'].toString() ?? 0;
      _descriptionController.text = formFields['description'] ?? "";
      _payByController.text = formFields['payBy'] ?? "";

      return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildComponentGroup(
                  context: context,
                  label: "CHOOSE CATEGORY",
                  contentWidget: CategoryShortSelection(
                      type: widget.type,
                      selectedCategory: selectedCategory,)),
              if (widget.isFromGroupDetail == true) ...[
                ShortGroupInfoMultiForm(
                    chosenGroupType: chosenGroupType,
                    chosenResult: chosenResult),
                const Divider(),
              ] else if (isBelongToGroup == true) ...[
                ShortGroupInfoMultiForm(
                  chosenGroupType: chosenGroupType,
                  defaultGroupId: chosenGroupType == TransactionGroupType.budget
                      ? formFields['budgetGroupId']
                      : formFields['savingGroupId'],
                ),
                const Divider(),
              ] else
                ...buildComponentGroup(
                  context: context,
                  label: "ASSIGN TO",
                  contentWidget: AssignGroupMultiForm(
                      updateOnChange: updateOnChange,
                      userId: _user?.id ?? "",
                      // formFields: formFields,
                      chosenResult: chosenResult,
                      chosenGroupType: chosenGroupType,
                      transactionType: widget.type),
                ),
              if (isBelongToGroup == true) ...[
                const SizedBox(height: 10),
                Text("TOTAL AMOUNT",
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(formattedAmount,
                        style: Theme.of(context).textTheme.bodyLarge)),
                const SizedBox(height: 10),
                const Divider()
              ] else
                AmountMultiForm(
                    formattedAmount: formattedAmount,
                    updateOnChange: updateOnChange,
                    amountController: _amountController),
              UnderlineTextField(
                icon: Icons.calendar_today,
                label: 'DATE',
                placeholder: convertDateTimeToReadableString(_selectedDate),
                readOnly: true,
                suffixIcon: Icons.edit,
                onTap: () async {
                  DateTime? pickedDate = await showCustomDatePickerDialog(
                      context: context,
                      initialDate: _selectedDate,
                      helpText: 'Select Date of Transaction');
                  if (pickedDate != null) {
                    if (!mounted) return;
                    setState(() {
                      _selectedDate = pickedDate;
                      updateOnChange("date");
                    });
                  }
                },
              ),
              UnderlineTextField(
                icon: Icons.hourglass_bottom_rounded,
                label: 'TIME',
                placeholder:
                    convertTimeDayToReadableString(context, _selectedTime),
                readOnly: true,
                suffixIcon: Icons.edit,
                onTap: () async {
                  // Show the time picker dialog
                  final TimeOfDay? pickedTime =
                      await showCustomTimePickerDialog(
                    context:
                        context, // Make sure you have a BuildContext available
                    initialTime: _selectedTime,
                  );

                  // Check if a time was picked
                  if (pickedTime != null) {
                    if (!mounted) return;
                    setState(() {
                      _selectedTime = pickedTime;
                      updateOnChange("date");
                    });
                  }
                },
              ),
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
              UnderlineTextField(
                controller: _payByController,
                icon: Icons.payment,
                label: 'PAID BY',
                placeholder: "Pay by cash?",
                keyboardType: TextInputType.text,
                onChange: (value) => updateOnChange("payBy"),
              ),
              ImagesUploadingMultiForm(
                images: transactionImages,
                formType: widget.type,
              ),
              const SizedBox(height: 30),
              PrimaryButton(title: "Add", onPressed: _trySubmit)
            ],
          ));
    });
  }
}
