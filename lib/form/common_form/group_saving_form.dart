import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/approve_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class GroupSavingFormMain extends StatefulWidget {
  final FormStateType type;
  const GroupSavingFormMain({super.key, required this.type});
  @override
  State<GroupSavingFormMain> createState() => _GroupSavingFormMainState();
}

class _GroupSavingFormMainState extends State<GroupSavingFormMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  // String _savingOrGroupSaving = 'For None';
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
        if (widget.type == FormStateType.updateGroupSaving) {
          return await Provider.of<GroupSavingService>(context, listen: false)
              .updateGroupSavingGroup(
            formField['id'],
            user?.id ?? "",
            formField["defaultApproveStatus"] ?? ApproveStatus.approved,
            formField['name'],
            formField['description'] ?? "",
            formField['amount'],
            formField['endDate'],
          );
        } else {
          return await Provider.of<GroupSavingService>(context, listen: false)
              .addGroupSavingGroup(
            user?.id ?? "",
            formField["defaultApproveStatus"] ?? ApproveStatus.approved,
            formField['name'],
            formField['description'] ?? "",
            formField['amount'],
            0.0,
            formField['endDate'],
          );
        }
      }, () async {
        context.loaderOverlay.hide();
        Provider.of<FormStateProvider>(context, listen: false)
            .resetForm(widget.type);
        if (widget.type == FormStateType.updateGroupSaving) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainPageLayout(
                    customPageIndex: PageLocation.savingPage.index),
              ),
              (route) => false);
        }
        SuccessDisplay.showSuccessToast(
            "${widget.type == FormStateType.updateGroupSaving ? "Update" : "Create"} new ${widget.type} successfully",
            context);
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
      case "defaultApproveStatus":
        formStateService.updateFormField(
            "defaultApproveStatus", value, widget.type);
        break;
    }
  }

  // void onTransactionCategorySelected(TransactionCategory category) {
  //   Future.microtask(() async {
  //     if (!mounted) return;
  //     final formStateService =
  //         Provider.of<FormStateProvider>(context, listen: false);
  //     formStateService.updateFormCategory(category, widget.type);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      // TransactionCategory selectedCategory =
      //     formStateService.getCategory(widget.type);
      String formName = formFields['name'] ?? "Naming group...";
      String formattedAmount = formStateService.getFormattedAmount(widget.type);
      String formDescription =
          formFields['description'] ?? "Please add description";
      ApproveStatus currentApproveStatus =
          formFields['defaultApproveStatus'] ?? ApproveStatus.approved;

      // update text to controller
      _amountController.text = formStateService.getFormattedAmount(widget.type);
      _descriptionController.text = formFields['description'] ?? "";
      _nameController.text = formFields['name'] ?? "";

      // List<Widget> renderCategories(BuildContext context) {
      //   return TransactionCategory.values
      //       .where((category) => category != TransactionCategory.all)
      //       .expand((category) {
      //     final isSelected = selectedCategory.name == category.name;
      //     Map<String, dynamic> categoryInfo =
      //         transactionCategoryData[category]!;
      //     return [
      //       Material(
      //           color: Colors.transparent,
      //           child: InkWell(
      //             borderRadius: BorderRadius.circular(10),
      //             splashColor: colorScheme.tertiary,
      //             onTap: () async => {onTransactionCategorySelected(category)},
      //             child: getCategoryIcon(
      //                 currentCategoryInfo: categoryInfo,
      //                 isSelected: isSelected,
      //                 colorScheme: colorScheme),
      //           )),
      //       const SizedBox(width: 10)
      //     ];
      //   }).toList();
      // }

      return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UnderlineTextField(
                controller: _nameController,
                icon: Icons.card_membership,
                label: 'GROUP NAME',
                placeholder: formName,
                keyboardType: TextInputType.text,
                validator: Validator.validateGroupName,
                onChange: (value) => updateOnChange("name"),
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
              UnderlineTextField(
                label: 'DESCRIPTION',
                controller: _descriptionController,
                icon: Icons.description,
                placeholder: formDescription,
                keyboardType: TextInputType.text,
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
                  defaultOption: ApproveStatus.toInputFormString(currentApproveStatus)),
              const SizedBox(height: 20),
              PrimaryButton(title: "Confirm", onPressed: _trySubmit)
            ],
          ));
    });
  }
}
