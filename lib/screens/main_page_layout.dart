import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/heading/heading_title_based_location.dart';
import 'package:tymesavingfrontend/components/main_page_layout/show_add_options.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/budget/budget_list_page.dart';
import 'package:tymesavingfrontend/screens/group_saving/group_saving_list_page.dart';
import 'package:tymesavingfrontend/screens/home/home_admin_page.dart';
import 'package:tymesavingfrontend/screens/home/home_page.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/components/heading/heading_actions_based_location.dart';

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> with RouteAware {
  int _selectedIndex = 0;
  User? user;
  late PageController _pageController;

  void _fetchCurrentUser() async {
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
      }, () async {
        if (!mounted) return;
        setState(() {
          user = authService.user;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    print("MainPageLayout initState");
    _fetchCurrentUser();
    print("After fetchCurrentUser");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;
    user = Provider.of<AuthService>(context).user;
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up.
    _fetchCurrentUser();
    // Future.delayed(Duration(seconds: 1));
    // if (!mounted) return;m
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _heading(index: _selectedIndex, user: user),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          user?.role == UserRole.admin
              ? const HomeAdminPage()
              : HomePage(user: user),
          // TODO: Uncomment when complete goal page
          // GroupSavingListPage(user: user),
          GroupSavingListPage(user: user),
          BudgetListPage(user: user),
          const MoreMenuPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddOptions(context);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        elevation: 10.0,
        notchMargin: 12.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTabItem(
                context: context,
                index: 0,
                icon: Icons.home,
                label: 'Home',
              ),
              _buildTabItem(
                context: context,
                index: 1,
                icon: Icons.assessment,
                label: 'Savings',
              ),
              const SizedBox(width: 40.0), // The dummy child
              _buildTabItem(
                context: context,
                index: 2,
                icon: Icons.savings,
                label: 'Budgets',
              ),
              _buildTabItem(
                context: context,
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
    PageLocation? currentPageLocation = PageLocation.homePage;
    final UserRole userRole = user?.role ?? UserRole.customer;

    switch (index) {
      case 0: // Home
        currentPageLocation = PageLocation.homePage;
        break;
      case 1:
        currentPageLocation = PageLocation.savingPage;
        break;
      case 2:
        currentPageLocation = PageLocation.budgetPage;
        break;
      default:
        currentPageLocation = null;
    }

    return currentPageLocation != null
        ? Heading(
            title: renderHeadingTitleBasedUserRoleAndLocation(
                context, userRole, currentPageLocation, user?.username),
            actions: renderHeadingActionsBasedUserRoleAndLocation(
                context, userRole, currentPageLocation))
        : null;
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                  ? colorScheme.inversePrimary
                  : colorScheme.secondary,
            ),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index
                    ? colorScheme.inversePrimary
                    : colorScheme.secondary,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
