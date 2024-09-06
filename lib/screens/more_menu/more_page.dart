import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/more_page/more_challenge_widget.dart';
import 'package:tymesavingfrontend/components/more_page/more_setting_widget.dart';
import 'package:tymesavingfrontend/components/more_page/more_user_box_widget.dart';

class MoreMenuPage extends StatefulWidget {
  const MoreMenuPage({super.key});

  @override
  State<MoreMenuPage> createState() => MoreMenuState();
}

class MoreMenuState extends State<MoreMenuPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: AppPaddingStyles.pagePadding,
      child: Column(
        children: const [
          SizedBox(height: 50),
          UserBox(),
          SizedBox(height: 15),
          MoreMenuChallenge(),
          SizedBox(height: 15),
          MoreMenuSetting(),
        ],
      ),
    );
  }
}





