import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/category_list/category_icon.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class BudgetFormMain extends StatefulWidget {
  final FormStateType type;
  const BudgetFormMain({super.key, required this.type});
  @override
  State<BudgetFormMain> createState() => _BudgetFormMainState();
}

class _BudgetFormMainState extends State<BudgetFormMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  // String _savingOrBudget = 'For None';
  // init state
  @override
  void initState() {
    super.initState();
    final formFields = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(widget.type);
    String? formCreatedDate;
    formCreatedDate = formFields['endDate'];
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
    // If the form is not valid, show an error
    if (isValid == null || !isValid) {
      final String? validateTotalAmount =
          Validator.validateAmount(_amountController.text);
      if (validateTotalAmount != null) {
        ErrorDisplay.showErrorToast(validateTotalAmount, context);
        return;
      }
    }

    final formattedDateTime = combineDateAndTime(_selectedDate, _selectedTime);
    onUpdateInputValue("name", _nameController.text);
    onUpdateInputValue("amount", _amountController.text);
    onUpdateInputValue("endDate", formattedDateTime ?? "");
    onUpdateInputValue("description", _descriptionController.text);
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        final authService = Provider.of<AuthService>(context, listen: false);
        final formField = Provider.of<FormStateProvider>(context, listen: false)
            .getFormField(widget.type);
        // return null;
        User? user = authService.user;

        context.loaderOverlay.show();
        if (widget.type == FormStateType.updateBudget) {
          return await Provider.of<BudgetService>(context, listen: false)
              .updateBudgetGroup(
            formField['id'],
            user?.id ?? "",
            formField['name'],
            formField['description'],
            formField['amount'],
            formField['endDate'],
          );
        } else {
          return await Provider.of<BudgetService>(context, listen: false)
              .addBudgetGroup(
            user?.id ?? "",
            formField['name'],
            formField['description'],
            formField['amount'],
            0.0,
            formField['endDate'],
          );
        }
      }, () async {
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
        SuccessDisplay.showSuccessToast(
            "${widget.type == FormStateType.updateBudget ? "Update" : "Create"} new ${widget.type} successfully", context);
      });
    });
  }

  void updateOnChange(String type) {
    switch (type) {
      case "amount":
        onUpdateInputValue("amount", _amountController.text);
        break;
      case "description":
        onUpdateInputValue("description", _descriptionController.text);
        break;
      case "name":
        onUpdateInputValue("name", _nameController.text);
        break;
      case "date":
        final formattedDateTime =
            combineDateAndTime(_selectedDate, _selectedTime);
        onUpdateInputValue("endDate", formattedDateTime ?? "");
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

  void onUpdateInputValue(String key, String value) {
    Future.microtask(() async {
      if (!mounted) return;
      final formStateService =
          Provider.of<FormStateProvider>(context, listen: false);
      formStateService.updateFormField(key, value, widget.type);
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
      String formName = formFields['name'] ?? "Naming group...";
      String formattedAmount = formStateService.getFormattedAmount(widget.type);
      String formDescription =
          formFields['description'] ?? "Please add description";

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      _descriptionController.text = formFields['description'] ?? "";
      _nameController.text = formFields['name'] ?? "";

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
              ..._buildComponentGroup(
                  label: "CHOOSE CATEGORY",
                  contentWidget: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: renderCategories(context),
                      ))),
              UnderlineTextField(
                controller: _nameController,
                icon: Icons.card_membership,
                label: 'GROUP NAME',
                placeholder: formName,
                keyboardType: TextInputType.text,
                onChange: (value) => updateOnChange("name"),
              ),
              UnderlineTextField(
                  label: "TOTAL AMOUNT",
                  controller: _amountController,
                  icon: Icons.attach_money,
                  placeholder: formattedAmount,
                  keyboardType: TextInputType.number,
                  onChange: (value) => updateOnChange("amount"),
                  validator: Validator.validateAmount),
              ..._buildComponentGroup(contentWidget: [
                // SizedBox(height: 10),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [50000.0, 100000.0, 500000.0, 1000000.0]
                          .expand((amount) {
                        final selectedAmount =
                            convertFormattedAmountToNumber(formattedAmount);
                        return [
                          ChoiceChip(
                            // color: MaterialStateProperty.all<Color>(
                            //     colorScheme.tertiary),
                            color: MaterialStateColor.resolveWith((states) =>
                                states.contains(MaterialState.selected)
                                    ? colorScheme.primary
                                    : colorScheme.tertiary),
                            label: Text(formatAmountToVnd(amount),
                                style: TextStyle(
                                  color: selectedAmount == amount
                                      ? colorScheme.onPrimary
                                      : colorScheme
                                          .onTertiary, // Change colors as needed
                                )),
                            selected: selectedAmount == amount,
                            onSelected: (selected) {
                              setState(() {
                                _amountController.text = formatAmountToVnd(amount);
                                updateOnChange("amount");
                              });
                            },
                          ),
                          const SizedBox(width: 10)
                        ];
                      }).toList(),
                    ))
              ]),
              UnderlineTextField(
                icon: Icons.calendar_today,
                label: 'END DATE',
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
                label: 'END TIME',
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
              PrimaryButton(title: "Confirm", onPressed: _trySubmit)
            ],
          ));
    });
  }

  List<Widget> _buildComponentGroup(
      {required dynamic contentWidget, String? label}) {
    final textTheme = Theme.of(context).textTheme;
    return [
      if (label != null) Text(label, style: textTheme.titleSmall),
      label != null ? const SizedBox(height: 10) : const SizedBox.shrink(),
      if (contentWidget is List) ...contentWidget else contentWidget,
      const SizedBox(height: 5),
      const Divider(),
      const SizedBox(height: 30),
    ];
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
