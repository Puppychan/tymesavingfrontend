import 'dart:convert'; // For jsonEncode
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class AuthService {
  
  // late final String baseUrl;

  // AuthService() {

  // }
  final NetworkService _client;

  Future<void> signIn(String username, String password) async {
    // final url = Uri.parse(BackendEndpoints.signin);

    // final response = await http.post(
    //   url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'username': username,
    //     'password': password,
    //   }),
    // );

    final response = await _client.post(
        BackendEndpoints.signin,
        body: {
          'username': username,
          'password': password,
        },
      );

    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON.
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Sign-in successful: $data');
      // Handle success (e.g., navigate to another page or store user data)
    } else {
      // If the server returns an error response, throw an exception.
      print('Failed to sign in: ${response.body}');
      // Handle error (e.g., show error message to the user)
    }
  }
}
