// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/constant/local_storage_key_constant.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

const EXPIRE_TOKEN_DAYS = 3;

class AuthService extends ChangeNotifier {
  // Create a private user variable to store user data in this provider
  User? _user;

  // store the current user ID variable
  // String? _username;

  // Since user variable is private, we need a getter to access it outside of this class
  User? get user => _user;

  Future<bool> isLoggedIn() async {
    final Map<String, String> keyValues =
        await LocalStorageService.getStringList([
      LOCAL_AUTH_TOKEN,
      TOKEN_EXPIRY_DATE,
      LOCAL_USER,
    ]);

    final String? token = keyValues[LOCAL_AUTH_TOKEN];
    final String? expiry = keyValues[TOKEN_EXPIRY_DATE];
    final String? user = keyValues[LOCAL_USER];

    // print("Token: $token - Expiry: $expiry - User: $user -");
    // await LoggerService.writeLog(
    //     'Token: $token, Expiry: $expiry, User: $user');

    if (token!.isNotEmpty && expiry!.isNotEmpty && user!.isNotEmpty) {
      try {
        final parsedUser = jsonDecode(user);
        // _username = parsedUser['username'];
        _user = User.fromMap(parsedUser);
        // _user = User.fromMap(user); // Assuming User has a fromJson constructor
        // _username = parsedUser['username'];
        final isExpiredToken = isExpired(expiry);
        return !isExpiredToken;
      } catch (e) {
        debugPrint("Error in isLoggedIn: $e");
        // in case there is change in User Model type and cannot login
        // signOut();
        // throw e;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> signIn(String username, String password) async {
    final response = await NetworkService.instance.post(
      BackendEndpoints.signin,
      body: {
        'username': username,
        'password': password,
      },
    );

    // Ensure response['response'] is a Map and contains the 'token'
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseBody = response['response'];
      String? token = responseBody['token'] as String?;

      if (token != null) {
        DateTime calculatedExpireDate =
            DateTime.now().add(const Duration(days: EXPIRE_TOKEN_DAYS));
        // _username = username;
        _user = User.fromMap(responseBody['user']);

        // save token to local storage
        await LocalStorageService.setStringList({
          LOCAL_AUTH_TOKEN: token,
          TOKEN_EXPIRY_DATE: calculatedExpireDate.toIso8601String(),
          LOCAL_USER: jsonEncode(_user?.toMap()),
        });
        notifyListeners();
      } else {
        debugPrint("Token is null in response body");
      }
    } else {
      debugPrint("Response body is null or not a Map");
    }
    return response;
  }

  Future<void> storeLoginCredentials(String username, String password) async {
    await LocalStorageService.setStringList({
      LOCAL_USERNAME: username,
      LOCAL_PASSWORD: password,
    });
  }

  Future<List<String>> loadLoginCredentials() async {
    final Map<String, String> keyValues =
        await LocalStorageService.getStringList([
      LOCAL_USERNAME,
      LOCAL_PASSWORD,
    ]);

    final String? username = keyValues[LOCAL_USERNAME];
    final String? password = keyValues[LOCAL_PASSWORD];

    return [username!, password!];
  }

  Future<Map<String, dynamic>> signUp(
    String username,
    String email,
    String phone,
    String fullname,
    String password,
  ) async {
    final response = await NetworkService.instance.post(
      BackendEndpoints.signup,
      body: {
        'role': UserRole.customer.toString(),
        'username': username,
        'email': email,
        'phone': phone,
        'fullname': fullname,
        'password': password,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> updateCurrentUser(
    // String username,
    BuildContext context,
    String email,
    String phone,
    String fullname,
  ) async {
    final userProvider = Provider.of<UserService>(context, listen: false);
    final response =
        await userProvider.updateUser(_user!.username, email, phone, fullname);

    if (response['response'] != null &&
        response['response'] is Map<String, dynamic> &&
        response['statusCode'] == 200) {
      final responseBody = response['response'] as Map<String, dynamic>;
      _user = User.fromMap(responseBody);
      await LocalStorageService.setString(
          LOCAL_USER, jsonEncode(_user?.toMap()));

      notifyListeners();
    }
    return response;
  }

  UserRole getCurrentUserDataRole() {
    return _user?.role ?? UserRole.customer;
  }

  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final response = await NetworkService.instance.put(
      "${BackendEndpoints.user}/${_user!.username}/${BackendEndpoints.userPasswordUpdate}",
      body: {
        'currentPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
    return response;
  }

  // Create a network call to get user details and update the state
  Future<dynamic> getCurrentUserData() async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.user}/${_user!.username}");
    // debugPrint("Called getCurrentUserData - ${response['response']}");
    if (response['response'] != null && response['statusCode'] == 200) {
      _user = User.fromMap(response['response']);
      await LocalStorageService.setString(
          LOCAL_USER, jsonEncode(_user?.toMap()));

      notifyListeners();
    }
    // return response['response']?.containsKey("id") ?? false;
    return response;
  }

  Future<void> signOut() async {
    _user = null;
    // _username = null;
    _user = null;
    await LocalStorageService.removeStringList([
      LOCAL_AUTH_TOKEN,
      TOKEN_EXPIRY_DATE,
      LOCAL_USER,
    ]);
    notifyListeners();
  }

  // Future<void> autoSignIn() async {
  //   DateTime dateTime = DateTime.parse(expiry ?? "2000-01-01");
  //   String? token = await LocalStorageService.getString(LOCAL_AUTH_TOKEN);
  //   String? username = await LocalStorageService.getString(LOCAL_USERNAME);
  //   if (token != null && token.isNotEmpty && username != null && username.isNotEmpty) {
  //     _token = token;
  //     _username = username;
  //     await getCurrentUserData();
  //   }
  // }

  bool isExpired(String? expiry) {
    debugPrint("Expiry: $expiry -");
    DateTime datetime;
    try {
      if (expiry != null && expiry.isNotEmpty) {
        datetime = DateTime.parse(expiry);
      } else {
        datetime = DateTime(2000, 1, 1);
      }
    } catch (e) {
      datetime = DateTime(2000, 1, 1);
    }
    DateTime timeNow = DateTime.now();
    return timeNow.isAfter(datetime);
  }

  // This handles the logic to automatically login user when they open our application
  Future<bool> tryAutoLogin() async {
    final loggedIn = await isLoggedIn();
    if (loggedIn) {
      notifyListeners();
    }
    return loggedIn;
  }
}
