import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/user.model.dart';
import 'package:tymesavingfrontend/screens/home/home_admin_page.dart';
import 'package:tymesavingfrontend/screens/home/home_page.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> with RouteAware {
  int _selectedIndex = 0;
  User? user;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
      }, () async {
        setState(() {
          user = authService.user;
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up.
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
        // return result;
      }, () async {
        setState(() {
          user = authService.user;
        });
      });
    });
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
      appBar: _heading(index: _selectedIndex, user: user),
      backgroundColor: AppColors.cream,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          user?.role == UserRole.admin ? const HomeAdminPage() : const HomePage(),
          const Center(child: Text('Goals')),
          const Center(child: Text('Budgets')),
          const MoreMenuPage(),
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

  PreferredSizeWidget? _heading({required int index, User? user}) {
    String displayTitle = '';

    switch (index) {
      case 0: // Home
        displayTitle = user?.role == UserRole.admin
            ? 'Users Management'
            : 'Hi, ${user?.fullname}';
        break;
      case 1:
        displayTitle = 'Goals';
        break;
      case 2:
        displayTitle = 'Budgets';
        break;
    }

    return displayTitle.isNotEmpty
        ? Heading(
            title: displayTitle,
          )
        : null;
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
