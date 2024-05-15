import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_setting.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({super.key});

  @override
  State<MoreMenu> createState() => MoreMenuState();
}

class MoreMenuState extends State<MoreMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        //PlaceHolder here
        onTap: (int intPlaceHolder){}
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: const Column(children: [
          SizedBox(height: 50,),
          UserBox(),
          SizedBox(height: 15,),
          MoreMenuChallenge(),
          SizedBox(height: 15,),
          MoreMenuSetting(),
        ],),
      ),
    );
  }
}

class UserBox extends StatelessWidget {
  const UserBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card.filled(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Duong Zang ', style: AppTextStyles.subHeadingMedium),
              subtitle: Text('placeholder123@gmail.com'),
            )
          ],
        )
        ),
    );
  }
}

class MoreMenuChallenge extends StatelessWidget {
  const MoreMenuChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cream,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(50),
          onTap: () {
            debugPrint('Challenge tapped.');
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.primaryBlue, size: 30),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Challenge your saving skills now',style: AppTextStyles.headingSmall,),
                  Text('Let\'s go!',style: AppTextStyles.boldHeadingBlue),
                ],
              )
            ],
          )
          )
          ),
    );
  }
}



