// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/local_storage_key.constant.dart';
import 'package:tymesavingfrontend/common/user_role.enum.dart';
import 'package:tymesavingfrontend/models/user.model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

const EXPIRE_TOKEN_DAYS = 5;

class AuthService extends ChangeNotifier {
  // Create a private user variable to store user data in this provider
  User? _user;

  // Create a private token variable to store user authentication token
  String? _token;
  // store the current user ID variable
  String? _username;

  // Since user variable is private, we need a getter to access it outside of this class
  User? get user => _user;

  Future<bool> isLoggedIn() async {
    final Map<String, String> keyValues = await LocalStorageService.getStringList([
      LOCAL_AUTH_TOKEN,
      TOKEN_EXPIRY_DATE,
      LOCAL_USER,
    ]);

    final String? token = keyValues[LOCAL_AUTH_TOKEN];
    final String? expiry = keyValues[TOKEN_EXPIRY_DATE];
    final String? user = keyValues[LOCAL_USER];

    print("Token: $token - Expiry: $expiry - User: $user -");

    if (token!.isNotEmpty && expiry!.isNotEmpty && user!.isNotEmpty) {
      print("True");
      final parsedUser = jsonDecode(user);
      // _token = token;
      // _username = parsedUser['username'];
      _user = User.fromMap(parsedUser);
      _token = token;
      // _user = User.fromMap(user); // Assuming User has a fromJson constructor
      _username = parsedUser['username'];
      return !isExpired(expiry);
    }
    print("False");
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
    if (response['response'] != null &&
        response['response'] is Map<String, dynamic>) {
      final responseBody = response['response'] as Map<String, dynamic>;
      String? token = responseBody['token'] as String?;

      if (token != null) {
        DateTime calculatedExpireDate =
            DateTime.now().add(const Duration(days: EXPIRE_TOKEN_DAYS));
        _token = token;
        _username = username;

        // save token to local storage
        await LocalStorageService.setStringList({
          LOCAL_AUTH_TOKEN: token,
          TOKEN_EXPIRY_DATE: calculatedExpireDate.toIso8601String(),
        });
      } else {
        print("Token is null");
      }
    } else {
      print("Response body is null or not a Map");
    }
    return response;
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

  // Create a network call to get user details and update the state
  Future<bool> getCurrentUserData() async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.user}/$_username");
    if (response != null && response.statusCode == 200) {
      _user = User.fromMap(response);
      await LocalStorageService.setString(
          LOCAL_USER, jsonEncode(_user?.toMap()));

      notifyListeners();
    }
    return response?.containsKey("id") ?? false;
  }

  Future<void> signOut() async {
    _user = null;
    _token = null;
    _username = null;
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
    print("Expiry: $expiry -");
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
