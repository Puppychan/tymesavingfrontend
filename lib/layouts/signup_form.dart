import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/screens/sign_in_page.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _trySubmit() {
    // Manually trigger validation and show errors in toast if any field is not valid
    final String? validateMessageUsername =
        Validator.validateUsername(_usernameController.text);
    if (validateMessageUsername != null) {
      ErrorDisplay.showErrorToast(validateMessageUsername, context);
      return;
    }

    final String? validateMessageEmail =
        Validator.validateEmail(_mailController.text);
    if (validateMessageEmail != null) {
      ErrorDisplay.showErrorToast(validateMessageEmail, context);
      return;
    }

    final String? validateMessagePhone =
        Validator.validatePhone(_phoneController.text);
    if (validateMessagePhone != null) {
      ErrorDisplay.showErrorToast(validateMessagePhone, context);
      return;
    }

    final String? validateMessageFullname =
        Validator.validateFullName(_fullnameController.text);
    if (validateMessageFullname != null) {
      ErrorDisplay.showErrorToast(validateMessageFullname, context);
      return;
    }

    final String? validateMessagePassword =
        Validator.validatePassword(_passwordController.text);
    if (validateMessagePassword != null) {
      ErrorDisplay.showErrorToast(validateMessagePassword, context);
      return;
    }

    final String? validateMessageConfirmPassword =
        Validator.validateConfirmPassword(_passwordController.text, _confirmPasswordController.text);
    if (validateMessageConfirmPassword != null) {
      ErrorDisplay.showErrorToast(validateMessageConfirmPassword, context);
      return;
    }
    // if all valid
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInView(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoundTextField(
            label: "Username",
            controller: _usernameController,
            placeholder: 'Enter your username',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Email",
            controller: _mailController,
            placeholder: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Your phone number",
            controller: _phoneController,
            placeholder: '+123456789',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Your full name",
            controller: _fullnameController,
            placeholder: 'John Doe',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Password",
            placeholder: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            isPasswordField: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Confirm Password",
            placeholder: 'Enter your provided password',
            controller: _confirmPasswordController,
            obscureText: true,
            isPasswordField: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          // Submit section
          const SizedBox(height: 20),
          PrimaryButton(
            title: "Register",
            onPressed: _trySubmit,
          ),
        ],
      ),
    );
  }
}
