import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/user_model.dart';

String renderHeadingTitleBasedUserRoleAndLocation(BuildContext context,
    UserRole userRole, PageLocation pageLocation, String? username) {
  // Define icons for each role and PageLocation
  Map<UserRole, Map<PageLocation, String>> rolePageLocationIcons = {
    UserRole.admin: {
      PageLocation.homePage: "Admin Dashboard",
      // PageLocation.savingPage: "Saving Goals",
      PageLocation.settingsPage: "",
    },
    UserRole.customer: {
      PageLocation.homePage: "Hi, $username",
      PageLocation.savingPage: "Saving Goals",
      PageLocation.budgetPage: "Budgets",
      // PageLocation.settingsPage: [Icons.home],
    },
  };

  return rolePageLocationIcons[userRole]?[pageLocation] ?? '';
}


