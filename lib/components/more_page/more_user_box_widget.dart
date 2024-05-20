import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/common/temp.constant.dart';
import 'package:tymesavingfrontend/components/circle_network_image.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile_page.dart';

class UserBox extends StatefulWidget {
  const UserBox({super.key});

  @override
  State<UserBox> createState() => _UserBoxState();
}

class _UserBoxState extends State<UserBox> {
  void goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('profile tapped');
        goToProfile();
      },
      child: const Card.filled(
        color: AppColors.cream,
        elevation: 3.0,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CustomCircleAvatar(imagePath: TEMP_AVATAR_IMAGE),
                  title:
                      Text('Duong Zang', style: AppTextStyles.subHeadingMedium),
                  subtitle: Text('placeholder123@gmail.com'),
                )
              ],
            )),
      ),
    );
  }
}
