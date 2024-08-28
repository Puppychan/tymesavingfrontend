import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/dialog/date_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/dialog/time_picker_dialog.dart';
import 'package:tymesavingfrontend/components/common/input/multiline_text_field.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_details.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/format_date.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class ChallengeAddForm extends StatefulWidget {
  const ChallengeAddForm(
      {super.key,
      required this.groupId,
      required this.category,
      required this.scope});

  final String groupId;
  final String category;
  final String scope;

  @override
  State<ChallengeAddForm> createState() => _ChallengeAddFormState();
}

class _ChallengeAddFormState extends State<ChallengeAddForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // final _startDateController = TextEditingController();
  // final _endDateController = TextEditingController();
  String _createdChallengeId = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _trySubmit() async {
    // custom validation

    final String? formattedStartDateTime =
        combineDateAndTime(_selectedDate, _selectedTime);
    final String? formattedEndDateTime =
        combineDateAndTime(_selectedEndDate, _selectedEndTime);

    if (formattedStartDateTime == null || formattedEndDateTime == null) {
      ErrorDisplay.showErrorToast('Invalid date or time', context);
      return;
    }

    // Parse the combined date and time strings back to DateTime objects
    final DateTime startDateTime = DateTime.parse(formattedStartDateTime);
    final DateTime endDateTime = DateTime.parse(formattedEndDateTime);

    // Custom validation
    if (endDateTime.isBefore(startDateTime)) {
      ErrorDisplay.showErrorToast('End time cannot be before start time', context);
      return;
    }

    // Call the API to create the challenge
    final challengeService =
        Provider.of<ChallengeService>(context, listen: false);
    context.loaderOverlay.show();
    await handleMainPageApi(context, () async {
      final result = await challengeService.createChallenge(
        _nameController.text,
        _descriptionController.text,
        widget.category,
        widget.scope,
        widget.groupId,
        formattedStartDateTime,
        formattedEndDateTime,
        // _startDateController.text,
        // _endDateController.text,
      );
      return result;
    }, () async {
      _createdChallengeId = challengeService.challengeModel!.id;
      context.loaderOverlay.hide();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChallengeDetails(
                    challengeId: _createdChallengeId,
                    isForListing: false,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Create A Challenge',
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  UnderlineTextField(
                    controller: _nameController,
                    icon: FontAwesomeIcons.fileSignature,
                    label: 'CHALLENGE NAME',
                    placeholder: 'Enter challenge name',
                    keyboardType: TextInputType.text,
                    validator: Validator.validateTitle,
                    // onChange: (value) => updateOnChange("description"),
                  ),
                  const SizedBox(height: 10),
                  MultilineTextField(
                    controller: _descriptionController,
                    // icon: FontAwesomeIcons.fileSignature,
                    label: 'CHALLENGE DESCRIPTION',
                    placeholder: 'Description of your challenge goes here',
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: null,
                    validator: Validator.validateChallengeDescription,
                    // onChange: (value) => updateOnChange("description"),
                  ),
                  const SizedBox(height: 10),
                  ..._buildDateTimeComponents(context, isStartDate: true),
                  const SizedBox(height: 30),
                  ..._buildDateTimeComponents(context, isStartDate: false),
                  // TextFormField(
                  //   controller: _startDateController,
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Start Date',
                  //     hintText: 'Select the start date',
                  //   ),
                  //   onTap: () => _selectDate(context, _startDateController),
                  // ),
                  // TextFormField(
                  //   controller: _endDateController,
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     labelText: 'End Date',
                  //     hintText: 'Select the end date',
                  //   ),
                  //   onTap: () => _selectDate(context, _endDateController),
                  // ),
                  const SizedBox(height: 20),
                  PrimaryButton(title: "Confirm", onPressed: _trySubmit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDateTimeComponents(BuildContext context,
      {bool isStartDate = true}) {
    final String label = isStartDate ? 'START' : 'END';
    final IconData dateIcon = isStartDate
        ? FontAwesomeIcons.calendarPlus
        : FontAwesomeIcons.calendarXmark;
    final IconData timeIcon = isStartDate
        ? FontAwesomeIcons.hourglassStart
        : FontAwesomeIcons.stopwatch;
    final String helpText = isStartDate
        ? 'Select the start date of the challenge'
        : 'Select the end date of the challenge';

    return [
      UnderlineTextField(
        icon: dateIcon,
        label: '$label DATE',
        placeholder: convertDateTimeToReadableString(
            isStartDate ? _selectedDate : _selectedEndDate),
        readOnly: true,
        suffixIcon: Icons.edit,
        onTap: () async {
          DateTime? pickedDate = await showCustomDatePickerDialog(
              context: context,
              initialDate: isStartDate ? _selectedDate : _selectedEndDate,
              helpText: helpText);
          if (pickedDate != null) {
            setState(() {
              if (isStartDate) {
                _selectedDate = pickedDate;
              } else {
                _selectedEndDate = pickedDate;
              }
              // updateOnChange("date");
            });
          }
        },
      ),
      UnderlineTextField(
        icon: timeIcon,
        label: '$label TIME',
        placeholder: convertTimeDayToReadableString(
            context, isStartDate ? _selectedTime : _selectedEndTime),
        readOnly: true,
        suffixIcon: Icons.edit,
        onTap: () async {
          // Show the time picker dialog
          final TimeOfDay? pickedTime = await showCustomTimePickerDialog(
            context: context, // Make sure you have a BuildContext available
            initialTime: isStartDate ? _selectedTime : _selectedEndTime,
          );

          // Check if a time was picked
          if (pickedTime != null) {
            setState(() {
              if (isStartDate) {
                _selectedTime = pickedTime;
              } else {
                _selectedEndTime = pickedTime;
              }
              // updateOnChange("date");
            });
          }
        },
      ),
    ];
  }
}
