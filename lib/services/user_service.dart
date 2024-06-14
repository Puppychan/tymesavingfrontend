import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';class UserService extends ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  String _filter = '';

  List<User> get users => _filteredUsers.isNotEmpty ? _filteredUsers : _users;

  Future<dynamic> fetchUserList() async {
    final response =
        await NetworkService.instance.get("${BackendEndpoints.user}");
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseBody = response['response'];
      // convert the response to a list of User objects
      _users = responseBody
          .map<User>((item) => User.fromMap(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> deleteUser(username) async {
    final response =
        await NetworkService.instance.delete("${BackendEndpoints.user}/$username");
    if (response['response'] != null && response['statusCode'] == 200) {
      // final responseBody = response['response'];
      _users.removeWhere((element) => element.username == username);
      // convert the response to a list of User objects
      // _users = responseBody.map<User>((item) => User.fromMap(item as Map<String, dynamic>)).toList();
      notifyListeners();
    }
    return response;
  }

  // void filterUsers(String group) {
  //   _filter = group;
  //   _filteredUsers = _users.where((user) => user.group == group).toList();
  //   notifyListeners();
  // }

  void clearFilter() {
    _filter = '';
    _filteredUsers.clear();
    notifyListeners();
  }
}
