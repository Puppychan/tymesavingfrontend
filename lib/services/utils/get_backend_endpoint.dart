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
  // if there is no $baseUrl, the URL will be concatenated with other endpoints
  static String get userUpdate => "update";
  static String get userPasswordUpdate => "update/password";
  static String get transactionReport => "report";
}
