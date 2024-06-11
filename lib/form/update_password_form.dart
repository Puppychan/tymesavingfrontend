import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/round_text_field.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

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
  final String password = 'password placeholder';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddingStyles.pagePadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundTextField(
              placeholder: password,
              label: 'Password',
              obscureText: true,
              isPasswordField: true,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 15),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            RoundTextField(
              placeholder: password,
              label: 'Your new password',
              obscureText: true,
              controller: _newPasswordController,
              isPasswordField: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 15),
            RoundTextField(
              placeholder: password,
              label: 'Re-enter Password',
              obscureText: true,
              controller: _confirmPasswordController,
              isPasswordField: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              title: 'UPDATE',
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Process form submission
    String password = _passwordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    final String? validateMessagePassword =
        Validator.validatePassword(password);
    if (validateMessagePassword != null) {
      ErrorDisplay.showErrorToast(validateMessagePassword, context);
      return;
    }

    final String? validateNewPassword = Validator.validatePassword(newPassword);
    if (validateNewPassword != null) {
      ErrorDisplay.showErrorToast(validateNewPassword, context);
      return;
    }

    final String? validateMessageConfirmPassword =
        Validator.validateConfirmPassword(password, confirmPassword);
    if (validateMessageConfirmPassword != null) {
      ErrorDisplay.showErrorToast(validateMessageConfirmPassword, context);
      return;
    }
    /*
    Code for submitting and linkage with back-end to update user password here
    */

    await handleMainPageApi(context, () async {
      final authService = Provider.of<AuthService>(context, listen: false);
      return await authService.changePassword(newPassword, newPassword);
    }, () async {
      // setState(() {
      //   user = authService.user;
      // });
      Navigator.pop(context);
    });
  }
}
