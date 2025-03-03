import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';

String renderHeadingTitleBasedUserRoleAndLocation(BuildContext context,
    UserRole userRole, PageLocation pageLocation, String? username) {
  // Define icons for each role and PageLocation
  Map<UserRole, Map<PageLocation, String>> rolePageLocationIcons = {
    UserRole.admin: {
      PageLocation.homePage: "Admin Dashboard",
      // PageLocation.savingPage: "Saving GroupSavings",
      PageLocation.settingsPage: "",
    },
    UserRole.customer: {
      PageLocation.homePage: "Hi, $username",
      PageLocation.budgetPage: "Budget groups",
      PageLocation.savingPage: "Saving groups",
      // PageLocation.settingsPage: [Icons.home],
    },
  };

  return rolePageLocationIcons[userRole]?[pageLocation] ?? '';
}


