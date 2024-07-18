import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/category_list/category_icon.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/assign_group_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/comonent_multi_form.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/search_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/input_format_currency.dart';
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
  String _chosenGroupType = TransactionGroupType.none.toString();
  SummaryGroup? _selectedGroup;
  // String _savingOrBudget = 'For None';
  // init state
  @override
  void initState() {
    super.initState();
    final formFields = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(widget.type);
    String? formCreatedDate;
    formCreatedDate = formFields['createdDate'];
    if (formCreatedDate != null) {
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

    updateOnChange("amount");
    updateOnChange("createdDate");
    updateOnChange("description");
    updateOnChange("payBy");
    updateOnChange("groupType");
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        final authService = Provider.of<AuthService>(context, listen: false);
        final formField = Provider.of<FormStateProvider>(context, listen: false)
            .getFormField(widget.type);
        // return null;
        User? user = authService.user;

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
                  user?.id ?? "",
                  formField['createdDate'],
                  formField['description'],
                  transactionType,
                  formField['amount'],
                  formField['payBy'],
                  formField['category']);
        }
      }, () async {
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
        SuccessDisplay.showSuccessToast(
            "Create new ${widget.type} successfully", context);
      });
    });
  }

  void updateOnChange(String type) {
    switch (type) {
      case "amount":
        _onUpdateInputValue("amount", _amountController.text);
        break;
      case "description":
        _onUpdateInputValue("description", _descriptionController.text);
        break;
      case "payBy":
        _onUpdateInputValue("payBy", _payByController.text);
        break;
      case "date":
        final formattedDateTime =
            combineDateAndTime(_selectedDate, _selectedTime);
        _onUpdateInputValue("createdDate", formattedDateTime ?? "");
        break;
      case "groupType":
        _onUpdateInputValue("groupType", _chosenGroupType);
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

  void _onUpdateInputValue(String key, String value) {
    if (!mounted) return;
    final formStateService =
        Provider.of<FormStateProvider>(context, listen: false);
    formStateService.updateFormField(key, value, widget.type);
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
      String chosenGroupType =
          formFields['groupType'] ?? TransactionGroupType.none.toString();
      String formattedAmount = formStateService.getFormattedAmount(widget.type);

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      // _amountController.text = formFields['amount'].toString() ?? 0;
      _descriptionController.text = formFields['description'] ?? "";
      _payByController.text = formFields['payBy'] ?? "";

      List<Widget> renderCategories(BuildContext context) {
        return TransactionCategory.values.expand((category) {
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
              AssignGroupMultiForm(updateOnChange: (field, value) {
                if (field == "groupType") {
                  setState(() {
                    _chosenGroupType = value;
                    updateOnChange("groupType");
                  });
                } 
              }, chosenGroupType: _chosenGroupType, defaultOption: chosenGroupType, transactionType: widget.type),
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

  Future<void> _showInputDialog(
    BuildContext context, {
    required String initialValue,
    required ValueChanged<String> onSubmitted,
  }) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Edit',
                      hintText: 'Enter new value',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSubmitted(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
