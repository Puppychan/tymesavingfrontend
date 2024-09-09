import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/form/update_password_form.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile_page.dart';
import 'package:tymesavingfrontend/utils/dismiss_keyboard.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  void returnProfile() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserProfile()),
        (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // dismiss keyboard
        dismissKeyboardAndAct(context);
      },
      child: const Scaffold(
        appBar: Heading(
          title: "Update Password",
          showBackButton: true,
        ),
        body: Padding(
          padding: AppPaddingStyles.pagePadding,
          child: UpdatePasswordForm(),
        ),
      ),
    );
  }
}
