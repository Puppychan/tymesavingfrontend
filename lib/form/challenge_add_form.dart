import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/input/round_text_field.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_details.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class ChallengeAddForm extends StatefulWidget {
  const ChallengeAddForm({super.key, required this.groupId, required this.category, required this.scope});

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
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String _createdChallengeId = '';

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
    await handleAuthApi(context, () async {
      final result = await challengeService.createChallenge(
        _nameController.text, 
        _descriptionController.text, 
        widget.category, 
        widget.scope, 
        widget.groupId, 
        _startDateController.text,
        _endDateController.text,
        );
      return result;
    }, () async {
      _createdChallengeId = challengeService.challengeModel!.id;
      context.loaderOverlay.hide();
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChallengeDetails(challengeId: _createdChallengeId, isForListing: false,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create A Challenge',)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  RoundTextField(
                    label: 'Name',
                    placeholder: "Challenge name",
                    controller: _nameController,
                    validator: Validator.validateTitle,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: null,  
                    minLines: 5,     
                    keyboardType: TextInputType.multiline,  
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Description of your challenge goes here',
                      labelStyle: Theme.of(context).textTheme.bodyMedium,  
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      border: const OutlineInputBorder(),  
                      alignLabelWithHint: true,  
                    ),
                    onChanged: (value) {
                      // Handle changes to the text input
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
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
    );
  }
}




