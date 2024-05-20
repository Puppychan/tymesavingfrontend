import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/screens/HomePage.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
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

  Future<void> _trySubmit() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final String? validateMessageUsername =
          Validator.validateUsername(_usernameController.text);
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

      // Show loader overlay while waiting for the response
      context.loaderOverlay.show();

      // call api from backend to signin
      try {
        final result = await authService.signIn(
          _usernameController.text,
          _passwordController.text,
        );

        // detect before call navigation
        if (!mounted) return;

        if (result['statusCode'] == 200) {
          context.loaderOverlay.hide();
          // If successful, navigate to HomePage
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(title: 'Home'),
              ),
              (_) => false);
        } else if (result['statusCode'] == 401) {
          // Display error message
          ErrorDisplay.showErrorToast(
              "Invalid username or password. Please try again.", context);
        } else {
          ErrorDisplay.navigateToErrorPage(result, context);
        }
      } catch (e) {
        if (!mounted) return;

        // Display error message
        ErrorDisplay.navigateToErrorPage({'response': e.toString()}, context);
      }

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
            keyboardType: TextInputType.text,
            // validator: Validator
            //     .validateEmail, // only if want to validate email under the text field
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Password",
            placeholder: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            isPasswordField: true,
            keyboardType: TextInputType.visiblePassword,
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
