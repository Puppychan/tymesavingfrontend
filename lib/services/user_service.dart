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

  String _roleFilter = 'All';
  Map<String, String> _sortOption = {"sortUsername": 'ascending'};

  // user list
  List<User> _users = [];
  User? _currentFetchUser;

  // List<String> get filterData => _filterData;
  String get roleFilter => _roleFilter;
  String get sortOption => _convertSortOptionToString();
  List<User> get users => _users;
  User? get currentFetchUser => _currentFetchUser;

  String _convertSortOptionToString() {
    final tempSortValue = _sortOption.keys.first;
    String sortValue = '';
    switch (tempSortValue) {
      case 'sortUsername':
        sortValue = 'Username';
        break;
      case 'sortCreation':
        sortValue = 'Created Date';
        break;
      case 'sortRole':
        sortValue = 'Role';
        break;
    }
    return '$sortValue in ${_sortOption.values.first} order';
  }

  Future<dynamic> fetchUserList() async {
    String endpoint = BackendEndpoints.user;

    bool hasQuery = false; // check if there is a query in the endpoint
    // add the filter options to the endpoint
    if (_roleFilter.isNotEmpty && _roleFilter != 'All') {
      endpoint += "?filterRole=$_roleFilter";
      hasQuery = true;
    }
    // add the sort options to the endpoint
    if (_sortOption.isNotEmpty) {
      String sortParam =
          "${_sortOption.keys.first}=${_sortOption.values.first}";
      if (hasQuery) {
        endpoint += "&$sortParam";
      } else {
        endpoint += "?$sortParam";
        hasQuery = true;
      }
    }

    // make the API call
    final response = await NetworkService.instance.get(endpoint);
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
      // in case having multiple filter options
      _roleFilter = value;
    }
    notifyListeners();
  }

  void updateSortOptions(String newSortValue) {
    // separate the sort value and the order
    // format: 'Username in Ascending order'
    final tempSortValue = newSortValue.split(' ')[0];
    final order = newSortValue.split(' ')[2];

    String sortValue = '';

    switch (tempSortValue) {
      case 'Username':
        sortValue = 'sortUsername';
        break;
      case 'Created Date':
        sortValue = 'sortCreation';
        break;
      case 'Role':
        sortValue = 'sortRole';
        break;
    }

    // update the sort option
    _sortOption = {
      sortValue: order,
    };

    notifyListeners();
  }

    Future<dynamic> getCurrentUserData(username) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.user}/$username");
    debugPrint("Response in getCurrentUserData: $response");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentFetchUser = User.fromMap(response['response']);
      notifyListeners();
    }
    // return response['response']?.containsKey("id") ?? false;
    return response;
  }

    Future<Map<String, dynamic>> updateUser(
    String username,
    String email,
    String phone,
    String fullname,
  ) async {
    final response = await NetworkService.instance.put(
      "${BackendEndpoints.user}/$username/${BackendEndpoints.userUpdate}",
      body: {
        // 'username': username, 
        'email': email,
        'phone': phone,
        'fullname': fullname,
      },
    );
    if (response['response'] != null &&
        response['response'] is Map<String, dynamic> &&
        response['statusCode'] == 200) {
      final responseBody = response['response'] as Map<String, dynamic>;
      final updatedUser = User.fromMap(responseBody);
      // update the user in the list
      final index = _users.indexWhere((element) => element.username == username);
      _users[index] = updatedUser;

      notifyListeners();
    }
    return response;
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
    _sortOption = {};
    // _filteredUsers.clear();
    notifyListeners();
  }
}
