import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/screens/HomePage.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          HomePage(title: "Home"),
          Center(child: Text('Goals')),
          Center(child: Text('Budgets')),
          MoreMenuPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(
          Icons.add,
          color: AppColors.cream,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        surfaceTintColor: AppColors.navBackground,
        color: AppColors.navBackground,
        shadowColor: AppColors.secondary.withOpacity(0.4),
        notchMargin: 12.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTabItem(
                index: 0,
                icon: Icons.home,
                label: 'Home',
              ),
              _buildTabItem(
                index: 1,
                icon: Icons.assessment,
                label: 'Goals',
              ),
              const SizedBox(width: 40.0), // The dummy child
              _buildTabItem(
                index: 2,
                icon: Icons.savings,
                label: 'Budgets',
              ),
              _buildTabItem(
                index: 3,
                icon: Icons.menu,
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        color: Colors.transparent,
        // padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: _selectedIndex == index
                  ? AppColors.primary
                  : AppColors.secondary,
            ),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index
                    ? AppColors.primary
                    : AppColors.secondary,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
