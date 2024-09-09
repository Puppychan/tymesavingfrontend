import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/form/update_user_form.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/utils/dismiss_keyboard.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key, required this.user});

  final User? user;
  // final List<String> userInfo;

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // dismiss keyboard
        dismissKeyboardAndAct(context);        
      },
      child: Scaffold(
        appBar: const Heading(
          title: 'Update User',
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: AppPaddingStyles.pagePadding,
          child: UpdateUserForm(
            user: widget.user,
          ),
        ),
      ),
    );
  }
}
