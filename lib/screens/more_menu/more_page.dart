import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_challenge_widget.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_setting_widget.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_user_box_widget.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({super.key});

  @override
  State<MoreMenu> createState() => MoreMenuState();
}

class MoreMenuState extends State<MoreMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
      /*
        Place Holder bottom navigation bar, please replace with navigation bar when merge
      */
      BottomNavigationBar(
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
      //End of placeholder nav bar
      
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





