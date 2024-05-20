import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_padding.dart';
import 'package:tymesavingfrontend/components/heading.dart';
import 'package:tymesavingfrontend/layouts/update_user_form.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key, required this.userInfo});

  final List<String> userInfo;

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: const Heading(
        title: 'Update User',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePadding,
        child: UpdateUserForm(
          userInfo: widget.userInfo,
        ),
      ),
    );
  }
}
