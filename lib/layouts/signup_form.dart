import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/round_text_field.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _mailController.dispose();
    _phoneController.dispose();
    _fullnameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _trySubmit() async {
    final authService = Provider.of<AuthService>(context, listen: false);
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
        Validator.validateConfirmPassword(
            _passwordController.text, _confirmPasswordController.text);
    if (validateMessageConfirmPassword != null) {
      ErrorDisplay.showErrorToast(validateMessageConfirmPassword, context);
      return;
    }

    // Show loader overlay while waiting for the response
    context.loaderOverlay.show();

    // Call the authentication service to sign up the user
    await handleAuthError(context, () async {
      final result = await authService.signUp(
        _usernameController.text,
        _mailController.text,
        _phoneController.text,
        _fullnameController.text,
        _passwordController.text,
      );
      return result;
    }, () async {
      context.loaderOverlay.hide();
      // If successful, navigate to SignInView
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInView(),
          ),
          (_) => false);
    });
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
