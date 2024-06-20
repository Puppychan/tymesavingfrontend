// Example function to render suitable icon list
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';

import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/components/common/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/user/user_sort_filter.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';


List<Widget> renderHeadingActionsBasedUserRoleAndLocation(
    BuildContext context, UserRole userRole, PageLocation pageLocation) {
  // Define icons for each role and PageLocation
  Map<UserRole, Map<PageLocation, List<IconButton>>> rolePageLocationIcons = {
      UserRole.admin: {
        PageLocation.homePage: [
          buildThemeButton(context),
          buildUserFilterButton(context)
        ],
        // PageLocation.settingsPage: [Icons.home, Icons.logout],
      },
      UserRole.customer: {
        PageLocation.homePage: [buildThemeButton(context)],
        // PageLocation.settingsPage: [Icons.home],
      },
  };

  // Get the icons for the current role and PageLocation
  List<IconButton>? icons = rolePageLocationIcons[userRole]?[pageLocation];

  // Convert IconData to Icon Widgets
  return icons?.toList() ?? [];
}

IconButton buildEditButton(BuildContext context, String type) {
  return IconButton(
    icon: const Icon(Icons.edit),
    onPressed: () {
      // Navigate to the edit page
      if (type == "transaction") {
        
      }
    },
  );
}

IconButton buildThemeButton(BuildContext context) {
  final themeProvider = Provider.of<ThemeService>(context);
  return IconButton(
    icon: Icon(
      themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
    ),
    onPressed: () {
      themeProvider.toggleTheme();
    },
  );
}

IconButton buildUserFilterButton(BuildContext context) {
  void fetchUsers() async {
    Future.microtask(() async {
      // if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.fetchUserList();
      }, () async {
        // setState(() {
        //   users = userService.users;
        // });
      });
    });
  }

  return IconButton(
      onPressed: () => showStyledBottomSheet(
          context: context,
          title: "Filter and Sort Users",
          contentWidget: UserSortFilter(updateUserList: fetchUsers)),
      icon: const Icon(Icons.filter_list_alt));
}