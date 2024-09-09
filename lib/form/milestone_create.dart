import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/input/round_text_field.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/amount_multi_form.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/dismiss_keyboard.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class MileStoneCreatePage extends StatefulWidget {
  const MileStoneCreatePage({super.key, required this.challengeId});
  final String challengeId;
  @override
  State<MileStoneCreatePage> createState() => _MileStoneCreatePageState();
}

class _MileStoneCreatePageState extends State<MileStoneCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _prizeValue = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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

  Future<void> _trySubmit () async {
    final challengeService = Provider.of<ChallengeService>(context, listen: false);
    context.loaderOverlay.show();
    await handleMainPageApi(context, () async {
      final result = await challengeService.createMileStone(
        widget.challengeId,
        _nameController.text,
        _amountController.text,
        _startDateController.text,
        _endDateController.text,
        int.parse(_prizeValue.text),
        );
      return result;
    }, () async {
      context.loaderOverlay.hide();
      Navigator.pop(context);
    });
  }
  
  String? validatePoint(String? value) {
    if (value == null || value.isEmpty) {
      return 'Point cannot be empty';
    }

    final int? intValue = int.tryParse(value);

    if (intValue == null) {
      return 'Please enter a valid integer';
    } else if (intValue < 0) {
      return 'Point cannot be negative';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // dismiss keyboard
        dismissKeyboardAndAct(context);
      },
      child: Scaffold(
        appBar: const Heading(title: "Create Milestone", showBackButton: true,),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    RoundTextField(
                      label: 'Name',
                      placeholder: "Milestone name",
                      controller: _nameController,
                      validator: Validator.validateTitle,
                    ),
                    const SizedBox(height: 10),
                    AmountMultiForm(amountController: _amountController, updateOnChange: () {}),
                    UnderlineTextField(
                      icon: Icons.star_border_outlined,
                      label: "Point received",
                      controller: _prizeValue,
                      placeholder: 'Larger or equal to 0',
                      keyboardType: TextInputType.number,
                      validator: validatePoint),
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        hintText: 'Select the start date',
                      ),
                      onTap: () => _selectDate(context, _startDateController),
                    ),
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        hintText: 'Select the end date',
                      ),
                      onTap: () => _selectDate(context, _endDateController),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _trySubmit();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}