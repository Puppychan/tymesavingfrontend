import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/category_list/category_icon.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/assign_group_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/comonent_multi_form.dart';
import 'package:tymesavingfrontend/models/base_group_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class TransactionFormMain extends StatefulWidget {
  final FormStateType type;
  const TransactionFormMain({super.key, required this.type});
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
    print("Result: ${_amountController.text}");
    print(
        "Result: ${_amountController.text} - ${_descriptionController.text} - ${_payByController.text}");
    // If the form is not valid, show an error
    if (isValid == null || !isValid) {
      final String? validateTotalAmount =
          Validator.validateAmount(_amountController.text);
      if (validateTotalAmount != null) {
        ErrorDisplay.showErrorToast(validateTotalAmount, context);
        return;
      }
    }

    // validate saving or budget group
    final formField = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(widget.type);
    TransactionGroupType currentChosenType =
        formField["groupType"] ?? TransactionGroupType.none;
    String? chosenGroupKey = currentChosenType != TransactionGroupType.none
        ? currentChosenType == TransactionGroupType.budget
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
        print("Form field $formField");
        // return null;

        final transactionType = widget.type == FormStateType.updateTransaction
            ? formField['type']
            : widget.type;

        context.loaderOverlay.show();
        if (widget.type == FormStateType.updateTransaction) {
          return await Provider.of<TransactionService>(context, listen: false)
              .updateTransaction(
                  // user?.id ?? "",
                  formField['id'],
                  formField['createdDate'],
                  formField['description'],
                  // transactionType,
                  formField['amount'],
                  formField['payBy'],
                  formField['category']);
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
                  savingGroupId: formField['savingGroupId'],
                  budgetGroupId: formField['budgetGroupId'],
                  );
        }
      }, () async {
        context.loaderOverlay.hide();
        if (!mounted) return;
        Provider.of<FormStateProvider>(context, listen: false).resetForm(
            widget.type);
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

  void onTransactionCategorySelected(TransactionCategory category) {
    Future.microtask(() async {
      if (!mounted) return;
      final formStateService =
          Provider.of<FormStateProvider>(context, listen: false);
      formStateService.updateFormCategory(category, widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      TransactionCategory selectedCategory =
          formStateService.getCategory(widget.type);
      String formDescription =
          formFields['description'] ?? "Please add description";
      String formpayBy = formFields['payBy'] ?? "Pay by cash?";
      TransactionGroupType chosenGroupType =
          formFields['groupType'] ?? TransactionGroupType.none;
      BaseGroup? chosenResult = formFields["tempChosenGroup"];
      String formattedAmount = formStateService.getFormattedAmount(widget.type);

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      // _amountController.text = formFields['amount'].toString() ?? 0;
      _descriptionController.text = formFields['description'] ?? "";
      _payByController.text = formFields['payBy'] ?? "";

      List<Widget> renderCategories(BuildContext context) {
        return TransactionCategory.values
            .where((category) => category != TransactionCategory.all)
            .expand((category) {
          final isSelected = selectedCategory.name == category.name;
          Map<String, dynamic> categoryInfo =
              transactionCategoryData[category]!;
          return [
            Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: colorScheme.tertiary,
                  onTap: () async => {onTransactionCategorySelected(category)},
                  child: getCategoryIcon(
                      currentCategoryInfo: categoryInfo,
                      isSelected: isSelected,
                      colorScheme: colorScheme),
                )),
            const SizedBox(width: 10)
          ];
        }).toList();
      }

      return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildComponentGroup(
                  context: context,
                  label: "CHOOSE CATEGORY",
                  contentWidget: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: renderCategories(context),
                      ))),
              ...buildComponentGroup(
                context: context,
                label: "ASSIGN GROUP",
                contentWidget: AssignGroupMultiForm(
                    updateOnChange: updateOnChange,
                    userId: _user?.id ?? "",
                    // formFields: formFields,
                    chosenResult: chosenResult,
                    chosenGroupType: chosenGroupType,
                    transactionType: widget.type),
              ),
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
                placeholder: formDescription,
                keyboardType: TextInputType.text,
                onChange: (value) => updateOnChange("description"),
              ),
              UnderlineTextField(
                controller: _payByController,
                icon: Icons.payment,
                label: 'PAID BY',
                placeholder: formpayBy,
                keyboardType: TextInputType.text,
                onChange: (value) => updateOnChange("payBy"),
              ),
              PrimaryButton(title: "Add", onPressed: _trySubmit)
            ],
          ));
    });
  }
}
