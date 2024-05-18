// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/local_storage_key.constant.dart';
import 'package:tymesavingfrontend/common/user_role.constant.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class AuthService {
  // late final String baseUrl;

  // AuthService() {
  //   _client = NetworkService();
  // }

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
        // save token to local storage
        await LocalStorageService.setString(LOCAL_AUTH_TOKEN, token);
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
        'role': ROLE_CUSTOMER,
        'username': username,
        'email': email,
        'phone': phone,
        'fullname': fullname,
        'password': password,
      },
    );
    return response;
  }
}
