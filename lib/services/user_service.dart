import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/models/base_user_model.dart';
import 'package:tymesavingfrontend/models/member_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
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
  SummaryUser? _summaryUser;
  List<UserBase> _searchUserList = [];
  List<Member> _members = [];

  // List<String> get filterData => _filterData;
  String get roleFilter => _roleFilter;
  Map<String, String> get sortOption => _convertSortOptionToString();
  List<User> get users => _users;
  User? get currentFetchUser => _currentFetchUser;
  SummaryUser? get summaryUser => _summaryUser;
  List<UserBase> get searchUserList => _searchUserList;
  List<Member> get members => _members;

  Map<String, String> _convertSortOptionToString() {
    final sortOrder = _sortOption.values.first.toLowerCase();
    switch (_sortOption.keys.first) {
      case 'sortUsername':
        return {'Username': sortOrder};
      case 'sortCreation':
        return {'Created Date': sortOrder};
      case 'sortRole':
        return {'Role': sortOrder};
    }
    return {'': sortOrder};
    // return '$sortValue in ${_sortOption.values.first} order';
  }

  List<String> combineOptions() {
    return ["Username", "Created Date", "Role"];
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

  Future<dynamic> fetchGroupMemberList(
      bool isBudgetGroup, String? groupId) async {
    String endpoint = "";
    if (isBudgetGroup) {
      endpoint =
          "${BackendEndpoints.budget}/$groupId/${BackendEndpoints.budgetGetMembers}";
    } else {
      endpoint =
          "${BackendEndpoints.groupSaving}/$groupId/${BackendEndpoints.groupSavingGetMembers}";
    }
    final response = await NetworkService.instance.get(endpoint);
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Member> memberList = [];
      if (responseData != [] && responseData != null) {
        for (var member in responseData) {
          final tempMember = Member.fromMap(member);
          memberList.add(tempMember);
        }
      }
      _members = memberList;
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> removeGroupMember(
      bool isBudgetGroup, String? groupId, String memberId) async {
    final response = await NetworkService.instance.delete(
        "${BackendEndpoints.budget}/$groupId/${BackendEndpoints.budgetRemoveMember}/$memberId");
    if (response['response'] != null && response['statusCode'] == 200) {
      _members.removeWhere((element) => element.user.id == memberId);
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

  void updateSortOptions(String newSortField, String newSortValue) {
    String sortField = '';

    switch (newSortField) {
      case 'Username':
        sortField = 'sortUsername';
        break;
      case 'Created Date':
        sortField = 'sortCreation';
        break;
      case 'Role':
        sortField = 'sortRole';
        break;
    }

    // update the sort option
    _sortOption = {
      sortField: newSortValue.toLowerCase(),
    };

    notifyListeners();
  }

  Future<dynamic> getCurrentUserData(username) async {
    final response =
        await NetworkService.instance.get("${BackendEndpoints.user}/$username");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentFetchUser = User.fromMap(response['response']);
      notifyListeners();
    }
    // return response['response']?.containsKey("id") ?? false;
    return response;
  }

  Future<dynamic> getUserDataById(
    id,
  ) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.user}/${BackendEndpoints.userById}/$id");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentFetchUser = User.fromMap(response['response']);
      notifyListeners();
    }
    // return response['response']?.containsKey("id") ?? false;
    return response;
  }

  Future<dynamic> getOtherUserInfo(String? id,
      {String? sharedBudgetId, String? groupSavingId}) async {
    if (id == null) return;
    String endpoint =
        "${BackendEndpoints.user}/${BackendEndpoints.otherUserById}/$id";
    if (sharedBudgetId != null) {
      endpoint += "?sharedBudgetId=$sharedBudgetId";
    } else if (groupSavingId != null) {
      endpoint += "?groupSavingId=$groupSavingId";
    }
    
    final response = await NetworkService.instance.get(endpoint);
    debugPrint(response.toString());
    if (response['response'] != null && response['statusCode'] == 200) {
      _summaryUser = SummaryUser.fromMap(response['response']);
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> searchUsers(String? query,
      {String? exceptGroupId,
      InvitationType? type,
      List<dynamic>? exceptUsers,
      CancelToken? cancelToken}) async {
    // define the endpoint
    String endpoint = "${BackendEndpoints.user}/${BackendEndpoints.userSearch}";
    if (query != null && query.isNotEmpty) {
      endpoint += "?query=$query";
    }
    // add the query parameters to the endpoint
    if (exceptGroupId != null && type != null) {
      // Check if there is already a query parameter added
      String separator = endpoint.contains('?') ? '&' : '?';

      if (type == InvitationType.budget) {
        endpoint += "${separator}exceptBudgetId=$exceptGroupId";
      } else if (type == InvitationType.savings) {
        endpoint += "${separator}exceptSavingId=$exceptGroupId";
      }
    }
    final response =
        await NetworkService.instance.get(endpoint, cancelToken: cancelToken);
    if (response['response'] != null) {
      if (response['statusCode'] == 200) {
        final responseBody = response['response'];
        // get the list of usernames to exclude from the search results
        // specific case: if add user to the form, and want to exclude the users that already in the form (not call to Backend yet)
        final exceptUsernames =
            exceptUsers?.map((user) => user.username).toSet() ?? {};

        // convert the response to a list of User objects
        _searchUserList = responseBody
            .where((item) =>
                item.containsKey('username') &&
                !exceptUsernames.contains(item['username']))
            .map<UserBase>((item) => UserBase.fromMap(item))
            .toList();
        // if empty list
        if (_searchUserList.isEmpty) {
          _searchUserList = [];
          response['statusCode'] = 404;
        }
      } else if (response['statusCode'] == 404) {
        _searchUserList = [];
      }
      notifyListeners();
    }
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
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseBody = response['response'] as Map<String, dynamic>;
      final updatedUser = User.fromMap(responseBody);
      // update the user in the list
      final index =
          _users.indexWhere((element) => element.username == username);
      _users[index] = updatedUser;

      notifyListeners();
    }
    return response;
  }

  Future<dynamic> uploadUserAvatar(String? username, String imagePath) async {
    if (username == null) return;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imagePath, filename: 'file'),
    });

    final response = await NetworkService.instance.putFormData(
      "${BackendEndpoints.user}/$username/${BackendEndpoints.userUploadAvatar}",
      data: formData,
    );
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseBody = response['response'];
      final updatedUser = User.fromMap(responseBody);
      // update the user in the list
      if (users.isNotEmpty) {
        final index =
            _users.indexWhere((element) => element.username == username);
        if (index != -1) {
          _users[index] = updatedUser;
        }
        notifyListeners();
      }
      if (currentFetchUser != null && currentFetchUser?.username == username) {
        _currentFetchUser = updatedUser;
        notifyListeners();
      }
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
