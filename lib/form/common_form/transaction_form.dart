import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_form_write_policy_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/category_list/category_short_selection.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/multiline_text_field.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/assign_group_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/comonent_multi_form.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/images_uploading_multi_form.dart';
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
  // for handling update transaction images
  List<String> _initialTransactionImages = [];
  // String _savingOrBudget = 'For None';
  // init state
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    // get form service
    final formService = Provider.of<FormStateProvider>(context, listen: false);
    // get the form fields
    final formFields = formService.getFormField(widget.type);
    print("Form Fields: $formFields");
    // set amount controller
    _amountController.text = formService.getFormattedAmount(widget.type);
    // define for get current user
    final authService = Provider.of<AuthService>(context, listen: false);
    // get default date and time
    String? formCreatedDate;
    formCreatedDate = formFields['createdDate'];
    Map<String, dynamic>? dateTimeMap;
    if (formCreatedDate != null) {
      dateTimeMap = setDateTimeFromTimestamp(formCreatedDate);
    }

    // set state to update local variables
    if (!mounted) return;
    setState(() {
      // get current logged in user
      _user = authService.user;
      // set field transaction images
      _initialTransactionImages =
          (formFields['transactionImages'] ?? []).whereType<String>().toList();

      // set date and time if available
      if (dateTimeMap != null) {
        _selectedDate = dateTimeMap['date'];
        _selectedTime = dateTimeMap['time'];
      }
    });
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
          // only update transaction images if there is a change
          // compare the initial images with the current images
          List<String> currentImages = (formField['transactionImages'] ?? [])
              .whereType<String>()
              .toList();
          // Function to check if lists contain the same elements in any order
          bool areListsEqual(List list1, List list2) {
            // Normalize the lists by trimming whitespace and sorting them
            final normalizedList1 = list1.map((url) => url.trim()).toSet();
            final normalizedList2 = list2.map((url) => url.trim()).toSet();

            // Compare the lists based on their length and contents
            return normalizedList1.length == normalizedList2.length &&
                normalizedList1.containsAll(normalizedList2);
          }
          // if old list = new list, no need to update images

          // Use the function to compare initial and current images
          bool isUpdateImage =
              !areListsEqual(_initialTransactionImages, currentImages);

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
            transactionImages: isUpdateImage ? currentImages : null,
            isUpdateImage: isUpdateImage,
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
      // check if the transaction belongs to a group by checking the group id
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

  // update - personal, update image - group, create - all

  @override
  Widget build(BuildContext context) {
    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      TransactionCategory selectedCategory =
          formStateService.getCategory(widget.type);
      TransactionGroupType chosenGroupType = getGroupType(formFields);
      // String formattedAmount = formStateService.getFormattedAmount(widget.type);
      List<String> transactionImages =
          (formFields['transactionImages'] ?? []).whereType<String>().toList();
      bool isFromGroup = widget.isFromGroupDetail == true ||
          (formFields['budgetGroupId'] != null &&
              formFields['budgetGroupId'] != "") ||
          (formFields['savingGroupId'] != null &&
              formFields['savingGroupId'] != "");
      String? groupId =
          formFields['budgetGroupId'] ?? formFields['savingGroupId'];
      TransactionFormWritePolicy writePermission = renderWritePermission(
          widget.type, widget.isFromGroupDetail, isFromGroup);
      bool isEditableOtherFields = [
        TransactionFormWritePolicy.createForm,
        TransactionFormWritePolicy.createFormFromGroup,
        TransactionFormWritePolicy.updateForm
      ].contains(writePermission);

      // update text to controller
      // _amountController.text = formattedAmount;
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
                    selectedCategory: selectedCategory,
                  )),
              if (writePermission != TransactionFormWritePolicy.updateForm)
                // if in update form for personal transaction, do not allow to change group
                ...buildComponentGroup(
                    context: context,
                    label: "ASSIGN TO",
                    contentWidget: AssignGroupMultiForm(
                        updateOnChange: updateOnChange,
                        userId: _user?.id ?? "",
                        // formFields: formFields,
                        // chosenResult: chosenResult,
                        writePolicy: writePermission,
                        groupId: groupId,
                        chosenGroupType: chosenGroupType,
                        transactionType: widget.type)),
              AmountMultiForm(
                  updateOnChange: updateOnChange,
                  isEditable:
                      isEditableOtherFields, // only allow to edit amount if user has permission
                  amountController: _amountController),
              UnderlineTextField(
                icon: Icons.calendar_today,
                label: 'DATE',
                placeholder: convertDateTimeToReadableString(_selectedDate),
                readOnly: true,
                suffixIcon: isEditableOtherFields ? Icons.edit : null,
                onTap: () async {
                  if (!isEditableOtherFields) return;
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
                suffixIcon: isEditableOtherFields ? Icons.edit : null,
                onTap: () async {
                  if (!isEditableOtherFields) return;
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
              MultilineTextField(
                label: 'DESCRIPTION',
                readOnly: !isEditableOtherFields,
                controller: _descriptionController,
                placeholder: "Please add description",
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                onChange: (value) => updateOnChange("description"),
              ),
              UnderlineTextField(
                controller: _payByController,
                icon: Icons.payment,
                label: 'PAID BY',
                readOnly: !isEditableOtherFields,
                placeholder: "Pay by cash?",
                keyboardType: TextInputType.text,
                onChange: (value) => updateOnChange("payBy"),
              ),
              ImagesUploadingMultiForm(
                images: transactionImages,
                isEditable: isEditableOtherFields,
                formType: widget.type,
              ),
              const SizedBox(height: 30),
              isEditableOtherFields
                  ? PrimaryButton(title: "Add", onPressed: _trySubmit)
                  : const SizedBox(),
            ],
          ));
    });
  }
}
