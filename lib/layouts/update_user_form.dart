import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RoundTextField(
            placeholder: 'test',
            label: 'Full Name',
            controller: _fullNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          RoundTextField(
            placeholder: 'test',
            label: 'Username',
            controller: _usernameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          RoundTextField(
            placeholder: 'test',
            label: 'Phone Number',
            controller: _phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          RoundTextField(
            placeholder: 'test',
            label: 'E-mail',
            controller: _gmailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your Gmail';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            title: 'UPDATE',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Submit form
                _submitForm();
              }
            },
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // Process form submission 
    String fullName = _fullNameController.text;
    String username = _usernameController.text;
    String phone = _phoneController.text;
    String gmail = _gmailController.text;

    /*
    Code for submitting and linkage with back-end to update user information here
    */
  }
}