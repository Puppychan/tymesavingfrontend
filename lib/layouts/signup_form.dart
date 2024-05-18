import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/screens/sign_in_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
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
  final AuthService _authService = AuthService();
  // bool _isLoading = false;

  Future<void> _trySubmit() async {
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

    // Show loader overlay while waiting for the response
    context.loaderOverlay.show();

    // call api from backend to signup
    try {
      final result = await _authService.signIn(
        _usernameController.text,
        _passwordController.text,
      );
      print("After call api from backend to signin");
      // detect before call navigation
      if (!mounted) return;

      print("From login_form.dart: $result");

      if (result['statusCode'] == 200) {
        // If successful, navigate to HomePage
            // if all valid
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInView(),
          ),
          (_) => false,
        );

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
    } finally {
      // if (!mounted) return;

      context.loaderOverlay.hide();
    }

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
