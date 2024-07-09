import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackendEndpoints {
  static String get baseUrl {
    // Use the correct IP based on the environment
    if (Platform.isAndroid) {
      return dotenv.env['BASE_URL_ANDROID'] ?? ""; // Android emulator
    } else if (Platform.isIOS) {
      return dotenv.env['BASE_URL_IOS'] ?? ""; // iOS simulator
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Use localhost for desktop platforms (assuming backend is on the same machine)
      return dotenv.env['BASE_URL_DESKTOP'] ?? "";
    } else {
      // Default to localhost for other platforms or environments
      return dotenv.env['BASE_URL_DESKTOP'] ?? "";
    }
  }

  static String get user => "$baseUrl/user";
  static String get signin => "$baseUrl/user/signin";
  static String get signup => "$baseUrl/user/signup";
  static String get transaction => "$baseUrl/transaction";
  static String get budget => "$baseUrl/sharedBudget";
  static String get goal => "$baseUrl/groupSaving";
  static String get invitation => "$baseUrl/invitation";

  // if there is no $baseUrl, the URL will be concatenated with other endpoints
  static String get userUpdate => "update";
  static String get userPasswordUpdate => "update/password";
  static String get userById => "byId";
  static String get otherUserById => "viewUserFromId";
  static String get userSearchByUsername => "viewUserFromUsername";
  static String get transactionReport => "report";
  static String get transactionReportByUser => "byUser";

  // budget specific endpoints
  static String get budgetsGetByUserId => "byUser";
  static String get budgetGetSummaryById => "viewBudgetFromId";
  static String get budgetUpdateHost => "host/edit";
  static String get budgetRemoveMember => "host/remove-member";
  static String get budgetGetMembers => "member-list";
  
  // goal specific endpoints
  static String get goalsGetByUserId => "byUser";
  static String get goalGetSummaryById => "viewGoalFromId";
  static String get goalUpdateHost => "host/edit";
  static String get goalRemoveMember => "host/remove-member";
  static String get goalGetMembers => "member-list";

  // goal specific endpoints
  static String get goalByUserId => "byUser";

  // invitation specific endpoints
  static String get invitationsGetByUserId => "byUser";
  static String get invitationsGetAll => "admin";
  static String get invitationsAccept => "acceptInvitation";
  static String get invitationsReject => "cancelInvitation";
}
