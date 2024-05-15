import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';

class moreMenu extends StatefulWidget {
  const moreMenu({super.key});

  @override
  State<moreMenu> createState() => _userProfileState();
}

class _userProfileState extends State<moreMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(children: [
          const SizedBox(height: 50,),
          UserBox(),
        ],),
      ),
    );
  }
}

class UserBox extends StatelessWidget {
  const UserBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person_3),
              title: Text('PlaceHolder Full Name', style: AppTextStyles.subHeadingMedium),
              subtitle: Text('Placeholder@gmail.com'),
            )
          ],
        )
        ),
    );
  }
}