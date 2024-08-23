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
  static String get groupSaving => "$baseUrl/groupSaving";
  static String get invitation => "$baseUrl/invitation";
  static String get challenge => "$baseUrl/financialChallenge";
  static String get momo => "$baseUrl/payment/momo";

  // transaction
  static String get approveTransaction => "approve";
  static String get cancelledTransaction => "decline";

  // if there is no $baseUrl, the URL will be concatenated with other endpoints
  static String get userUpdate => "update";
  static String get userPasswordUpdate => "update/password";
  static String get userById => "byId";
  static String get userUploadAvatar => "update/avatar";
  static String get otherUserById => "viewUserFromId";
  static String get userSearch => "search";
  static String get transactionReport => "report";
  static String get transactionReportByUser => "byUser";

  // budget specific endpoints
  static String get budgetsGetByUserId => "byUser";
  static String get budgetGetSummaryById => "viewBudgetFromId";
  static String get budgetUpdateHost => "host/edit";
  static String get budgetDeleteHost => "host/delete";
  static String get budgetRemoveMember => "host/remove-member";
  static String get budgetGetMembers => "member-list";

  // goal specific endpoints
  static String get groupSavingsGetByUserId => "byUser";
  static String get groupSavingGetSummaryById => "viewGroupFromId";
  static String get groupSavingUpdateHost => "host/edit";
  static String get groupSavingDeleteHost => "host/delete";
  static String get groupSavingRemoveMember => "host/remove-member";
  static String get groupSavingGetMembers => "member-list";

  // invitation specific endpoints
  static String get invitationsGetByUserId => "byUser";
  static String get invitationsGetAll => "admin";
  static String get invitationsAccept => "acceptInvitation";
  static String get invitationsReject => "cancelInvitation";

  // challenge specific endpoints
  static String get challengeById => "financialChallenge";
  static String get checkpoint => "checkpoint";
  static String get challengeByUser => "byUser";
  static String get challengeProgress => "member-progress";
}
