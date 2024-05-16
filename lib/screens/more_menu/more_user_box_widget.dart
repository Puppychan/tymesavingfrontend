import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile.dart';

class UserBox extends StatefulWidget {
  const UserBox({super.key});

  @override
  State<UserBox> createState() => _UserBoxState();
}

class _UserBoxState extends State<UserBox> {

  void goToProfile(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserProfile()),);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('profile tapped');
        goToProfile();
      },
      child: Card.filled(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Duong Zang', style: AppTextStyles.subHeadingMedium),
              subtitle: Text('placeholder123@gmail.com'),
            )
          ],
        )
        ),
    ),
    );
  }
}