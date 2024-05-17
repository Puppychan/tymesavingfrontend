import 'dart:convert'; // For jsonEncode
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
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
    return response;

    // print('Final signin: $response');

    // if (response.statusCode == 200) {
    //   // If the server returns an OK response, parse the JSON.
    //   // final Map<String, dynamic> data = jsonDecode(response.body);
    //   // Map<String, dynamic> data = jsonDecode(response.body);

    //   print('Sign Sign-in successful: $response');
    //   // Handle success (e.g., navigate to another page or store user data)
    // } else {
    //   // If the server returns an error response, throw an exception.
    //   print('Failed to sign in: ${response.statusCode} - $response');
    //   // Handle error (e.g., show error message to the user)
    // }
  }
}
