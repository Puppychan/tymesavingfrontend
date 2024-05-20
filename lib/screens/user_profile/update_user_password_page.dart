import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_padding.dart';
import 'package:tymesavingfrontend/components/heading.dart';
import 'package:tymesavingfrontend/layouts/update_password_form.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile_page.dart';

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
    return const Scaffold(
      backgroundColor: AppColors.cream,
      appBar: Heading(
        title: "Update Password",
        showBackButton: true,
      ),
      body: Padding(
        padding: AppPaddingStyles.pagePadding,
        child: UpdatePasswordForm(),
      ),
    );
  }
}
