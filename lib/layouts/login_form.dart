import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/screens/HomePage.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _trySubmit() {
    // Manually trigger validation and show errors in toast if any field is not valid
    final String? validateMessageUsername =
        Validator.validateEmail(_usernameController.text);
    if (validateMessageUsername != null) {
      ErrorDisplay.showErrorToast(validateMessageUsername, context);
      return;
    }

    final String? validateMessagePassword =
        Validator.validatePassword(_passwordController.text);
    if (validateMessagePassword != null) {
      ErrorDisplay.showErrorToast(validateMessagePassword, context);
      return;
    }
    // if all valid
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(title: 'Home'),
      ),
    );

    // final isValid = _formKey.currentState?.validate();
    // if (isValid != null && isValid) {
    //   // Perform login actions
    //   print(
    //       "Username: ${_usernameController.text}, Password: ${_passwordController.text}");
    //   // You can also navigate or do other actions here
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const HomePage(title: 'Home'),
    //     ),
    //   );
    // } else {}
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
            keyboardType: TextInputType.emailAddress,
            // validator: Validator
            //     .validateEmail, // only if want to validate email under the text field
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Password",
            placeholder: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            // validator: Validator.validatePassword,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            title: "Sign In",
            onPressed: _trySubmit,
          ),
        ],
      ),
    );
  }
}
