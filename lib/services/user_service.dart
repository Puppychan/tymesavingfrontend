import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class UserService extends ChangeNotifier {
  //   Map<String, dynamic> _filterOptions = {
  //   'sortBy': 'Date',
  //   'sortRole': 'true',
  //   'sortCreation': 'ascending',
  //   'filterRole': 'All',
  // };

  String _roleFilter = '';

  List<User> _users = [];

  // List<String> get filterData => _filterData;
  String get roleFilter => _roleFilter;
  List<User> get users => _users;

  Future<dynamic> fetchUserList() async {
    String endpoint = BackendEndpoints.user;
    // add the filter options to the endpoint
    if (_roleFilter.isNotEmpty && _roleFilter != 'All') {
      endpoint += "?filterRole=$_roleFilter";
    }

    // make the API call
    final response =
        await NetworkService.instance.get(endpoint);
    debugPrint("Response from fetchUserList: $response");
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

    void updateFilterOptions(String key, String value) {
    // _filterOptions[key] = value;
    if (key == 'role') {
      _roleFilter = value;
      debugPrint('Filter: $_roleFilter');
    }
    notifyListeners();
  }

  Future<dynamic> deleteUser(username) async {
    final response = await NetworkService.instance
        .delete("${BackendEndpoints.user}/$username");
    if (response['response'] != null && response['statusCode'] == 200) {
      // final responseBody = response['response'];
      _users.removeWhere((element) => element.username == username);
      // convert the response to a list of User objects
      // _users = responseBody.map<User>((item) => User.fromMap(item as Map<String, dynamic>)).toList();
      notifyListeners();
    }
    return response;
  }

  void clearFilter() {
    _roleFilter = '';
    // _filteredUsers.clear();
    notifyListeners();
  }
}
