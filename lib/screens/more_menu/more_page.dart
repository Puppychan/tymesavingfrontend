import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_challenge_widget.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_setting_widget.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_user_box_widget.dart';

class MoreMenuPage extends StatefulWidget {
  const MoreMenuPage({super.key});

  @override
  State<MoreMenuPage> createState() => MoreMenuState();
}

class MoreMenuState extends State<MoreMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: const Column(children: [
          SizedBox(height: 50,),
          UserBox(),
          SizedBox(height: 15,),
          MoreMenuChallenge(),
          SizedBox(height: 15,),
          MoreMenuSetting(),
        ],),
      );
  }
}





