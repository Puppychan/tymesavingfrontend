import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/common/category_icon.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class AddTransactionFormMain extends StatefulWidget {
  final FormStateType type;
  const AddTransactionFormMain({super.key, required this.type});
  @override
  State<AddTransactionFormMain> createState() => _AddTransactionFormMainState();
}

class _AddTransactionFormMainState extends State<AddTransactionFormMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _paidByController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  // String _savingOrBudget = 'For None';
  // init state
  @override
  void initState() {
    super.initState();
    final formFields = Provider.of<FormStateProvider>(context, listen: false)
        .getFormField(widget.type);
    String? formCreatedDate = formFields['createdDate'];
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
        "Result: ${_amountController.text} - ${_descriptionController.text} - ${_paidByController.text}");
    // If the form is not valid, show an error
    if (isValid == null || !isValid) {
      final String? validateTotalAmount =
          Validator.validateAmount(_amountController.text);
      if (validateTotalAmount != null) {
        ErrorDisplay.showErrorToast(validateTotalAmount, context);
        return;
      }
    }

    //
    final formattedDateTime = combineDateAndTime(_selectedDate, _selectedTime);
    onUpdateInputValue("amount", _amountController.text);
    onUpdateInputValue("createdDate", formattedDateTime ?? "");
    onUpdateInputValue("description", _descriptionController.text);
    onUpdateInputValue("paidBy", _paidByController.text);
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        final authService = Provider.of<AuthService>(context, listen: false);
        final formField = Provider.of<FormStateProvider>(context, listen: false)
            .getFormField(widget.type);
        // return null;
        User? user = authService.user;
        context.loaderOverlay.show();
        return await Provider.of<TransactionService>(context, listen: false)
            .createTransaction(
                user?.id ?? "",
                formField['createdDate'],
                formField['description'],
                widget.type,
                formField['amount'],
                formField['paidBy'],
                formField['category']);
      }, () async {
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
        SuccessDisplay.showSuccessToast("Create new ${widget.type} successfully", context);
      });
    });
  }

  void updateOnChange(String type) {
    switch(type) {
      case "amount":
        onUpdateInputValue("amount", _amountController.text);
        break;
      case "description":
        onUpdateInputValue("description", _descriptionController.text);
        break;
      case "paidBy":
        onUpdateInputValue("paidBy", _paidByController.text);
        break;
      case "date":
        final formattedDateTime = combineDateAndTime(_selectedDate, _selectedTime);
        onUpdateInputValue("createdDate", formattedDateTime ?? "");
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
    final textTheme = Theme.of(context).textTheme;

    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      TransactionCategory selectedCategory =
          formStateService.getCategory(widget.type);
      String formattedAmount = formStateService.getFormattedAmount(widget.type);
      String formDescription =
          formFields['description'] ?? "Please add description";
      String formPaidBy = formFields['paidBy'] ?? "Pay by cash?";

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      _descriptionController.text = formFields['description'] ?? "";
      _paidByController.text = formFields['paidBy'] ?? "";

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
                  label: "TOTAL AMOUNT",
                  controller: _amountController,
                  icon: Icons.attach_money,
                  placeholder: formattedAmount,
                  keyboardType: TextInputType.number,
                  onChange: (value) =>
                      updateOnChange("amount"),
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
                            convertFormattedToNumber(formattedAmount);
                        return [
                          ChoiceChip(
                            color: MaterialStateProperty.all<Color>(
                                colorScheme.tertiary),
                            label: Text(formatAmount(amount)),
                            selected: selectedAmount == amount,
                            onSelected: (selected) {
                              setState(() {
                                _amountController.text = formatAmount(amount);
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
                onChange: (value) =>
                    updateOnChange("description"),
              ),
              UnderlineTextField(
                controller: _paidByController,
                icon: Icons.payment,
                label: 'PAID BY',
                placeholder: formPaidBy,
                keyboardType: TextInputType.text,
                onChange: (value) =>
                    updateOnChange("paidBy"),
              ),
              // ..._buildComponentGroup(
              //     label: "SAVING OR BUDGET",
              //     contentWidget: [
              //       Column(
              //         children: ['For Saving', 'For Budget', 'For None']
              //             .map((option) {
              //           return RadioListTile(
              //             title: Text(option),
              //             value: option,
              //             groupValue: _savingOrBudget,
              //             onChanged: (value) {
              //               setState(() {
              //                 _savingOrBudget = value!;
              //               });
              //             },
              //           );
              //         }).toList(),
              //       )
              //     ]),
              PrimaryButton(title: "Add", onPressed: _trySubmit)
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
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
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
