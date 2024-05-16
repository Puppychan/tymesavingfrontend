import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/app_bar_return.dart';
import 'package:tymesavingfrontend/layouts/update_user_form.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key, required this.userInfo});

  final List<String> userInfo;

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {

  void returnProfile(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserProfile()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBarReturn('My Profile', returnProfile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UpdateUserForm(userInfo: widget.userInfo,),
      ),
    );
  }
}