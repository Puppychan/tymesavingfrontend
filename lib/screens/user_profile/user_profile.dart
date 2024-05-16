import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/components/app_bar_return.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/components/secondary_button.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';
import 'package:tymesavingfrontend/screens/user_profile/build_info_template.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final String fullName = 'Zang Zuong';
  final String userName = 'zinggiang';
  final String phone = '0123456789';
  final String email = 'c.test123@gmail.com';

  void returnSetting(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MoreMenu()),);
  }

  List<String> openUpdateForm(){
    List<String> valueList = [];
    valueList.add(fullName);
    valueList.add(userName);
    valueList.add(phone);
    valueList.add(email);

    return valueList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarReturn('My Profile', returnSetting),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BuildInfo('Full name', fullName,const Icon(Icons.badge_outlined)),
            BuildInfo('User name', userName,const Icon(Icons.alternate_email_outlined)),
            BuildInfo('Phone', phone,const Icon(Icons.contact_phone_outlined)),
            BuildInfo('Email', email,const Icon(Icons.email_outlined)),
            const Expanded(child: SizedBox(),),
            Card.filled(
              color: AppColors.white,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                children: [
                  PrimaryButton(title: 'EDIT PROFILE', onPressed: (){}),
                  const SizedBox(height: 5,),
                  SecondaryButton(title: 'CHANGE PASSWORD', onPressed: (){})
                ],),)
          ],
          ),
        ),
    );
  }
}