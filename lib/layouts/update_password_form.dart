import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';

class UpdatePasswordForm extends StatefulWidget {
  const UpdatePasswordForm({super.key});

  @override
  State<UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  /*
    Fetch Password from user and replace here when merge with back-end!
  */
  final  String password = 'password placeholder';

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundTextField(
              placeholder: password,
              label: 'Password',
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            RoundTextField(
              placeholder: password,
              label: 'Re-enter Password',
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Re-enter field can\'t be empty!';
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
        ),
      );
  }

  void _submitForm() {
    // Process form submission 
    String password = _passwordController.text;

    /*
    Code for submitting and linkage with back-end to update user password here
    */
  }
}