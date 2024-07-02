import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/input/round_text_field.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
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
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load the stored login credentials
    Future.microtask(() async {
      List<String> credentials =
          await Provider.of<AuthService>(context, listen: false)
              .loadLoginCredentials();
      if (credentials.isNotEmpty) {
        setState(() {
          _rememberMe = true;
        });
        _usernameController.text = credentials[0];
        _passwordController.text = credentials[1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> trySubmit() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final isValid = _formKey.currentState?.validate();
      // If the form is not valid, show an error
      if (isValid == null || !isValid) {
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
      }
      // If the form is valid, proceed with the login process
      // Show loader overlay while waiting for the response
      context.loaderOverlay.show();

      await handleAuthApi(context, () async {
        final result = await authService.signIn(
          _usernameController.text,
          _passwordController.text,
        );

        return result;
      }, () async {
        // nếu success
        // hiện loading
        context.loaderOverlay.hide();
        // store login credentials to auto login
        if (_rememberMe) {
          await authService.storeLoginCredentials(
            _usernameController.text,
            _passwordController.text,
          );
        } else {
          // if not remember me, clear the stored login credentials
          await authService.storeLoginCredentials("", "");
        }
        // If successful, navigate to HomePage
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPageLayout(),
            ),
            (_) => false);
      });
    }

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
            validator: Validator
                .validateUsername, // only if want to validate email under the text field
          ),
          const SizedBox(height: 20),
          RoundTextField(
            label: "Password",
            placeholder: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            isPasswordField: true,
            keyboardType: TextInputType.visiblePassword,
            validator: Validator.validatePassword,
          ),
          CheckboxListTile(
            title: const Text("Remember me"),
            value: _rememberMe,
            onChanged: (bool? value) {
              setState(() {
                _rememberMe = value!;
              });
            },
            controlAffinity: ListTileControlAffinity
                .leading, // positions the checkbox at the start of the tile
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            title: "Sign In",
            onPressed: trySubmit,
          ),
        ],
      ),
    );
  }
}
