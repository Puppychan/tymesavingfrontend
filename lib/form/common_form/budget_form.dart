import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/approve_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/multiline_text_field.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
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

      final String? validateGroupName =
          Validator.validateGroupName(_nameController.text);
      if (validateGroupName != null) {
        ErrorDisplay.showErrorToast(validateGroupName, context);
        return;
      }
    }

    updateOnChange("name");
    updateOnChange("amount");
    updateOnChange("date");
    updateOnChange("description");
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
            formField["defaultApproveStatus"].value ?? ApproveStatus.approved.value,
            formField['name'],
            formField['description'] ?? "",
            formField['amount'],
            formField['endDate'],
          );
        } else {
          return await Provider.of<BudgetService>(context, listen: false)
              .addBudgetGroup(
            user?.id ?? "",
            formField["defaultApproveStatus"].value ?? ApproveStatus.approved.value,
            formField['name'],
            formField['description'] ?? "",
            formField['amount'],
            0.0,
            formField['endDate'],
          );
        }
      }, () async {
        context.loaderOverlay.hide();
        if (widget.type == FormStateType.updateBudget) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainPageLayout(
                    customPageIndex: PageLocation.budgetPage.index),
              ),
              (route) => false);
        }
        Provider.of<FormStateProvider>(context, listen: false)
            .resetForm(widget.type);
        SuccessDisplay.showSuccessToast(
            "${widget.type == FormStateType.updateBudget ? "Update" : "Create"} new ${widget.type} successfully",
            context);
      });
    });
  }

  void updateOnChange(String type, {dynamic value}) {
    if (!mounted) return;
    final formStateService =
        Provider.of<FormStateProvider>(context, listen: false);
    switch (type) {
      case "defaultApproveStatus":
        formStateService.updateFormField(
            "defaultApproveStatus", value, widget.type);
        break;
      case "amount":
        formStateService.updateFormField(
            "amount", _amountController.text, widget.type);
        break;
      case "description":
        formStateService.updateFormField(
            "description", _descriptionController.text, widget.type);
        break;
      case "name":
        formStateService.updateFormField(
            "name", _nameController.text, widget.type);
        break;
      case "date":
        final formattedDateTime =
            combineDateAndTime(_selectedDate, _selectedTime);
        formStateService.updateFormField(
            "endDate", formattedDateTime ?? "", widget.type);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      // TransactionCategory selectedCategory =
      //     formStateService.getCategory(widget.type);
      String formattedAmount = formStateService.getFormattedAmount(widget.type);
      ApproveStatus currentApproveStatus =
          ApproveStatus.fromString(formFields['defaultApproveStatus']) ?? ApproveStatus.approved;

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      _descriptionController.text = formFields['description'] ?? "";
      _nameController.text = formFields['name'] ?? "";

      return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              UnderlineTextField(
                controller: _nameController,
                icon: Icons.card_membership,
                label: 'GROUP NAME',
                placeholder:  "Naming group...",
                keyboardType: TextInputType.text,
                onChange: (value) => updateOnChange("name"),
                validator: Validator.validateGroupName,
              ),
              AmountMultiForm(
                  formattedAmount: formattedAmount,
                  updateOnChange: updateOnChange,
                  amountController: _amountController),
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
              MultilineTextField(
                label: 'DESCRIPTION',
                controller: _descriptionController,
                placeholder: "Please add description",
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                onChange: (value) => updateOnChange("description"),
              ),
              RadioField(
                  label: "Require Approval for Transactions:",
                  options: ApproveStatus.inputFormList,
                  onSelected: (String chosenResponse) {
                    ApproveStatus convertApproveStatus =
                        ApproveStatus.fromInputFormString(chosenResponse);
                    updateOnChange("defaultApproveStatus",
                        value: convertApproveStatus);
                  },
                  defaultOption:
                      ApproveStatus.toInputFormString(currentApproveStatus)),
              const SizedBox(height: 20),
              PrimaryButton(title: "Confirm", onPressed: _trySubmit)
            ],
          ));
    });
  }
}
